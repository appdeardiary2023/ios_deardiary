//
//  NotesViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryImages

protocol NotesViewModelPresenter: AnyObject {
    func insertNote(at indexPath: IndexPath)
    func reloadNote(at indexPath: IndexPath)
    func reload()
    func push(_ viewController: UIViewController)
    func dismiss()
}

protocol NotesViewModelable: ViewLifecyclable {
    var title: String { get }
    var backButtonImage: UIImage? { get }
    var addButtonImage: UIImage? { get }
    var notes: [NoteModel] { get }
    var presenter: NotesViewModelPresenter? { get set }
    func backButtonTapped()
    func addButtonTapped()
    func isMosaicCell(at indexPath: IndexPath) -> Bool
    func getCellViewModel(at indexPath: IndexPath) -> NoteCellViewModelable?
    func didSelectNote(at indexPath: IndexPath)
}

final class NotesViewModel: NotesViewModelable,
                            JSONable {
    
    let title: String
    
    private(set) var notes: [NoteModel]
    
    weak var presenter: NotesViewModelPresenter?
    
    init(title: String) {
        self.title = title
        self.notes = []
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
    
    func backButtonTapped() {
        presenter?.dismiss()
    }
    
    func addButtonTapped() {
        // Show add note screen
        showNoteScreen(with: .add)
    }
    
    func screenDidLoad() {
        fetchNotesData()
    }
    
    func isMosaicCell(at indexPath: IndexPath) -> Bool {
        return (indexPath.item % Constants.TabBar.Notes.mosaicCellPosition) == .zero
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> NoteCellViewModelable? {
        guard let note = notes[safe: indexPath.item] else { return nil }
        return NoteCellViewModel(text: note.text ?? String(), isInverted: !isMosaicCell(at: indexPath))
    }
    
    func didSelectNote(at indexPath: IndexPath) {
        guard let note = notes[safe: indexPath.item] else { return }
        showNoteScreen(with: .edit(note: note))
    }
    
}

// MARK: - Private Helpers
private extension NotesViewModel {
    
    func fetchNotesData() {
        fetchData(for: .notes) { [weak self] (note: Note) in
            self?.notes = note.models
            self?.presenter?.reload()
        }
    }
    
    func showNoteScreen(with flow: NoteViewModel.Flow) {
        let viewModel = NoteViewModel(flow: flow, title: title, listener: self)
        let viewController = NoteViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        viewModel.presenter = viewController
        presenter?.push(viewController)
    }
    
}

// MARK: - NoteViewModelListener Methods
extension NotesViewModel: NoteViewModelListener {
    
    func noteAdded(with text: String) {
        // TODO: - Change
        let indexPath = IndexPath(item: notes.count, section: 0)
        let newNote = NoteModel(
            id: UUID().uuidString,
            text: text,
            attachment: nil,
            creationTime: Date().timeIntervalSince1970,
            isMockRequest: false
        )
        notes.append(newNote)
        presenter?.insertNote(at: indexPath)
    }
    
    func noteEdited(with id: String, text: String) {
        guard let index = notes.firstIndex(where: { $0.id == id }),
              let note = notes[safe: index] else { return }
        let editedNote = NoteModel(
            id: note.id,
            text: text,
            attachment: note.attachment,
            creationTime: note.creationTime,
            isMockRequest: note.isMockRequest
        )
        notes[index] = editedNote
        let indexPath = IndexPath(item: index, section: 0)
        presenter?.reloadNote(at: indexPath)
    }
    
}
