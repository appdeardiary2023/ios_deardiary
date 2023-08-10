//
//  NotesTextView+Extras.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 03/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

extension NotesTextView {
    
    @objc func scribble() {
        // TODO
    }
    
    @objc func addImage() {
        extrasDelegate?.showImagePickerScreen()
    }
    
    @objc func lockNote() {
        // TODO
    }
    
    @objc func copyNote() {
        // Copy the text view text without any attributes
        UIPasteboard.general.string = text
    }
    
    @objc func shareNote() {
        extrasDelegate?.showShareActivity(with: text)
    }
    
}
