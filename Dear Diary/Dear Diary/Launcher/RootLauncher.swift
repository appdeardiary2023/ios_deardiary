//
//  RootLauncher.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 11/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

final class RootLauncher {
    
    enum Screen {
        case registration
        case home
    }
    
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
}

// MARK: - Exposed Helpers
extension RootLauncher {
    
    func launch(screen: Screen) {
        switch screen {
        case .registration:
            // TODO: Change based on existing user account
            let viewModel = RegisterViewModel(flow: .signUp, listener: self)
            let viewController = RegisterViewController.loadFromStoryboard()
            viewController.viewModel = viewModel
            viewModel.presenter = viewController
            makeRootAndShow(viewController)
        case .home:
            let viewModel = BaseTabBarViewModel()
            let viewController = BaseTabBarViewController(viewModel: viewModel)
            viewModel.presenter = viewController
            makeRootAndShow(viewController)
        }
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

// MARK: - RegisterViewModelListener Methods
extension RootLauncher: RegisterViewModelListener {
    
    func userSignedUp() {
        // Show parent app screen
        launch(screen: .home)
    }
    
    func userSignedIn() {
        // Show parent app screen
        launch(screen: .home)
    }
    
}
