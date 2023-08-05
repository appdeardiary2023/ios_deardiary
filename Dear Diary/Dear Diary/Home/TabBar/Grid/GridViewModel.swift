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
    var notes: [NoteModel] { get }
    var presenter: GridViewModelPresenter? { get set }
    func getAttachmentUrl(at indexPath: IndexPath) -> URL?
}

final class GridViewModel: GridViewModelable,
                           JSONable {
    
    private(set) var notes: [NoteModel]
    
    weak var presenter: GridViewModelPresenter?
    
    init() {
        self.notes = []
    }
        
}

// MARK: - Exposed Helpers
extension GridViewModel {
    
    func screenDidLoad() {
        // TODO
    }
    
    func getAttachmentUrl(at indexPath: IndexPath) -> URL? {
        guard let attachment = notes[safe: indexPath.item]?.attachment else { return nil }
        return URL(string: attachment)
    }
    
}
