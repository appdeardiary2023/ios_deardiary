//
//  ThemeCellViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 16/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings

protocol ThemeCellViewModelListener: AnyObject {
    func themeChanged(to theme: ThemeCellViewModel.Theme)
}

protocol ThemeCellViewModelable {
    var titleLabelText: String { get }
    var selectedTheme: ThemeCellViewModel.Theme { get }
    var themes: [ThemeCellViewModel.Theme] { get }
    func themeValueChanged(to index: Int)
}

final class ThemeCellViewModel: ThemeCellViewModelable {
    
    enum Theme: Int, CaseIterable {
        case light
        case system
        case dark
    }
    
    let selectedTheme: Theme
    let themes: [Theme]
    
    private weak var listener: ThemeCellViewModelListener?
    
    init(interfaceStyle: UIUserInterfaceStyle, listener: ThemeCellViewModelListener?) {
        self.selectedTheme = interfaceStyle.theme
        self.themes = Theme.allCases
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension ThemeCellViewModel {
    
    var titleLabelText: String {
        return Strings.Settings.theme
    }
    
    func themeValueChanged(to index: Int) {
        guard let theme = Theme(rawValue: index) else { return }
        listener?.themeChanged(to: theme)
    }
    
}

// MARK: - ThemeCellViewModel.Theme Helpers
extension ThemeCellViewModel.Theme {
    
    var title: String {
        switch self {
        case .light:
            return Strings.Settings.light
        case .system:
            return Strings.Settings.system
        case .dark:
            return Strings.Settings.dark
        }
    }
    
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .system:
            return .unspecified
        case .dark:
            return .dark
        }
    }
    
}

// MARK: - UIUserInterfaceStyle Helpers
private extension UIUserInterfaceStyle {
    
    var theme: ThemeCellViewModel.Theme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return .system
        }
    }
    
}
