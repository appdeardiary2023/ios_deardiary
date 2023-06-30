//
//  TabBarViewModel.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryImages

public protocol TabBarViewModelListener: AnyObject {
    func tabSwitched(to tab: TabBarViewModel.Tab)
}

public protocol TabBarViewModelPresenter: AnyObject {
    func updateTabButtons(deselecting oldTag: Int, selecting newTag: Int)
}

public protocol TabBarViewModelable {
    var tabs: [TabBarViewModel.Tab] { get }
    var selectedTab: TabBarViewModel.Tab { get }
    var presenter: TabBarViewModelPresenter? { get set }
    func tabButtonTapped(with tag: Int)
}

public final class TabBarViewModel: TabBarViewModelable {
    
    public enum Tab: Int, CaseIterable {
        case home
        case grid
        case calendar
        case settings
    }
    
    public let tabs: [Tab]
    public weak var presenter: TabBarViewModelPresenter?
    
    private(set) public var selectedTab: Tab
    
    private weak var listener: TabBarViewModelListener?
    
    public init(selectedTab: Tab, listener: TabBarViewModelListener?) {
        self.tabs = Tab.allCases
        self.selectedTab = selectedTab
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
public extension TabBarViewModel {
    
    func tabButtonTapped(with tag: Int) {
        guard let tab = Tab(rawValue: tag),
              tab != selectedTab else { return }
        presenter?.updateTabButtons(deselecting: selectedTab.rawValue, selecting: tab.rawValue)
        listener?.tabSwitched(to: tab)
        selectedTab = tab
    }
    
}

// MARK: - TabBarViewModel.Tab Helpers
extension TabBarViewModel.Tab {
    
    var image: UIImage? {
        switch self {
        case .home:
            return Image.home.asset
        case .grid:
            return Image.grid.asset
        case .calendar:
            return Image.calendar.asset
        case .settings:
            return Image.settings.asset
        }
    }
    
}
