//
//  BaseTabBarController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 11/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

final class BaseTabBarController: UITabBarController {
    
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
private extension BaseTabBarController {
    
    func setup() {
        initializeViewControllers()
    }
    
    func initializeViewControllers() {
        var childControllers = [UIViewController]()
        viewModel.tabs.forEach { tab in
            switch tab {
            case .home:
                let viewController = HomeViewController.loadFromStoryboard()
                viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
                childControllers.append(viewController)
            case .grid:
                let viewController = GridViewController.loadFromStoryboard()
                viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
                childControllers.append(viewController)
            }
        }
        viewControllers = childControllers
    }
    
}
