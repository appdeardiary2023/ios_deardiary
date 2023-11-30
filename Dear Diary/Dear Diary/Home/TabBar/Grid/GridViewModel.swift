//
//  GridViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

protocol GridViewModelPresenter: AnyObject {
    func reload()
}

protocol GridViewModelable: ViewLifecyclable {
    var notes: [Note] { get }
    var presenter: GridViewModelPresenter? { get set }
    func getAttachmentUrl(at indexPath: IndexPath) -> URL?
    func didSelectNote(at indexPath: IndexPath)
}

final class GridViewModel: GridViewModelable {
    
    private(set) var notes: [Note]
    
    weak var presenter: GridViewModelPresenter?
    
    private weak var listener: NoteViewModelListenable?
    
    init(listener: NoteViewModelListenable?) {
        self.notes = []
        self.listener = listener
    }
        
}

// MARK: - Exposed Helpers
extension GridViewModel {
    
    func screenDidLoad() {
        fetchNotes()
    }
    
    func screenWillAppear() {
        fetchNotes()
    }
    
    func getAttachmentUrl(at indexPath: IndexPath) -> URL? {
        guard let attachment = notes[safe: indexPath.item]?.attachment else { return nil }
        return URL(string: attachment)
    }
    
    func didSelectNote(at indexPath: IndexPath) {
        guard let note = notes[safe: indexPath.item] else { return }
        listener?.noteSelected(note, listener: self)
    }
    
}

// MARK: - Private Helpers
private extension GridViewModel {
    
    func fetchNotes() {
        let folderIds = UserDefaults.folders.map { $0.id }
        let folderNotes = folderIds.map { UserDefaults.fetchNotes(for: $0) }
        let allNotes = Array(folderNotes.joined())
        // Filter only attachment notes
        notes = allNotes.filter { $0.attachment != nil }
        presenter?.reload()
    }
    
}

// MARK: - NoteViewModelListener Methods
extension GridViewModel: NoteViewModelListener {
    
    func noteAdded(_ note: Note, needsDataSourceUpdate: Bool) {}
    
    func noteEdited(replacing note: Note, with editedNote: Note?, needsDataSourceUpdate: Bool) {
        // TODO
    }
    
    func deleteNote(_ note: Note, needsDataSourceUpdate: Bool) {
        // TODO
    }
    
}
