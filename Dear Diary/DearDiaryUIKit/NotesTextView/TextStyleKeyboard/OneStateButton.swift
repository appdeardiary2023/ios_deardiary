//
//  OneStateButton.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

// This button has only one state.
// It triggers the specified button everytime it is tapped.
// but when user keeps it pressed, it shows highlighted background.
// This button can be used for Changing the Text Indents.

class OneStateButton: UIButton{
    
    let activeBackgroundColor = Color.primary.shade
    let inactiveBackgroundColor = Color.background.shade
    let activeTextColor = Color.white.shade
    let inactiveTextColor = Color.tertiaryLabel.shade
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? activeBackgroundColor : inactiveBackgroundColor
            tintColor = isHighlighted ? activeTextColor : inactiveTextColor
        }
    }
    
}
