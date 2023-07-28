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
    func changeInterfaceStyle(to style: UIUserInterfaceStyle)
    func showNotesScreen(with title: String)
}

protocol BaseTabBarViewModelPresenter: AnyObject {
    func switchViewController(to index: Int)
    func updateAddButton(isHidden: Bool)
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
        return FoldersViewModel(listener: self)
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
    
    func switchTab(to tab: TabBarViewModel.Tab) {
        presenter?.switchViewController(to: tab.rawValue)
        presenter?.updateAddButton(isHidden: tab.isAddButtonHidden)
    }
    
}

// MARK: - FoldersViewModelListener Methods
extension BaseTabBarViewModel: FoldersViewModelListener {
    
    func folderSelected(with title: String) {
        listener?.showNotesScreen(with: title)
    }
    
}

// MARK: - SettingsViewModelListener Methods
extension BaseTabBarViewModel: SettingsViewModelListener {
    
    func changeUserInterface(to style: UIUserInterfaceStyle) {
        listener?.changeInterfaceStyle(to: style)
    }
    
}

// MARK: - TabBarViewModel.Tab Helpers
private extension TabBarViewModel.Tab {
    
    var isAddButtonHidden: Bool {
        switch self {
        case .home, .grid, .calendar:
            return false
        case .settings:
            return true
        }
    }
    
}
