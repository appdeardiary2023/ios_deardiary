//
//  BaseTabBarViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class BaseTabBarViewController: UITabBarController {
    
    private struct Style {
        static let animationDuration = Constants.Animation.defaultDuration
    }
    
    private let viewModel: BaseTabBarViewModelable
    
    init(viewModel: BaseTabBarViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension BaseTabBarViewController {
    
    func setup() {
        // Using a custom tab bar instead to have more control over selection
        tabBar.isHidden = true
        setupViewControllers()
    }
    
    func setupViewControllers() {
        viewControllers = viewModel.tabs.map { tab in
            switch tab {
            case .home:
                let viewModel = viewModel.foldersViewModel
                let viewController = FoldersViewController.loadFromStoryboard()
                viewController.viewModel = viewModel
                return viewController
            case .grid:
                return GridViewController(viewModel: viewModel.gridViewModel)
            case .calendar:
                return CalendarViewController(viewModel: viewModel.calendarViewModel)
            case .settings:
                return SettingsViewController(viewModel: viewModel.settingsViewModel)
            }
        }
    }
    
}

// MARK: - BaseTabBarViewModelPresenter Methods
extension BaseTabBarViewController: BaseTabBarViewModelPresenter {
    
    func switchViewController(to index: Int) {
        guard let currentViewController = selectedViewController,
              let newViewController = viewControllers?[safe: index] else { return }
        // TODO: Change this to slide in transition
        UIView.transition(
            from: currentViewController.view,
            to: newViewController.view,
            duration: Style.animationDuration,
            options: .transitionCrossDissolve
        ) { [weak self] _ in
            self?.selectedIndex = index
        }
    }
    
}
