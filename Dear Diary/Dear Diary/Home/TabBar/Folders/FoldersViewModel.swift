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
    func folderSelected(_ folder: FolderModel)
}

protocol FoldersViewModelPresenter: AnyObject {
    func insertFolder(at indexPath: IndexPath)
    func deleteFolder(at indexPath: IndexPath)
    func reloadFolder(at indexPath: IndexPath)
    func scroll(to indexPath: IndexPath)
    func reload()
}

protocol FoldersViewModelable: ViewLifecyclable {
    var profileButtonImage: UIImage? { get }
    var titleLabelText: String { get }
    var searchBarImage: UIImage? { get }
    var searchBarPlaceholder: String { get }
    var folders: [FolderModel] { get }
    var foldersCount: Int { get }
    var presenter: FoldersViewModelPresenter? { get set }
    func profileButtonTapped()
    func getCellViewModel(at indexPath: IndexPath) -> FolderCellViewModelable?
    func didSelectFolder(at indexPath: IndexPath)
}

final class FoldersViewModel: FoldersViewModelable,
                              Alertable {
    
    weak var presenter: FoldersViewModelPresenter?
    
    private var folderData: Folder?
    private var reloadableIndexPath: IndexPath?
    private weak var listener: FoldersViewModelListener?
    
    init(listener: FoldersViewModelListener?) {
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
    
    var folders: [FolderModel] {
        return folderData?.models ?? []
    }
    
    var foldersCount: Int {
        return folderData?.meta.count ?? 0
    }
    
    func screenDidLoad() {
        folderData = UserDefaults.folderData
        presenter?.reload()
    }
    
    func screenDidAppear() {
        // Reloading here to avoid layout error
        guard let indexPath = reloadableIndexPath else { return }
        presenter?.reloadFolder(at: indexPath)
        reloadableIndexPath = nil
    }

    func profileButtonTapped() {
        // TODO
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> FolderCellViewModelable? {
        guard let folder = folders[safe: indexPath.row] else { return nil }
        return FolderCellViewModel(folder: folder, listener: self)
    }
    
    func didSelectFolder(at indexPath: IndexPath) {
        guard let folder = folders[safe: indexPath.row] else { return }
        listener?.folderSelected(folder)
    }
    
    func addNewFolder() {
        let indexPath = IndexPath(row: folders.count, section: 0)
        folderData = UserDefaults.folderData
        presenter?.insertFolder(at: indexPath)
        // Scroll to newly added folder
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.scroll(to: indexPath)
        }
    }
    
    func changeNotesCount(in folderId: String, by count: Int) {
        guard let index = folders.firstIndex(where: { $0.id == folderId }) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        reloadableIndexPath = indexPath
        folderData?.models[index].notesCount += count
        UserDefaults.saveFolderData(with: folderData)
    }
   
}

// MARK: - Private Helpers
private extension FoldersViewModel {
    
    func deleteFolder(_ folder: FolderModel) {
        guard let index = folders.firstIndex(of: folder) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        folderData?.models.remove(at: index)
        folderData?.meta.count -= 1
        UserDefaults.saveFolderData(with: folderData)
        presenter?.deleteFolder(at: indexPath)
    }
    
}

// MARK: - FolderCellViewModelListener Methods
extension FoldersViewModel: FolderCellViewModelListener {
    
    func longPressRecognized(for folder: FolderModel) {
        let title = "\(Strings.Alert.delete) \"\(folder.title)\"?"
        showAlert(
            with: title,
            message: Strings.Alert.deleteFolderMessage,
            onDelete: { [weak self] in
            self?.deleteFolder(folder)
        })
    }
    
}
