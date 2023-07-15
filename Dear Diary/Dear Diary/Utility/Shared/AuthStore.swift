//
//  AuthStore.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 13/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

/// A class responsible for storing current user session properties
final class AuthStore {
    
    static let shared = AuthStore()
    
    var user: User
    
    private init() {
        self.user = User.emptyObject
    }
    
}
