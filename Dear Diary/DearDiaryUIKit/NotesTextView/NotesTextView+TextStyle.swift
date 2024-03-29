//
//  NotesTextView+TextStyle.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import Foundation

extension NotesTextView{
    @objc func useTitle(){
        
        saveCurrentStateAndRegisterForUndo()
        
        let coreString = textStorage.string as NSString
        
        let paraGraphRange = coreString.paragraphRange(for: selectedRange)
        
        if paraGraphRange.length != 0{
            textStorage.enumerateAttribute(.font, in: paraGraphRange, options: .longestEffectiveRangeNotRequired) { (fontValue, range, stop) in
                textStorage.beginEditing()
                textStorage.addAttribute(.font, value: NotesFontProvider.shared.titleFont, range: range)
                textStorage.endEditing()
            }
        }
        
        typingAttributes[NSAttributedString.Key.font] = NotesFontProvider.shared.titleFont
        updateVisualForKeyboard()
        
    }
    
    @objc func useHeading(){
        
        saveCurrentStateAndRegisterForUndo()
        
        let coreString = textStorage.string as NSString
        
        let paraGraphRange = coreString.paragraphRange(for: selectedRange)
        
        if paraGraphRange.length != 0{
            textStorage.enumerateAttribute(.font, in: paraGraphRange, options: .longestEffectiveRangeNotRequired) { (fontValue, range, stop) in
                textStorage.beginEditing()
                textStorage.addAttribute(.font, value: NotesFontProvider.shared.headingFont, range: range)
                textStorage.endEditing()
            }
        }
        
        typingAttributes[NSAttributedString.Key.font] = NotesFontProvider.shared.headingFont
        updateVisualForKeyboard()
    }
    
    @objc func useBody(){
        
        saveCurrentStateAndRegisterForUndo()
        
        let coreString = textStorage.string as NSString
        
        let paraGraphRange = coreString.paragraphRange(for: selectedRange)
        
        if paraGraphRange.length != 0{
            textStorage.enumerateAttribute(.font, in: paraGraphRange, options: .longestEffectiveRangeNotRequired) { (fontValue, range, stop) in
                textStorage.beginEditing()
                textStorage.addAttribute(.font, value: NotesFontProvider.shared.bodyFont, range: range)
                textStorage.endEditing()
            }
        }
        
        typingAttributes[NSAttributedString.Key.font] = NotesFontProvider.shared.bodyFont
        updateVisualForKeyboard()
        
    }
    
    @objc func useMonospaced(){
        
        saveCurrentStateAndRegisterForUndo()
        
        let coreString = textStorage.string as NSString
        
        let paraGraphRange = coreString.paragraphRange(for: selectedRange)
        
        if paraGraphRange.length != 0{
            textStorage.enumerateAttribute(.font, in: paraGraphRange, options: .longestEffectiveRangeNotRequired) { (fontValue, range, stop) in
                textStorage.beginEditing()
                textStorage.addAttribute(.font, value: NotesFontProvider.shared.monospacedFont, range: range)
                textStorage.endEditing()
            }
        }
        
        
        typingAttributes[NSAttributedString.Key.font] = NotesFontProvider.shared.monospacedFont
        updateVisualForKeyboard()
    }
}
