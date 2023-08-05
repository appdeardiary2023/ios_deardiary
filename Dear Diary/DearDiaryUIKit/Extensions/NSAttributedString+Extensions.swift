//
//  NSAttributedString+Extensions.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 05/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    
    var toData: Data? {
        return try? NSKeyedArchiver.archivedData(
            withRootObject: self,
            requiringSecureCoding: false
        )
    }
    
}
