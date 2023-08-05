//
//  NoteCellViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

protocol NoteCellViewModelListener: AnyObject {
    func longPressRecognized(for note: NoteModel)
}

protocol NoteCellViewModelable {
    var text: String? { get }
    var isInverted: Bool { get }
    func longPressRecognized(_ recognizer: UILongPressGestureRecognizer)
}

final class NoteCellViewModel: NoteCellViewModelable {
    
    let isInverted: Bool
    
    private let note: NoteModel
    private weak var listener: NoteCellViewModelListener?
    
    init(note: NoteModel, isInverted: Bool, listener: NoteCellViewModelListener?) {
        self.note = note
        self.isInverted = isInverted
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension NoteCellViewModel {
    
    var text: String? {
        guard let content = note.content?.toAttributedString?.string,
              !content.isEmpty else {
            return note.title?.toAttributedString?.string
        }
        return content
    }
    
    func longPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        listener?.longPressRecognized(for: note)
    }
    
}
