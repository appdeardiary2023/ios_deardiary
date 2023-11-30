//
//  Note.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

struct Note: Codable {
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
