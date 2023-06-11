//
//  BaseTabBarViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 11/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

protocol BaseTabBarViewModelable {
    var tabs: [BaseTabBarViewModel.Tab] { get }
}

final class BaseTabBarViewModel: BaseTabBarViewModelable {
    
    /// Determines the available screen types
    enum Tab: CaseIterable {
        case home
        case grid
    }
    
    let tabs: [Tab]
    
    init() {
        self.tabs = Tab.allCases
    }
    
}

// MARK: - BaseTabBarViewModel.Tab Helpers
extension BaseTabBarViewModel.Tab {
    
}
