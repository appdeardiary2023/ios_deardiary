//
//  FolderCellViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryImages

protocol FolderCellViewModelListener: AnyObject {
    func longPressRecognized(for folder: Folder)
}

protocol FolderCellViewModelable {
    var folder: Folder { get }
    var arrowImage: UIImage? { get }
    func longPressRecognized(_ recognizer: UILongPressGestureRecognizer)
}

final class FolderCellViewModel: FolderCellViewModelable {
    
    let folder: Folder
    
    private weak var listener: FolderCellViewModelListener?
    
    init(folder: Folder, listener: FolderCellViewModelListener?) {
        self.folder = folder
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension FolderCellViewModel {
    
    var arrowImage: UIImage? {
        return Image.forwardArrow.asset
    }
    
    func longPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        listener?.longPressRecognized(for: folder)
    }
    
}
