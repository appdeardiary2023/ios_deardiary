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
    func reload()
    func push(_ viewController: UIViewController)
    func dismiss()
}

protocol NotesViewModelable {
    var title: String { get }
    var backButtonImage: UIImage? { get }
    var addButtonImage: UIImage? { get }
    var notes: [NoteModel] { get }
    var presenter: NotesViewModelPresenter? { get set }
    func screenDidLoad()
    func backButtonTapped()
    func addButtonTapped()
    func isMosaicCell(at indexPath: IndexPath) -> Bool
    func getCellViewModel(at indexPath: IndexPath) -> NoteCellViewModelable?
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
        let viewModel = NoteViewModel(title: title)
        let viewController = NoteViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        viewModel.presenter = viewController
        presenter?.push(viewController)
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
    
}

// MARK: - Private Helpers
private extension NotesViewModel {
    
    func fetchNotesData() {
        fetchData(for: .notes) { [weak self] (note: Note) in
            self?.notes = note.models
            self?.presenter?.reload()
        }
    }
    
}
