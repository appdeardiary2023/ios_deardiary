//
//  RootLauncher.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 11/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

final class RootLauncher {
    
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
}

// MARK: - Exposed Helpers
extension RootLauncher {
    
    func launch() {
        let viewModel = BaseTabBarViewModel()
        let tabBarController = BaseTabBarController(viewModel: viewModel)
        makeRootAndShow(tabBarController)
    }
    
}

// MARK: - Private Helpers
private extension RootLauncher {
    
    func makeRootAndShow(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalPresentationCapturesStatusBarAppearance = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}
