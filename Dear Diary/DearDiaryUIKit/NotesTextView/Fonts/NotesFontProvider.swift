//
//  NotesFontProvider.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

class NotesFontProvider {
    
    static let shared = NotesFontProvider()
    
    lazy var titleFont = Font.title1(.bold)
    lazy var headingFont = Font.title2(.bold)
    lazy var bodyFont = Font.headline(.regular)
    lazy var monospacedFont = Font.headline(.regularMonospaced)
    
    private init(){
        NotificationCenter.default.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    @objc private func fontSizeChanged(){
        titleFont = Font.title1(.bold)
        headingFont = Font.title2(.bold)
        bodyFont = Font.headline(.regular)
        monospacedFont = Font.headline(.regularMonospaced)
    }
    
}
