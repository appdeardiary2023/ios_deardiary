//
//  ProfileActionCellViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 07/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages

protocol ProfileActionCellViewModelable {
    var titleLabelText: String { get }
    var arrowImage: UIImage? { get }
}

final class ProfileActionCellViewModel: ProfileActionCellViewModelable {
    
    enum Action {
        case changePassword
        case deleteAccount
    }
    
    private let action: Action
    
    init(action: Action) {
        self.action = action
    }
    
}

// MARK: - Exposed Helpers
extension ProfileActionCellViewModel {
    
    var titleLabelText: String {
        return action.title
    }
    
    var arrowImage: UIImage? {
        return Image.forwardArrow.asset
    }
    
}

// MARK: - ProfileActionCellViewModel.Action Helpers
private extension ProfileActionCellViewModel.Action {
    
    var title: String {
        switch self {
        case .changePassword:
            return Strings.Profile.changePassword
        case .deleteAccount:
            return Strings.Profile.deleteAccount
        }
    }
    
}
