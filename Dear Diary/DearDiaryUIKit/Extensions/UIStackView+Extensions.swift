//
//  UIStackView+Extensions.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 10/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public extension UIStackView {
    
    func removeAllArrangedSubviews() {
        let removedSubviews: [UIView] = arrangedSubviews.reduce([]) {
            removeArrangedSubview($1)
            return $0 + [$1]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap { $0.constraints })
        removedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
}
