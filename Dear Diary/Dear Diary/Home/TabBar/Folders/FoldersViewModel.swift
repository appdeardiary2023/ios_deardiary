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

protocol FoldersViewModelListener: AnyObject {
    func folderSelected(with title: String)
}

protocol FoldersViewModelPresenter: AnyObject {
    func reload()
}

protocol FoldersViewModelable: ViewLifecyclable {
    var profileButtonImage: UIImage? { get }
    var titleLabelText: String { get }
    var searchBarImage: UIImage? { get }
    var searchBarPlaceholder: String { get }
    var folders: [FolderModel] { get }
    var presenter: FoldersViewModelPresenter? { get set }
    func profileButtonTapped()
    func getCellViewModel(at indexPath: IndexPath) -> FolderCellViewModelable?
    func didSelectFolder(at indexPath: IndexPath)
}

final class FoldersViewModel: FoldersViewModelable,
                              JSONable {
    
    private(set) var folders: [FolderModel]
    
    weak var presenter: FoldersViewModelPresenter?
    
    private weak var listener: FoldersViewModelListener?
    
    init(listener: FoldersViewModelListener?) {
        self.folders = []
        self.listener = listener
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
    
    func didSelectFolder(at indexPath: IndexPath) {
        guard let folder = folders[safe: indexPath.row] else { return }
        listener?.folderSelected(with: folder.title)
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
