//
//  UIButton+Extensions.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public extension UIButton {
    
    func setContentSpacing(_ spacing: CGFloat, edgeInsets: UIEdgeInsets? = nil, isLTR: Bool) {
        imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: isLTR ? -spacing : spacing,
            bottom: 0,
            right: isLTR ? spacing : -spacing
        )
        titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: isLTR ? spacing : -spacing,
            bottom: 0,
            right: isLTR ? -spacing : spacing
        )
        guard let edgeInsets = edgeInsets else {
            contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
            return
        }
        contentEdgeInsets = UIEdgeInsets(
            top: edgeInsets.top,
            left: isLTR ? edgeInsets.left : edgeInsets.left + spacing,
            bottom: edgeInsets.bottom,
            right: isLTR ? edgeInsets.right + spacing : edgeInsets.right
        )
    }
    
}
