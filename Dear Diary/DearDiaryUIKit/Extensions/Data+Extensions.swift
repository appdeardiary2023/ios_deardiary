//
//  Data+Extensions.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 05/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

public extension Data {
    
    var toAttributedString: NSAttributedString? {
        return try? NSKeyedUnarchiver.unarchivedObject(
            ofClass: NSAttributedString.self,
            from: self
        )
    }
    
}
