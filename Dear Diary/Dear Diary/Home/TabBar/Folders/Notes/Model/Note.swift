//
//  Note.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

struct Note: Codable {
    var models: [NoteModel]
    var meta: NoteMeta
    
    private enum CodingKeys: String, CodingKey {
        case models = "data"
        case meta
    }
    
}

struct NoteModel: Codable, Equatable {
    let id: String
    var title: Data?
    var content: Data?
    var attachment: String?
    let creationTime: TimeInterval
    
    var attachmentUrl: URL? {
        guard let attachment = attachment else { return nil }
        return URL(string: attachment)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case attachment
        case creationTime = "creation_time"
    }
    
}

struct NoteMeta: Codable {
    var count: Int
    let pageCount: Int
    let lastOffset: Int
    
    private enum CodingKeys: String, CodingKey {
        case count
        case pageCount = "page_count"
        case lastOffset = "last_offset"
    }
    
}

// MARK: - Exposed Helpers
extension Note {
    
    static var emptyObject: Note {
        let meta = NoteMeta(count: 0, pageCount: 0, lastOffset: 0)
        return Note(models: [], meta: meta)
    }
    
}
