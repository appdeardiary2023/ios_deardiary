//
//  BaseTabBarViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

protocol BaseTabBarViewModelable {
    var tabBarViewModel: TabBarViewModel { get }
    var tabs: [TabBarViewModel.Tab] { get }
    var foldersViewModel: FoldersViewModel { get }
    var gridViewModel: GridViewModel { get }
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
        // TODO
    }
    
}
