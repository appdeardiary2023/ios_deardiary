//
//  NoteDetails.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 27/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

enum NoteFont: String, Codable {
    case title
    case body
    case monospaced
}

enum NoteAlignment: String, Codable {
    case left
    case center
    case right
}

struct NoteDetails: Codable {
    let id: String
    let title: String
    let paragraphs: [NoteParagraph]
    let attachment: String?
    let creationTime: TimeInterval
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case paragraphs
        case attachment
        case creationTime = "creation_time"
    }
    
}

struct NoteParagraph: Codable {
    var text: String
    var formatting: Formatting
    
    struct Formatting: Codable {
        var font: NoteFont
        var alignment: NoteAlignment
        var boldWords: [WordRange]
        var italicWords: [WordRange]
        var underlineWords: [WordRange]
        var strikethroughWords: [WordRange]
        
        private enum CodingKeys: String, CodingKey {
            case font
            case alignment
            case boldWords = "bold_words"
            case italicWords = "italic_words"
            case underlineWords = "underline_words"
            case strikethroughWords = "strikethrough_words"
        }
        
    }
    
    struct WordRange: Codable {
        var start: Int
        var end: Int
        
        private enum CodingKeys: String, CodingKey {
            case start = "range_start"
            case end = "range_end"
        }
        
    }
    
}

// MARK: - NoteParagraph Helpers
extension NoteParagraph {
    
    static var emptyObject: NoteParagraph {
        let formatting = NoteParagraph.Formatting(
            font: .body,
            alignment: .left,
            boldWords: [],
            italicWords: [],
            underlineWords: [],
            strikethroughWords: []
        )
        return NoteParagraph(text: String(), formatting: formatting)
    }
    
}
