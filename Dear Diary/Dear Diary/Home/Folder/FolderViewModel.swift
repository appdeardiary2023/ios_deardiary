//
//  FolderViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 04/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages

protocol FolderViewModelListener: AnyObject {
    func newFolderCreated()
}

protocol FolderViewModelPresenter: AnyObject {
    var folderTitle: String? { get }
    func updateDoneButton(isEnabled: Bool)
    func dismiss(completion: (() -> Void)?)
}

protocol FolderViewModelable {
    var backButtonImage: UIImage? { get }
    var doneButtonTitle: String { get }
    var titleFieldPlaceholder: String { get }
    var presenter: FolderViewModelPresenter? { get set }
    func didChangeTitle(with currentText: String?, newText: String, in range: NSRange) -> Bool
    func backButtonTapped()
    func doneButtonTapped()
}

final class FolderViewModel: FolderViewModelable {
    
    weak var presenter: FolderViewModelPresenter?
    
    private weak var listener: FolderViewModelListener?
    
    init(listener: FolderViewModelListener?) {
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension FolderViewModel {
    
    var backButtonImage: UIImage? {
        return Image.back.asset
    }
    
    var doneButtonTitle: String {
        return Strings.Folder.done
    }
    
    var titleFieldPlaceholder: String {
        return Strings.Folder.folder
    }
    
    func didChangeTitle(with currentText: String?, newText: String, in range: NSRange) -> Bool {
        let currentText = currentText ?? String()
        let text = (currentText as NSString)
            .replacingCharacters(in: range, with: newText)
            .trimmingCharacters(in: .whitespaces)
        presenter?.updateDoneButton(isEnabled: !text.isEmpty)
        return true
    }
    
    func backButtonTapped() {
        presenter?.dismiss(completion: nil)
    }
    
    func doneButtonTapped() {
        guard let title = presenter?.folderTitle else { return }
        // Fetch existing folders
        var folders = UserDefaults.folders
        // Create new folder
        let newFolder = Folder(
            id: UUID().uuidString,
            title: title,
            notesCount: 0
        )
        folders.append(newFolder)
        // Save folder data
        UserDefaults.saveFolders(with: folders)
        presenter?.dismiss { [weak self] in
            self?.listener?.newFolderCreated()
        }
    }
    
}
