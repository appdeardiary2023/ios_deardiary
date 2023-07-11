//
//  HomeViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

protocol HomeViewModelPresenter: AnyObject {
    func presentChild(_ viewController: UIViewController)
}

protocol HomeViewModelable {
    var tabBarViewModel: TabBarViewModel { get }
    var presenter: HomeViewModelPresenter? { get set }
    func screenDidLoad()
}

final class HomeViewModel: HomeViewModelable {
    
    private lazy var baseTabBarViewModel: BaseTabBarViewModel = {
        return BaseTabBarViewModel(tabs: TabBarViewModel.Tab.allCases)
    }()
    
    lazy var tabBarViewModel: TabBarViewModel = {
        return TabBarViewModel(selectedTab: .home, listener: self)
    }()
    
    weak var presenter: HomeViewModelPresenter?
    
}

// MARK: - Exposed Helpers
extension HomeViewModel {
    
    func screenDidLoad() {
        // Add tab bar view controller as child
        let viewController = BaseTabBarViewController(viewModel: baseTabBarViewModel)
        baseTabBarViewModel.presenter = viewController
        presenter?.presentChild(viewController)
    }
    
}

// MARK: - TabBarViewModelListener Methods
extension HomeViewModel: TabBarViewModelListener {
    
    func tabSwitched(to tab: TabBarViewModel.Tab) {
        baseTabBarViewModel.switchTab(to: tab.rawValue)
    }
    
}
