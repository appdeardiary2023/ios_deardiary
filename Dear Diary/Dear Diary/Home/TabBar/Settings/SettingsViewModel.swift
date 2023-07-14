//
//  SettingsViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

protocol SettingsViewModelListener: AnyObject {
    func changeTheme(to style: UIUserInterfaceStyle)
}

protocol SettingsViewModelable {
    func changeTheme(to style: UIUserInterfaceStyle)
}

final class SettingsViewModel: SettingsViewModelable {
    
    private weak var listener: SettingsViewModelListener?
    
    init(listener: SettingsViewModelListener?) {
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension SettingsViewModel {
    
    func changeTheme(to style: UIUserInterfaceStyle) {
        listener?.changeTheme(to: style)
    }
    
}
