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
    func floatingButtonTapped()
    func showNotesScreen(for folder: Folder, listener: NotesViewModelListener?)
    func showNoteScreen(for note: Note, listener: NoteViewModelListener?)
    func deleteAccount()
}

protocol BaseTabBarViewModelPresenter: AnyObject {
    func switchViewController(to index: Int)
    func updateFloatingButton(with image: UIImage?, isHidden: Bool)
}

protocol BaseTabBarViewModelable {
    var tabs: [TabBarViewModel.Tab] { get }
    var floatingButtonImage: UIImage? { get }
    var foldersViewModel: FoldersViewModel { get }
    var gridViewModel: GridViewModel { get }
    var calendarViewModel: CalendarViewModel { get }
    var profileViewModel: ProfileViewModel { get }
    var presenter: BaseTabBarViewModelPresenter? { get set }
    func floatingButtonTapped()
}

final class BaseTabBarViewModel: BaseTabBarViewModelable {
    
    lazy var foldersViewModel: FoldersViewModel = {
        return FoldersViewModel(listener: self)
    }()
    
    lazy var gridViewModel: GridViewModel = {
        return GridViewModel(listener: self)
    }()
    
    lazy var calendarViewModel: CalendarViewModel = {
        return CalendarViewModel(listener: self)
    }()
    
    lazy var profileViewModel: ProfileViewModel = {
        return ProfileViewModel(listener: self)
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
    
    var floatingButtonImage: UIImage? {
        return TabBarViewModel.Tab.home.floatingButtonImage
    }

    func floatingButtonTapped() {
        listener?.floatingButtonTapped()
    }
    
    func switchTab(to tab: TabBarViewModel.Tab) {
        presenter?.switchViewController(to: tab.rawValue)
        presenter?.updateFloatingButton(
            with: tab.floatingButtonImage,
            isHidden: tab.isFloatingButtonHidden
        )
    }
    
    func createNewFolder() {
        foldersViewModel.addNewFolder()
    }
    
}

// MARK: - FoldersViewModelListener Methods
extension BaseTabBarViewModel: FoldersViewModelListener {
    
    func folderSelected(_ folder: Folder, listener: NotesViewModelListener?) {
        self.listener?.showNotesScreen(for: folder, listener: listener)
    }
    
}

// MARK: - NoteViewModelListenable Methods
extension BaseTabBarViewModel: NoteViewModelListenable {
    
    func noteSelected(_ note: Note, listener: NoteViewModelListener?) {
        self.listener?.showNoteScreen(for: note, listener: listener)
    }
    
}

// MARK: - ProfileViewModelListener Methods
extension BaseTabBarViewModel: ProfileViewModelListener {
    
    func changeUserInterface(to style: UIUserInterfaceStyle) {
        listener?.changeInterfaceStyle(to: style)
    }
    
    func accountDeleted() {
        listener?.deleteAccount()
    }
    
}

// MARK: - TabBarViewModel.Tab Helpers
private extension TabBarViewModel.Tab {
    
    var floatingButtonImage: UIImage? {
        switch self {
        case .home:
            return Image.add.asset
        case .grid, .calendar:
            return nil
        case .profile:
            return Image.logout.asset
        }
    }
    
    var isFloatingButtonHidden: Bool {
        switch self {
        case .home, .profile:
            return false
        case .grid, .calendar:
            return true
        }
    }
    
}
