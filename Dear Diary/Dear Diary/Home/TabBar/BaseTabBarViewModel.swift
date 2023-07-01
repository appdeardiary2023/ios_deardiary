//
//  BaseTabBarViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation
import DearDiaryUIKit

protocol BaseTabBarViewModelPresenter: AnyObject {
    func switchViewController(to index: Int)
}

protocol BaseTabBarViewModelable {
    var tabs: [TabBarViewModel.Tab] { get }
    var foldersViewModel: FoldersViewModel { get }
    var gridViewModel: GridViewModel { get }
    var calendarViewModel: CalendarViewModel { get }
    var settingsViewModel: SettingsViewModel { get }
    var presenter: BaseTabBarViewModelPresenter? { get set }
}

final class BaseTabBarViewModel: BaseTabBarViewModelable {
    
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
    
    let tabs: [TabBarViewModel.Tab]
    weak var presenter: BaseTabBarViewModelPresenter?
            
    init(tabs: [TabBarViewModel.Tab]) {
        self.tabs = tabs
    }
    
}

// MARK: - Exposed Helpers
extension BaseTabBarViewModel {
    
    func switchTab(to index: Int) {
        presenter?.switchViewController(to: index)
    }
    
}
