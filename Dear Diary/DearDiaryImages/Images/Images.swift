//
//  Images.swift
//  DearDiaryImages
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public enum Image: String {
    case logo
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
    case forwardArrow
    case extras
    case copy
    case lock
    case close
    case bulletList
    case numberList
    case leftAlign
    case centerAlign
    case rightAlign
    
    public var asset: UIImage? {
        switch self {
        case .logo:
            return UIImage(named: "app.logo")
        case .eyeOpened:
            return UIImage(named: "eye.opened")
        case .eyeClosed:
            return UIImage(named: "eye.closed")
        case .google, .back, .otp, .add, .close:
            return UIImage(named: rawValue)
        case .home, .grid, .calendar, .settings:
            return UIImage(named: "tab.\(rawValue)")
        case .profile:
            return UIImage(named: "profile.placeholder")
        case .search:
            return UIImage(named: "searchBar.glass")
        case .downArrow:
            return UIImage(named: "arrow.downward")
        case .forwardArrow:
            return UIImage(named: "arrow.forward")
        case .extras:
            return UIImage(named: "option.extras")
        case .copy:
            return UIImage(named: "option.extras.copy")
        case .lock:
            return UIImage(named: "option.extras.lock")
        case .bulletList:
            return UIImage(named: "text.bullet.list")
        case .numberList:
            return UIImage(named: "text.number.list")
        case .leftAlign:
            return UIImage(named: "text.align.left")
        case .centerAlign:
            return UIImage(named: "text.align.center")
        case .rightAlign:
            return UIImage(named: "text.align.right")
        }
    }
    
}
