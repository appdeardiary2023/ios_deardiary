//
//  BaseTabBarViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import DearDiaryImages

protocol BaseTabBarViewModelListener: AnyObject {
    func changeTheme(to style: UIUserInterfaceStyle)
}

protocol BaseTabBarViewModelPresenter: AnyObject {
    func switchViewController(to index: Int)
}

protocol BaseTabBarViewModelable {
    var tabs: [TabBarViewModel.Tab] { get }
    var addButtonImage: UIImage? { get }
    var foldersViewModel: FoldersViewModel { get }
    var gridViewModel: GridViewModel { get }
    var calendarViewModel: CalendarViewModel { get }
    var settingsViewModel: SettingsViewModel { get }
    var presenter: BaseTabBarViewModelPresenter? { get set }
    func addButtonTapped()
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
        return SettingsViewModel(listener: self)
    }()
    
    let tabs: [TabBarViewModel.Tab]
    weak var presenter: BaseTabBarViewModelPresenter?
    
    private weak var listener: BaseTabBarViewModelListener?
            
    init(tabs: [TabBarViewModel.Tab], listener: BaseTabBarViewModelListener?) {
        self.tabs = tabs
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension BaseTabBarViewModel {
    
    var addButtonImage: UIImage? {
        return Image.add.asset
    }
    
    func addButtonTapped() {
        // TODO
    }
    
    func switchTab(to index: Int) {
        presenter?.switchViewController(to: index)
    }
    
}

// MARK: - SettingsViewModelListener Methods
extension BaseTabBarViewModel: SettingsViewModelListener {
    
    func changeTheme(to style: UIUserInterfaceStyle) {
        listener?.changeTheme(to: style)
    }
    
}
