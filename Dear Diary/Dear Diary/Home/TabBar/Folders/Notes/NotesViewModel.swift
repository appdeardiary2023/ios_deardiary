//
//  NotesViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import DearDiaryStrings
import DearDiaryImages

protocol NotesViewModelListener: AnyObject {
    func updateNotesCount(in folderId: String, by count: Int)
}

protocol NotesViewModelPresenter: AnyObject {
    func insertNote(at indexPath: IndexPath)
    func reloadNote(at indexPath: IndexPath)
    func reloadNotes(in section: IndexSet)
    func scroll(to indexPath: IndexPath)
    func reload()
    func push(_ viewController: UIViewController)
    func dismiss()
}

protocol NotesViewModelable: ViewLifecyclable {
    var backButtonImage: UIImage? { get }
    var addButtonImage: UIImage? { get }
    var title: String { get }
    var notes: [NoteModel] { get }
    var notesCount: Int { get }
    var presenter: NotesViewModelPresenter? { get set }
    func backButtonTapped()
    func addButtonTapped()
    func isLongNote(at indexPath: IndexPath) -> Bool
    func getCellViewModel(at indexPath: IndexPath) -> NoteCellViewModelable?
    func didSelectNote(at indexPath: IndexPath)
}

final class NotesViewModel: NotesViewModelable,
                            Alertable {
    
    private let folder: FolderModel
    private var noteData: Note?
    private weak var listener: NotesViewModelListener?
    
    weak var presenter: NotesViewModelPresenter?
    
    init(folder: FolderModel, listener: NotesViewModelListener?) {
        self.folder = folder
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension NotesViewModel {
    
    var backButtonImage: UIImage? {
        return Image.back.asset
    }
    
    var addButtonImage: UIImage? {
        return Image.add.asset
    }
    
    var title: String {
        return folder.title
    }
    
    var notes: [NoteModel] {
        return noteData?.models ?? []
    }
    
    var notesCount: Int {
        return noteData?.meta.count ?? 0
    }
    
    func backButtonTapped() {
        presenter?.dismiss()
    }
    
    func addButtonTapped() {
        // Show add note screen
        showNoteScreen(with: .add(date: Date(), number: notes.count + 1))
    }
    
    func screenDidLoad() {
        noteData = UserDefaults.fetchNoteData(for: folder.id)
        presenter?.reload()
    }
    
    func isLongNote(at indexPath: IndexPath) -> Bool {
        return (indexPath.item - 1) % 6 == 0 || (indexPath.item - 3) % 6 == 0
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> NoteCellViewModelable? {
        guard let note = notes[safe: indexPath.item] else { return nil }
        let isInverted = isLongNote(at: indexPath)
        return NoteCellViewModel(
            flow: .folder(isInverted: isInverted),
            note: note,
            listener: self
        )
    }
    
    func didSelectNote(at indexPath: IndexPath) {
        guard let note = notes[safe: indexPath.item] else { return }
        // Show edit note screen
        showNoteScreen(with: .edit(note: note))
    }
    
}

// MARK: - Private Helpers
private extension NotesViewModel {
    
    func showNoteScreen(with flow: NoteViewModel.Flow) {
        let viewModel = NoteViewModel(
            flow: flow,
            folderTitle: folder.title,
            listener: self
        )
        let viewController = NoteViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        viewModel.presenter = viewController
        presenter?.push(viewController)
    }
        
}

// MARK: - NoteCellViewModelListener Methods
extension NotesViewModel: NoteCellViewModelListener {
    
    func longPressRecognized(for note: NoteModel) {
        var title = Strings.Alert.delete
        if let noteTitle = note.title?.toAttributedString?.string,
           !noteTitle.isEmpty {
            title.append(" \"\(noteTitle)\"?")
        } else if var content = note.content?.toAttributedString?.string,
                  !content.isEmpty {
            let length = Constants.Note.maxDeleteAlertContentLength
            content = content.count > length ? "\(content.prefix(length))..." : content
            title.append(" \"\(content)\"?")
        }
        showAlert(with: title, actionTitle: Strings.Alert.delete, onAction: { [weak self] in
            self?.deleteNote(note, needsDataSourceUpdate: true)
        })
    }
    
}

// MARK: - NoteViewModelListener Methods
extension NotesViewModel: NoteViewModelListener {
    
    func noteAdded(_ note: NoteModel, needsDataSourceUpdate: Bool) {
        let indexPath = IndexPath(item: notes.count, section: 0)
        noteData?.models.append(note)
        noteData?.meta.count += 1
        UserDefaults.saveNoteData(for: folder.id, with: noteData)
        listener?.updateNotesCount(in: folder.id, by: 1)
        guard needsDataSourceUpdate else { return }
        presenter?.insertNote(at: indexPath)
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.scroll(to: indexPath)
        }
    }
    
    func noteEdited(replacing note: NoteModel, with editedNote: NoteModel?, needsDataSourceUpdate: Bool) {
        guard let index = notes.firstIndex(of: note),
              let editedNote = editedNote else { return }
        let indexPath = IndexPath(item: index, section: 0)
        noteData?.models[index] = editedNote
        UserDefaults.saveNoteData(for: folder.id, with: noteData)
        guard needsDataSourceUpdate else { return }
        presenter?.reloadNote(at: indexPath)
    }
    
    func deleteNote(_ note: NoteModel, needsDataSourceUpdate: Bool) {
        noteData?.models.removeAll(where: { $0 == note })
        noteData?.meta.count -= 1
        listener?.updateNotesCount(in: folder.id, by: -1)
        UserDefaults.saveNoteData(for: folder.id, with: noteData)
        guard needsDataSourceUpdate else { return }
        // Need to reload the whole section to maintain waterfall layout
        presenter?.reloadNotes(in: IndexSet(integer: 0))
    }
    
}
