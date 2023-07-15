//
//  FolderCellViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryImages

protocol FolderCellViewModelable {
    var folder: FolderModel { get }
    var arrowImage: UIImage? { get }
}

final class FolderCellViewModel: FolderCellViewModelable {
    
    let folder: FolderModel
    
    init(folder: FolderModel) {
        self.folder = folder
    }
    
}

// MARK: - Exposed Helpers
extension FolderCellViewModel {
    
    var arrowImage: UIImage? {
        return Image.forwardArrow.asset
    }
    
}
