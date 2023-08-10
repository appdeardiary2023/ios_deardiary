//
//  NoteDetailsCellViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 09/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

protocol NoteDetailsCellViewModelable {
    var dependency: NoteDetailsCellViewModel.Dependency { get }
}

final class NoteDetailsCellViewModel: NoteDetailsCellViewModelable {
    
    struct Dependency {
        let textStyle: NotesTextView.TextStyle
        var text: String?
        var attributedText: NSAttributedString?
        let adjustsContentWithKeyboard: Bool
        let isFirstResponder: Bool
        weak var parentViewController: NoteViewController?
    }
    
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
}
