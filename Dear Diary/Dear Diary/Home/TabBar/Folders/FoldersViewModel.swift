//
//  FoldersViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages

protocol FoldersViewModelPresenter: AnyObject {
    func reload()
}

protocol FoldersViewModelable {
    var profileButtonImage: UIImage? { get }
    var titleLabelText: String { get }
    var searchBarImage: UIImage? { get }
    var searchBarPlaceholder: String { get }
    var folders: [FolderModel] { get }
    var presenter: FoldersViewModelPresenter? { get set }
    func screenDidLoad()
    func profileButtonTapped()
    func getCellViewModel(at indexPath: IndexPath) -> FolderCellViewModelable?
}

final class FoldersViewModel: FoldersViewModelable,
                              JSONable {
    
    private(set) var folders: [FolderModel]
    
    weak var presenter: FoldersViewModelPresenter?
    
    init() {
        self.folders = []
    }
    
}

// MARK: - Exposed Helpers
extension FoldersViewModel {
    
    var profileButtonImage: UIImage? {
        return Image.profile.asset
    }
    
    var searchBarImage: UIImage? {
        return Image.search.asset
    }
    
    var titleLabelText: String {
        return Strings.Folders.title
    }
    
    var searchBarPlaceholder: String {
        return Strings.Folders.search
    }
    
    func screenDidLoad() {
        fetchFoldersData()
    }

    func profileButtonTapped() {
        // TODO
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> FolderCellViewModelable? {
        guard let folder = folders[safe: indexPath.row] else { return nil }
        return FolderCellViewModel(folder: folder)
    }
   
}

private extension FoldersViewModel {
    
    func fetchFoldersData() {
        fetchData(for: .folders) { [weak self] (folder: Folder) in
            self?.folders = folder.models
            self?.presenter?.reload()
        }
    }
    
}
