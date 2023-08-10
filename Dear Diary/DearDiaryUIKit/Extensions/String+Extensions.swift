//
//  String+Extensions.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public enum StringSizeParameter {
    case width(constrainedHeight: CGFloat)
    case height(constrainedWidth: CGFloat)
}

public extension String {
    
    func calculate(_ parameter: StringSizeParameter, with font: UIFont) -> CGFloat {
        let constrainedSize: CGSize
        switch parameter {
        case let .width(constrainedHeight):
            constrainedSize = CGSize(width: .greatestFiniteMagnitude, height: constrainedHeight)
        case let .height(constrainedWidth):
            constrainedSize = CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude)
        }
        let boundingBox = self.boundingRect(
            with: constrainedSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        switch parameter {
        case .width:
            return boundingBox.width
        case .height:
            return boundingBox.height
        }
    }
    
    func calculate(_ parameter: StringSizeParameter, with attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let constrainedSize: CGSize
        switch parameter {
        case let .width(constrainedHeight):
            constrainedSize = CGSize(width: .greatestFiniteMagnitude, height: constrainedHeight)
        case let .height(constrainedWidth):
            constrainedSize = CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude)
        }
        let boundingBox = self.boundingRect(
            with: constrainedSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )
        switch parameter {
        case .width:
            return boundingBox.width
        case .height:
            return boundingBox.height
        }
    }
    
}
