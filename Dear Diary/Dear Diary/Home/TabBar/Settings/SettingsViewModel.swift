//
//  SettingsViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings

protocol SettingsViewModelListener: AnyObject {
    func changeUserInterface(to style: UIUserInterfaceStyle)
}

protocol SettingsViewModelPresenter: AnyObject {
    func reloadRows(at indexPaths: [IndexPath])
}

protocol SettingsViewModelable {
    var headerTitle: String { get }
    var options: [SettingsViewModel.Option] { get }
    var themeCellViewModel: ThemeCellViewModelable { get }
    var presenter: SettingsViewModelPresenter? { get set }
}

final class SettingsViewModel: SettingsViewModelable {
    
    enum Option: Int, CaseIterable {
        case theme
    }
    
    let options: [Option]
    weak var presenter: SettingsViewModelPresenter?
    
    private weak var listener: SettingsViewModelListener?
    
    init(listener: SettingsViewModelListener?) {
        self.options = Option.allCases
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension SettingsViewModel {
    
    var headerTitle: String {
        return Strings.Settings.settings
    }
    
    var themeCellViewModel: ThemeCellViewModelable {
        return ThemeCellViewModel(interfaceStyle: UserDefaults.userInterfaceStyle, listener: self)
    }
    
}

// MARK: - ThemeCellViewModelListener Methods
extension SettingsViewModel: ThemeCellViewModelListener {
    
    func themeChanged(to theme: ThemeCellViewModel.Theme) {
        let interfaceStyle = theme.interfaceStyle
        UserDefaults.appSuite.set(interfaceStyle.rawValue, forKey: UserDefaults.userInterfaceStyleKey)
        let indexPath = IndexPath(row: Option.theme.rawValue, section: 0)
        presenter?.reloadRows(at: [indexPath])
        listener?.changeUserInterface(to: interfaceStyle)
    }
    
}
