//
//  ProfileViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 07/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

protocol ProfileViewModelListener: AnyObject {
    func changeUserInterface(to style: UIUserInterfaceStyle)
}

protocol ProfileViewModelPresenter: AnyObject {
    func showImagePickerScreen()
    func reloadSections(_ sections: IndexSet)
}

protocol ProfileViewModelable {
    var sections: [ProfileViewModel.Section] { get }
    var detailsCellViewModel: ProfileDetailsCellViewModelable { get }
    var themeCellViewModel: ThemeCellViewModelable { get }
    func getActionCellViewModel(at indexPath: IndexPath) -> ProfileActionCellViewModelable?
    func didSelectRow(at indexPath: IndexPath)
    func imageSelected(_ image: UIImage)
}

final class ProfileViewModel: ProfileViewModelable {
    
    enum Section: Int, CaseIterable {
        case details
        case theme
        case password
        case delete
    }
    
    let sections: [Section]
    weak var presenter: ProfileViewModelPresenter?
    
    private weak var listener: ProfileViewModelListener?
    
    init(listener: ProfileViewModelListener?) {
        self.sections = Section.allCases
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension ProfileViewModel {
    
    var detailsCellViewModel: ProfileDetailsCellViewModelable {
        return ProfileDetailsCellViewModel(listener: self)
    }
    
    var themeCellViewModel: ThemeCellViewModelable {
        return ThemeCellViewModel(
            interfaceStyle: UserDefaults.userInterfaceStyle,
            listener: self
        )
    }
    
    func getActionCellViewModel(at indexPath: IndexPath) -> ProfileActionCellViewModelable? {
        guard let section = sections[safe: indexPath.section],
              let action = section.action else { return nil }
        return ProfileActionCellViewModel(action: action)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let section = sections[safe: indexPath.row] else { return }
        switch section {
        case .details, .theme:
            // Not applicable
            return
        case .password:
            // TODO
            return
        case .delete:
            // TODO
            return
        }
    }
    
    func imageSelected(_ image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first,
              let imageData = image.jpegData(compressionQuality: 1) else { return }
        var users = UserDefaults.users
        guard var user = users.first(where: { $0.id == AuthStore.shared.user.id }),
              let index = users.firstIndex(of: user) else { return }
        let imageUrl = documentsDirectory.appendingPathComponent(user.id)
        try? imageData.write(to: imageUrl)
        // Save this image url in user profile
        user.profilePic = imageUrl.absoluteString
        users[index] = user
        UserDefaults.saveUsers(with: users)
        AuthStore.shared.user = user
        let sections = IndexSet(integer: Section.details.rawValue)
        presenter?.reloadSections(sections)
    }
    
}

// MARK: - ProfileDetailsCellViewModelListener Methods
extension ProfileViewModel: ProfileDetailsCellViewModelListener {
    
    func profilePicButtonTapped() {
        presenter?.showImagePickerScreen()
    }
    
}

// MARK: - ThemeCellViewModelListener Methods
extension ProfileViewModel: ThemeCellViewModelListener {
    
    func themeChanged(to theme: ThemeCellViewModel.Theme) {
        let interfaceStyle = theme.interfaceStyle
        UserDefaults.appSuite.set(
            interfaceStyle.rawValue,
            forKey: UserDefaults.userInterfaceStyleKey
        )
        let sections = IndexSet(integer: Section.theme.rawValue)
        presenter?.reloadSections(sections)
        listener?.changeUserInterface(to: interfaceStyle)
    }
    
}

// MARK: - ProfileViewModel.Section Helpers
private extension ProfileViewModel.Section {
    
    var action: ProfileActionCellViewModel.Action? {
        switch self {
        case .details, .theme:
            return nil
        case .password:
            return .changePassword
        case .delete:
            return .deleteAccount
        }
    }
    
}
