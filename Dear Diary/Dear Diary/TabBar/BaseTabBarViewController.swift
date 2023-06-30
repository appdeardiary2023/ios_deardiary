//
//  BaseTabBarViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SnapKit

final class BaseTabBarViewController: UITabBarController {
    
    private struct Style {
        static let backgroundColor = Color.background.shade
    }
    
    private lazy var tabBarView: TabBarView = {
        let viewModel = viewModel.tabBarViewModel
        let view = TabBarView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        viewModel.presenter = view
        return view
    }()
    
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
        view.backgroundColor = Style.backgroundColor
        // Using a custom tab bar instead to have more control over selection
        tabBar.isHidden = true
        setupTabBarView()
        setupViewControllers()
    }
    
    func setupTabBarView() {
        view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setupViewControllers() {
        viewControllers = viewModel.tabs.map { tab in
            switch tab {
            case .home:
                return FoldersViewController(viewModel: viewModel.foldersViewModel)
            case .grid:
                return GridViewController(viewModel: viewModel.gridViewModel)
            case .calendar:
                // TODO
                return UIViewController()
            case .settings:
                // TODO
                return UIViewController()
            }
        }
    }
    
}
