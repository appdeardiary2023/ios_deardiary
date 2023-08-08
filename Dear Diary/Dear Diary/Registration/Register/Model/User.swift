//
//  User.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 13/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    let id: String
    let name: String
    var profilePic: String?
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
        return User(
            id: String(),
            name: String(),
            profilePic: nil,
            emailId: String(),
            password: String()
        )
    }
    
}
