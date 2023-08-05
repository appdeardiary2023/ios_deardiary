//
//  HomeViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

protocol HomeViewModelListener: AnyObject {
    func changeInterfaceStyle(to style: UIUserInterfaceStyle)
}

protocol HomeViewModelPresenter: AnyObject {
    func presentChild(_ viewController: UIViewController)
    func present(_ viewController: UIViewController)
}

protocol HomeViewModelable: ViewLifecyclable {
    var tabBarViewModel: TabBarViewModel { get }
    var presenter: HomeViewModelPresenter? { get set }
}

final class HomeViewModel: HomeViewModelable {
    
    private lazy var baseTabBarViewModel: BaseTabBarViewModel = {
        return BaseTabBarViewModel(tabs: TabBarViewModel.Tab.allCases, listener: self)
    }()
    
    lazy var tabBarViewModel: TabBarViewModel = {
        return TabBarViewModel(selectedTab: .home, listener: self)
    }()
    
    weak var presenter: HomeViewModelPresenter?
    
    private weak var listener: HomeViewModelListener?
    
    init(listener: HomeViewModelListener?) {
        self.listener = listener
    }
    
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
        baseTabBarViewModel.switchTab(to: tab)
    }
    
}

// MARK: - BaseTabBarViewModelListener Methods
extension HomeViewModel: BaseTabBarViewModelListener {
    
    func changeInterfaceStyle(to style: UIUserInterfaceStyle) {
        listener?.changeInterfaceStyle(to: style)
    }
    
    func addButtonTapped() {
        switch tabBarViewModel.selectedTab {
        case .home:
            // Show new folder screen
            let viewModel = FolderViewModel(listener: self)
            let viewController = FolderViewController.loadFromStoryboard()
            viewController.viewModel = viewModel
            viewModel.presenter = viewController
            presenter?.present(viewController.embeddedInNavigationController)
        case .grid:
            // TODO
            return
        case .calendar:
            // TODO
            return
        case .settings:
            // Not applicable
            return
        }
    }
   
    func showNotesScreen(for folder: FolderModel) {
        // Show notes screen
        let viewModel = NotesViewModel(folder: folder, listener: self)
        let viewController = NotesViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        viewModel.presenter = viewController
        presenter?.present(viewController.embeddedInNavigationController)
    }
    
}

// MARK: - FolderViewModelListener Methods
extension HomeViewModel: FolderViewModelListener {
    
    func newFolderCreated() {
        baseTabBarViewModel.createNewFolder()
    }
    
}

// MARK: - NotesViewModelListener Methods
extension HomeViewModel: NotesViewModelListener {
    
    func updateNotesCount(in folderId: String, by count: Int) {
        baseTabBarViewModel.updateNotesCount(in: folderId, by: count)
    }
    
}
