//
//  HomeViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import DearDiaryStrings

protocol HomeViewModelListener: AnyObject {
    func changeInterfaceStyle(to style: UIUserInterfaceStyle)
    func logout(flow: RegisterViewModel.Flow)
}

protocol HomeViewModelPresenter: AnyObject {
    func presentChild(_ viewController: UIViewController)
    func present(_ viewController: UIViewController)
    func dismiss(completion: @escaping () -> Void)
}

protocol HomeViewModelable: ViewLifecyclable {
    var tabBarViewModel: TabBarViewModel { get }
    var presenter: HomeViewModelPresenter? { get set }
}

final class HomeViewModel: HomeViewModelable,
                           Alertable {
    
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
    
    func floatingButtonTapped() {
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
            // Not applicable
            return
        case .settings:
            let title = Strings.Alert.logout
            showAlert(
                with: "\(title)?",
                message: Strings.Alert.logoutMessage,
                actionTitle: title,
                onAction: { [weak self] in
                    self?.presenter?.dismiss { [weak self] in
                        self?.listener?.logout(flow: .signIn)
                    }
                }
            )
        }
    }
    
    func showNotesScreen(for folder: FolderModel, listener: NotesViewModelListener?) {
        // Show notes screen
        let viewModel = NotesViewModel(folder: folder, listener: listener)
        let viewController = NotesViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        viewModel.presenter = viewController
        presenter?.present(viewController.embeddedInNavigationController)
    }
    
    func showNoteScreen(for note: NoteModel, listener: NoteViewModelListener?) {
        // Fetch title for folder in which this note exists
        guard let folder = UserDefaults.folderData.models.first(where: {
            let noteData = UserDefaults.fetchNoteData(for: $0.id)
            return noteData.models.contains(note)
        }) else { return }
        // Show note screen
        let viewModel = NoteViewModel(
            flow: .edit(note: note),
            folderTitle: folder.title,
            listener: listener
        )
        let viewController = NoteViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        viewModel.presenter = viewController
        viewController.modalPresentationStyle = .fullScreen
        presenter?.present(viewController)
    }
    
    func deleteAccount() {
        presenter?.dismiss { [weak self] in
            self?.listener?.logout(flow: .signUp)
        }
    }
    
}

// MARK: - FolderViewModelListener Methods
extension HomeViewModel: FolderViewModelListener {
    
    func newFolderCreated() {
        baseTabBarViewModel.createNewFolder()
    }
    
}
