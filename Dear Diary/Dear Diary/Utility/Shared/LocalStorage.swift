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
    
    static var folders: [Folder] {
        guard let data = appSuite.data(forKey: folderKey),
              let foldersDict = try? JSONDecoder().decode([String: [Folder]].self, from: data),
              let folders = foldersDict[AuthStore.shared.user.id] else { return [] }
        return folders
    }
    
    static func saveUsers(with users: [User]) {
        guard let users = try? JSONEncoder().encode(users) else { return }
        appSuite.set(users, forKey: usersKey)
    }
        
    static func saveFolders(with folders: [Folder]) {
        let dict = [AuthStore.shared.user.id: folders]
        guard let data = try? JSONEncoder().encode(dict) else { return }
        appSuite.set(data, forKey: folderKey)
    }
    
    static func fetchNotes(for folderId: String) -> [Note] {
        // Using folder id as a key to retrieve notes
        guard let data = appSuite.data(forKey: folderId),
              let notes = try? JSONDecoder().decode([Note].self, from: data) else { return [] }
        return notes
    }
    
    static func saveNotes(for folderId: String, with notes: [Note]) {
        // Using folder id as a key to save notes
        guard let data = try? JSONEncoder().encode(notes) else { return }
        appSuite.set(data, forKey: folderId)
    }
    
    static func clear() {
        appSuite.removeObject(forKey: userInterfaceStyleKey)
        // Remove notes
        let folderIds = folders.map { $0.id }
        folderIds.forEach { id in
            appSuite.removeObject(forKey: id)
        }
        // Remove folders
        appSuite.removeObject(forKey: folderKey)
    }
    
}
