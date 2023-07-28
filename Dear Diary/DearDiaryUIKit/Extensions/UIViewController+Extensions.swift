//
//  UIViewController+Extensions.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 25/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    var embeddedInNavigationController: UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalPresentationCapturesStatusBarAppearance = true
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
    
}
