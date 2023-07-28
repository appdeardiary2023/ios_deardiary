//
//  UIView+Extensions.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public extension UIView {
    
    func fadeOut(withDuration duration: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = .zero
        } completion: {_ in
            completion?()
        }
    }
    
    func fadeIn(withDuration duration: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = 1
        } completion: {_ in
            completion?()
        }
    }
    
    func slideUp(withDuration duration: TimeInterval) {
        transform = CGAffineTransform(translationX: 0, y: bounds.height)
        UIView.animate(withDuration: duration) { [weak self] in
            self?.transform = .identity
        }
    }
    
    func slideDown(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.transform = CGAffineTransform(translationX: 0, y: self?.bounds.height ?? 0)
        }
    }
    
    func shake(withDuration duration: TimeInterval,
               values: [CGFloat] = [-5, 5, -4, 4, -3, 3, -2, 2, -1, 1, 0]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.values = values
        layer.add(animation, forKey: nil)
    }
    
}
