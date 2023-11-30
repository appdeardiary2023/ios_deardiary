//
//  Folder.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

struct Folder: Codable {
    let id: String
    let title: String
    var notesCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case notesCount = "notes_count"
    }
    
}
