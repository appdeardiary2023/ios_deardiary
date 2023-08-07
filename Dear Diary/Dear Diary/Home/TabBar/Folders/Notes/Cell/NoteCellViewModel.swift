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
    
    enum Flow {
        case folder(isInverted: Bool)
        case calendar
    }
        
    private let flow: Flow
    private let note: NoteModel
    private weak var listener: NoteCellViewModelListener?
    
    init(flow: Flow, note: NoteModel, listener: NoteCellViewModelListener?) {
        self.flow = flow
        self.note = note
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
    
    var isInverted: Bool {
        switch flow {
        case let .folder(isInverted):
            return isInverted
        case .calendar:
            return false
        }
    }
    
    func longPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
        switch flow {
        case .folder:
            guard recognizer.state == .began else { return }
            listener?.longPressRecognized(for: note)
        case .calendar:
            // Note applicable
            return
        }
    }
    
}
