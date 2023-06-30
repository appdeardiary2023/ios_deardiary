//
//  BaseTabBarViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

protocol BaseTabBarViewModelPresenter: AnyObject {
    func switchViewController(to index: Int)
}

protocol BaseTabBarViewModelable {
    var tabBarViewModel: TabBarViewModel { get }
    var tabs: [TabBarViewModel.Tab] { get }
    var foldersViewModel: FoldersViewModel { get }
    var gridViewModel: GridViewModel { get }
    var calendarViewModel: CalendarViewModel { get }
    var settingsViewModel: SettingsViewModel { get }
    var presenter: BaseTabBarViewModelPresenter? { get set }
}

final class BaseTabBarViewModel: BaseTabBarViewModelable {
    
    lazy var tabBarViewModel: TabBarViewModel = {
        return TabBarViewModel(selectedTab: .home, listener: self)
    }()
    
    lazy var foldersViewModel: FoldersViewModel = {
        return FoldersViewModel()
    }()
    
    lazy var gridViewModel: GridViewModel = {
        return GridViewModel()
    }()
    
    lazy var calendarViewModel: CalendarViewModel = {
        return CalendarViewModel()
    }()
    
    lazy var settingsViewModel: SettingsViewModel = {
        return SettingsViewModel()
    }()
    
    weak var presenter: BaseTabBarViewModelPresenter?
            
    init() {
        
    }
    
}

// MARK: - Exposed Helpers
extension BaseTabBarViewModel {
    
    var tabs: [TabBarViewModel.Tab] {
        return tabBarViewModel.tabs
    }
    
}

// MARK: - TabBarViewModelListener Methods
extension BaseTabBarViewModel: TabBarViewModelListener {
    
    func tabSwitched(to tab: DearDiaryUIKit.TabBarViewModel.Tab) {
        presenter?.switchViewController(to: tab.rawValue)
    }
    
}
