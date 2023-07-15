//
//  Folder.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

struct Folder: Codable {
    let models: [FolderModel]
    let meta: FolderMeta
    
    private enum CodingKeys: String, CodingKey {
        case models = "data"
        case meta
    }
    
}

struct FolderModel: Codable {
    let id: String
    let title: String
    let notesCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case notesCount = "notes_count"
    }
    
}

struct FolderMeta: Codable {
    let count: Int
    let pageCount: Int
    let lastOffset: Int
    
    private enum CodingKeys: String, CodingKey {
        case count
        case pageCount = "page_count"
        case lastOffset = "last_offset"
    }
    
}
