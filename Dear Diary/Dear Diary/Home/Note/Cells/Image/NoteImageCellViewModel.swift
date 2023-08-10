//
//  NoteImageCellViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 10/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryImages

protocol NoteImageCellViewModelListener: AnyObject {
    func deleteButtonTapped()
}

protocol NoteImageCellViewModelable {
    var imageUrl: URL? { get }
    var deleteButtonImage: UIImage? { get }
    func deleteButtonTapped()
}

final class NoteImageCellViewModel: NoteImageCellViewModelable {
    
    let imageUrl: URL?
    
    private weak var listener: NoteImageCellViewModelListener?
    
    init(imageUrl: URL?, listener: NoteImageCellViewModelListener?) {
        self.imageUrl = imageUrl
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension NoteImageCellViewModel {
    
    var deleteButtonImage: UIImage? {
        return Image.close.asset
    }
    
    func deleteButtonTapped() {
        listener?.deleteButtonTapped()
    }
    
}
