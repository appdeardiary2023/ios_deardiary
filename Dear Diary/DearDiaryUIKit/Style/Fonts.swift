//
//  Fonts.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 15/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public enum Font {
    
    public enum Name: String {
        case regular, regularItalic, semibold, bold, boldItalic, regularMonospaced, boldMonospaced
        
        public var type: String {
            switch self {
            case .regular:
                return "OpenSans-Regular"
            case .regularItalic:
                return "OpenSans-Italic"
            case .semibold:
                return "OpenSans-SemiBold"
            case .bold:
                return "OpenSans-Bold"
            case .boldItalic:
                return "OpenSans-BoldItalic"
            case .regularMonospaced:
                return "NotoSansMono-Regular"
            case .boldMonospaced:
                return "NotoSansMono-Bold"
            }
        }
    }
    
    public enum Size {
        static let largeTitle: CGFloat = 31
        static let title1: CGFloat = 25
        static let title2: CGFloat = 19
        static let title3: CGFloat = 17
        static let headline: CGFloat = 16
        static let callout: CGFloat = 15
        static let subheadline: CGFloat = 14
        static let footnote: CGFloat = 12
        static let caption: CGFloat = 11
    }
    
}

// MARK: - Varied Fonts
public extension Font {
    
    static func largeTitle(_ name: Name) -> UIFont {
        return UIFont(name: name.type, size: Size.largeTitle)!
    }
    
    static func title1(_ name: Name) -> UIFont {
        return UIFont(name: name.type, size: Size.title1)!
    }
    
    static func title2(_ name: Name) -> UIFont {
        return UIFont(name: name.type, size: Size.title2)!
    }
    
    static func title3(_ name: Name) -> UIFont {
        return UIFont(name: name.type, size: Size.title3)!
    }
    
    static func headline(_ name: Name) -> UIFont {
        return UIFont(name: name.type, size: Size.headline)!
    }
    
    static func callout(_ name: Name) -> UIFont {
        return UIFont(name: name.type, size: Size.callout)!
    }
    
    static func subheadline(_ name: Name) -> UIFont {
        return UIFont(name: name.type, size: Size.subheadline)!
    }
    
    static func footnote(_ name: Name) -> UIFont {
        return UIFont(name: name.type, size: Size.footnote)!
    }
    
    static func caption(_ name: Name) -> UIFont {
        return UIFont(name: name.type, size: Size.caption)!
    }

}
