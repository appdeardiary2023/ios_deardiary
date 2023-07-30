//
//  Note.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

struct Note: Codable {
    let models: [NoteModel]
    let meta: NoteMeta
    
    private enum CodingKeys: String, CodingKey {
        case models = "data"
        case meta
    }
    
}

struct NoteModel: Codable {
    let id: String
    let text: String?
    let attachment: String?
    let creationTime: TimeInterval
    let isMockRequest: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case attachment
        case creationTime = "creation_time"
        case isMockRequest = "is_mock_request"
    }
    
}

struct NoteMeta: Codable {
    let count: Int
    let pageCount: Int
    let lastOffset: Int
    
    private enum CodingKeys: String, CodingKey {
        case count
        case pageCount = "page_count"
        case lastOffset = "last_offset"
    }
    
}
