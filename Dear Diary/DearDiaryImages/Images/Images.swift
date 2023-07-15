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
    case google
    case back
    case otp
    case home
    case grid
    case calendar
    case settings
    case profile
    case search
    case add
    case downArrow
    
    public var asset: UIImage? {
        switch self {
        case .eyeOpened:
            return UIImage(named: "eye.opened")
        case .eyeClosed:
            return UIImage(named: "eye.closed")
        case .google, .back, .otp, .add:
            return UIImage(named: rawValue)
        case .home, .grid, .calendar, .settings:
            return UIImage(named: "tab.\(rawValue)")
        case .profile:
            return UIImage(named: "profile.placeholder")
        case .search:
            return UIImage(named: "searchBar.glass")
        case .downArrow:
            return UIImage(named: "arrow.downward")
        }
    }
    
}
