//
//  User.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 13/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let profilePic: String?
    let emailId: String
    let password: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePic = "profile_pic"
        case emailId = "email_id"
        case password
    }
    
}

// MARK: - Exposed Helpers
extension User {
    
    static var emptyObject: User {
        return User(id: String(), name: String(), profilePic: nil, emailId: String(), password: String())
    }
    
    // TODO: Remove this, user should be created with a unique id on backend
    static func createObject(name: String, emailId: String, password: String) -> User {
        return User(id: UUID().uuidString, name: name, profilePic: nil, emailId: emailId, password: password)
    }
    
}
