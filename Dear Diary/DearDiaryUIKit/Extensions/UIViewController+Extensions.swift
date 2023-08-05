//
//  UIViewController+Extensions.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 25/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    var topMostViewController: UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topMostViewController
        }
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topMostViewController ?? navigationController
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController ?? tabBarController
        }
        return self
    }
    
    var embeddedInNavigationController: UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalPresentationCapturesStatusBarAppearance = true
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
    
}
