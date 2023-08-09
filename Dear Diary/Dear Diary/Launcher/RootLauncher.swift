//
//  RootLauncher.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 11/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class RootLauncher {
    
    enum Screen {
        case splash(screen: SplashViewModel.Screen)
        case home
    }
    
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        setup()
    }
    
}

// MARK: - Exposed Helpers
extension RootLauncher {
    
    func launch(screen: Screen) {
        switch screen {
        case let .splash(screen):
            let viewModel = SplashViewModel(screen: screen)
            let viewController = SplashViewController.loadFromStoryboard()
            viewController.viewModel = viewModel
            viewModel.presenter = viewController
            viewModel.listener = self
            makeRootAndShow(viewController)
        case .home:
            let viewModel = HomeViewModel(listener: self)
            let viewController = HomeViewController(viewModel: viewModel)
            viewModel.presenter = viewController
            makeRootAndShow(viewController)
        }
    }
    
}

// MARK: - Private Helpers
private extension RootLauncher {
    
    func setup() {
        setInterfaceStyle(to: UserDefaults.userInterfaceStyle)
    }
    
    func setInterfaceStyle(to style: UIUserInterfaceStyle) {
        window?.overrideUserInterfaceStyle = style
    }
    
    func makeRootAndShow(_ viewController: UIViewController) {
        window?.rootViewController = viewController.embeddedInNavigationController
        window?.makeKeyAndVisible()
    }
    
}

// MARK: - SplashViewModelListener Methods
extension RootLauncher: SplashViewModelListener {
    
    func splashTimedOut(screen: SplashViewModel.Screen) {
        switch screen {
        case let .register(flow):
            let viewModel = RegisterViewModel(flow: flow, listener: self)
            let viewController = RegisterViewController.loadFromStoryboard()
            viewController.viewModel = viewModel
            viewModel.presenter = viewController
            makeRootAndShow(viewController)
        case .home:
            launch(screen: .home)
        }
    }
    
}

// MARK: - RegisterViewModelListener Methods
extension RootLauncher: RegisterViewModelListener {
    
    func userSignedUp() {
        // Show parent app screen
        launch(screen: .splash(screen: .home))
    }
    
    func userSignedIn() {
        // Show parent app screen
        launch(screen: .splash(screen: .home))
    }
    
}

// MARK: - HomeViewModelListener Methods
extension RootLauncher: HomeViewModelListener {
    
    func changeInterfaceStyle(to style: UIUserInterfaceStyle) {
        UIView.transition(
            with: window ?? UIView(),
            duration: Constants.Animation.defaultDuration,
            options: .transitionCrossDissolve
        ) { [weak self] in
            self?.setInterfaceStyle(to: style)
        }
    }
    
    func logout(flow: RegisterViewModel.Flow) {
        launch(screen: .splash(screen: .register(flow: flow)))
    }
    
}
