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
        case splash
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
        case .splash:
            let viewModel = SplashViewModel()
            let viewController = SplashViewController.loadFromStoryboard()
            viewController.viewModel = viewModel
            viewModel.presenter = viewController
            viewModel.listener = self
            makeRootAndShow(viewController)
        case .home:
            let viewModel = HomeViewModel()
            let viewController = HomeViewController(viewModel: viewModel)
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
        navigationController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}

// MARK: - SplashViewModelListener Methods
extension RootLauncher: SplashViewModelListener {
    
    func splashTimedOut() {
        // Show registration screen
        // TODO: Change based on existing user account
        let viewModel = RegisterViewModel(flow: .signUp, listener: self)
        let viewController = RegisterViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        viewModel.presenter = viewController
        makeRootAndShow(viewController)
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
