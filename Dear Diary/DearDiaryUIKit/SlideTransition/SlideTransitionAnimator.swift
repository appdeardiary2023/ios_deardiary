//
//  SlideTransitionAnimator.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 08/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public final class SlideTransitionAnimator: NSObject {
    
    private let animationDuration: TimeInterval
    
    public init(animationDuration: TimeInterval) {
        self.animationDuration = animationDuration
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning Methods
extension SlideTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromView = fromViewController.view,
            let toView = toViewController.view else {
            transitionContext.completeTransition(false)
            return
        }
        let containerView = transitionContext.containerView
        let direction: CGFloat = fromViewController.tabBarItem.tag < toViewController.tabBarItem.tag ? 1 : -1
        let offset = direction * containerView.bounds.width
        containerView.addSubview(toView)
        toView.frame = CGRect(
            x: offset,
            y: 0,
            width: containerView.bounds.width,
            height: containerView.bounds.height
        )
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromView.frame = CGRect(
                    x: -offset,
                    y: 0,
                    width: containerView.bounds.width,
                    height: containerView.bounds.height
                )
                toView.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: containerView.bounds.width,
                    height: containerView.bounds.height
                )
            },
            completion: {_ in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
}
