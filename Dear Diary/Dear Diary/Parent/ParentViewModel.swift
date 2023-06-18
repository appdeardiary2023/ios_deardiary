//
//  ParentViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryImages

protocol ParentViewModelable {
    var items: [ParentViewModel.Item] { get }
    var selectedItem: ParentViewModel.Item { get }
}

final class ParentViewModel: ParentViewModelable {
    
    enum Item: Int, CaseIterable {
        case home
        case grid
        case calendar
        case settings
    }
    
    let items: [Item]
    
    private(set) var selectedItem: Item
    
    init() {
        self.items = Item.allCases
        self.selectedItem = .home
    }
    
}

// MARK: - ParentViewModel.Item Helpers
extension ParentViewModel.Item {
    
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
