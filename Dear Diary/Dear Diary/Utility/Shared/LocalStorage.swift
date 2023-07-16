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
    static var userInterfaceStyle: UIUserInterfaceStyle {
        let value = UserDefaults.appSuite.integer(forKey: userInterfaceStyleKey)
        return UIUserInterfaceStyle(rawValue: value) ?? .unspecified
    }
    
}
