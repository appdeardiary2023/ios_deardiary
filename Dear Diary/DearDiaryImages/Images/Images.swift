//
//  Images.swift
//  DearDiaryImages
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public enum Image: String {
    case eyeOpened
    case eyeClosed
    case home
    case grid
    case calendar
    case settings
    
    public var asset: UIImage? {
        switch self {
        case .eyeOpened:
            return UIImage(named: "eye.opened")
        case .eyeClosed:
            return UIImage(named: "eye.closed")
        case .home, .grid, .calendar, .settings:
            return UIImage(named: rawValue)
        }
    }
    
}
