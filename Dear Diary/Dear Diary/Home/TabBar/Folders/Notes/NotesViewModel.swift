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
    func updateNotesCount(in folderId: String, with count: Int)
}

protocol NotesViewModelPresenter: AnyObject {
    func reloadNote(at indexPath: IndexPath)
    func reload()
    func scroll(to indexPath: IndexPath)
    func push(_ viewController: UIViewController)
    func dismiss()
}

protocol NotesViewModelable: ViewLifecyclable {
    var backButtonImage: UIImage? { get }
    var addButtonImage: UIImage? { get }
    var title: String { get }
    var notes: [Note] { get }
    var presenter: NotesViewModelPresenter? { get set }
    func backButtonTapped()
    func addButtonTapped()
    func isLongNote(at indexPath: IndexPath) -> Bool
    func getCellViewModel(at indexPath: IndexPath) -> NoteCellViewModelable?
    func didSelectNote(at indexPath: IndexPath)
}

final class NotesViewModel: NotesViewModelable,
                            Alertable {
    
    private let folder: Folder
    private weak var listener: NotesViewModelListener?
    
    private(set) var notes: [Note]
    
    weak var presenter: NotesViewModelPresenter?
    
    init(folder: Folder, listener: NotesViewModelListener?) {
        self.folder = folder
        self.notes = UserDefaults.fetchNotes(for: folder.id)
        self.listener = listener
        organizeNotes()
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
    
    func backButtonTapped() {
        presenter?.dismiss()
    }
    
    func addButtonTapped() {
        // Show add note screen
        showNoteScreen(with: .add(
            id: UUID().uuidString,
            date: Date(),
            number: notes.count + 1
        ))
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
    
    func organizeNotes() {
        // Sort by latest creation time
        notes = notes.sorted(by: { $0.creationTime > $1.creationTime })
    }
    
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
    
    func longPressRecognized(for note: Note) {
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
    
    func noteAdded(_ note: Note, needsDataSourceUpdate: Bool) {
        let indexPath = IndexPath(item: notes.count, section: 0)
        notes.append(note)
        UserDefaults.saveNotes(for: folder.id, with: notes)
        listener?.updateNotesCount(in: folder.id, with: notes.count)
        guard needsDataSourceUpdate else { return }
        organizeNotes()
        presenter?.reload()
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.scroll(to: indexPath)
        }
    }
    
    func noteEdited(replacing note: Note, with editedNote: Note?, needsDataSourceUpdate: Bool) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }),
              let editedNote = editedNote else { return }
        let indexPath = IndexPath(item: index, section: 0)
        notes[index] = editedNote
        UserDefaults.saveNotes(for: folder.id, with: notes)
        guard needsDataSourceUpdate else { return }
        presenter?.reloadNote(at: indexPath)
    }
    
    func deleteNote(_ note: Note, needsDataSourceUpdate: Bool) {
        notes.removeAll(where: { $0.id == note.id })
        listener?.updateNotesCount(in: folder.id, with: notes.count)
        UserDefaults.saveNotes(for: folder.id, with: notes)
        guard needsDataSourceUpdate else { return }
        // Need to reload the whole section to maintain waterfall layout
        presenter?.reload()
    }
    
}
