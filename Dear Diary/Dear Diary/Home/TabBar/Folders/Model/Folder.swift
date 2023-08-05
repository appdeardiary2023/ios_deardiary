//
//  Folder.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

struct Folder: Codable {
    var models: [FolderModel]
    var meta: FolderMeta
    
    private enum CodingKeys: String, CodingKey {
        case models = "data"
        case meta
    }
    
}

struct FolderModel: Codable, Equatable {
    let id: String
    let title: String
    var notesCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case notesCount = "notes_count"
    }
    
}

struct FolderMeta: Codable {
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
extension Folder {
    
    static var emptyObject: Folder {
        let meta = FolderMeta(count: 0, pageCount: 0, lastOffset: 0)
        return Folder(models: [], meta: meta)
    }
    
}
