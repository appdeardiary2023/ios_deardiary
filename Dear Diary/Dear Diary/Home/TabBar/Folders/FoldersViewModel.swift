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
    func folderSelected(_ folder: Folder, listener: NotesViewModelListener?)
}

protocol FoldersViewModelPresenter: AnyObject {
    func insertFolder(at indexPath: IndexPath)
    func deleteFolder(at indexPath: IndexPath)
    func reloadFolder(at indexPath: IndexPath)
    func scroll(to indexPath: IndexPath)
    func reload()
}

protocol FoldersViewModelable: ViewLifecyclable {
    var titleLabelText: String { get }
    var searchBarImage: UIImage? { get }
    var searchBarPlaceholder: String { get }
    var folders: [Folder] { get }
    var presenter: FoldersViewModelPresenter? { get set }
    func searchTextChanged(_ searchText: String)
    func getCellViewModel(at indexPath: IndexPath) -> FolderCellViewModelable?
    func didSelectFolder(at indexPath: IndexPath)
}

final class FoldersViewModel: FoldersViewModelable,
                              Alertable {
    
    weak var presenter: FoldersViewModelPresenter?
    
    private(set) var folders: [Folder]
    
    private var searchTimer: Timer?
    private var reloadableIndexPath: IndexPath?
    private weak var listener: FoldersViewModelListener?
    
    init(listener: FoldersViewModelListener?) {
        self.folders = UserDefaults.folders
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension FoldersViewModel {
    
    var searchBarImage: UIImage? {
        return Image.search.asset
    }
    
    var titleLabelText: String {
        return Strings.Folders.title
    }
    
    var searchBarPlaceholder: String {
        return Strings.Folders.search
    }
    
    func screenDidAppear() {
        // Reloading here to avoid layout error
        guard let indexPath = reloadableIndexPath else { return }
        presenter?.reloadFolder(at: indexPath)
        reloadableIndexPath = nil
    }
    
    func searchTextChanged(_ searchText: String) {
        destroySearchTimer()
        scheduleSearchTimer(for: searchText)
    }

    func getCellViewModel(at indexPath: IndexPath) -> FolderCellViewModelable? {
        guard let folder = folders[safe: indexPath.row] else { return nil }
        return FolderCellViewModel(folder: folder, listener: self)
    }
    
    func didSelectFolder(at indexPath: IndexPath) {
        guard let folder = folders[safe: indexPath.row] else { return }
        listener?.folderSelected(folder, listener: self)
    }
    
    func addNewFolder() {
        let indexPath = IndexPath(row: folders.count, section: 0)
        folders = UserDefaults.folders
        presenter?.insertFolder(at: indexPath)
        // Scroll to newly added folder
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.scroll(to: indexPath)
        }
    }
   
}

// MARK: - Private Helpers
private extension FoldersViewModel {
    
    func scheduleSearchTimer(for query: String) {
        let timer = Timer(
            timeInterval: Constants.TabBar.Folders.searchThrottleInterval,
            repeats: false
        ) { [weak self] timer in
            guard timer.isValid else { return }
            self?.loadSearchResults(for: query)
        }
        RunLoop.main.add(timer, forMode: .common)
        searchTimer = timer
    }
    
    func destroySearchTimer() {
        searchTimer?.invalidate()
        searchTimer = nil
    }
    
    func loadSearchResults(for query: String) {
        if query.isEmpty {
            folders = UserDefaults.folders
        } else {
            folders = folders.filter { $0.title.range(of: query, options: .caseInsensitive) != nil }
        }
        presenter?.reload()
    }
    
    func deleteFolder(_ folder: Folder) {
        guard let index = folders.firstIndex(where: { $0.id == folder.id }) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        folders.remove(at: index)
        UserDefaults.saveFolders(with: folders)
        presenter?.deleteFolder(at: indexPath)
    }
    
}

// MARK: - FolderCellViewModelListener Methods
extension FoldersViewModel: FolderCellViewModelListener {
    
    func longPressRecognized(for folder: Folder) {
        let title = "\(Strings.Alert.delete) \"\(folder.title)\"?"
        showAlert(
            with: title,
            message: Strings.Alert.deleteFolderMessage,
            actionTitle: Strings.Alert.delete,
            onAction: { [weak self] in
            self?.deleteFolder(folder)
        })
    }
    
}

// MARK: - NotesViewModelListener Helpers
extension FoldersViewModel: NotesViewModelListener {
    
    func updateNotesCount(in folderId: String, with count: Int) {
        guard let index = folders.firstIndex(where: { $0.id == folderId }) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        reloadableIndexPath = indexPath
        folders[index].notesCount = count
        UserDefaults.saveFolders(with: folders)
    }
    
}
