//
//  LocalStorage.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 16/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    static let appSuite = UserDefaults(suiteName: "Dear Diary") ?? UserDefaults()
    
    static let userInterfaceStyleKey = "userInterfaceStyleKey"
    static let usersKey = "usersKey"
    static let folderKey = "folderKey"
    
}

// MARK: - Exposed Helpers
extension UserDefaults {
    
    static var userInterfaceStyle: UIUserInterfaceStyle {
        let value = UserDefaults.appSuite.integer(forKey: userInterfaceStyleKey)
        return UIUserInterfaceStyle(rawValue: value) ?? .unspecified
    }
    
    static var users: [User] {
        guard let data = appSuite.data(forKey: usersKey),
              let users = try? JSONDecoder().decode([User].self, from: data) else { return [] }
        return users
    }
    
    static var folderData: Folder {
        guard let data = appSuite.data(forKey: folderKey),
              let folder = try? JSONDecoder().decode(Folder.self, from: data) else { return Folder.emptyObject }
        return folder
    }
    
    static func saveUsers(with users: [User]) {
        guard let users = try? JSONEncoder().encode(users) else { return }
        appSuite.set(users, forKey: usersKey)
    }
        
    static func saveFolderData(with folder: Folder?) {
        guard let data = try? JSONEncoder().encode(folder) else { return }
        appSuite.set(data, forKey: folderKey)
    }
    
    static func fetchNoteData(for folderId: String) -> Note {
        // Using folder id as a key to retrieve note data
        guard let data = appSuite.data(forKey: folderId),
              let note = try? JSONDecoder().decode(Note.self, from: data) else { return Note.emptyObject }
        return note
    }
    
    static func saveNoteData(for folderId: String, with note: Note?) {
        // Using folder id as a key to save note data
        guard let data = try? JSONEncoder().encode(note) else { return }
        appSuite.set(data, forKey: folderId)
    }
    
}
