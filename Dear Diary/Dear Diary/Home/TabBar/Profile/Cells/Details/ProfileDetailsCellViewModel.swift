//
//  ProfileDetailsCellViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 07/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages

protocol ProfileDetailsCellViewModelListener: AnyObject {
    func profilePicButtonTapped()
}

protocol ProfileDetailsCellViewModelable {
    var profilePicUrl: URL? { get }
    var profilePicPlaceholderImage: UIImage? { get }
    var userName: String { get }
    var userEmail: String { get }
    func profilePicButtonTapped()
}

final class ProfileDetailsCellViewModel: ProfileDetailsCellViewModelable {
    
    private weak var listener: ProfileDetailsCellViewModelListener?
    
    init(listener: ProfileDetailsCellViewModelListener?) {
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension ProfileDetailsCellViewModel {
    
    var profilePicUrl: URL? {
        guard let profilePicString = AuthStore.shared.user.profilePic else { return nil }
        return URL(string: profilePicString)
    }
    
    var profilePicPlaceholderImage: UIImage? {
        return Image.profileEdit.asset
    }
    
    var userName: String {
        return AuthStore.shared.user.name
    }
    
    var userEmail: String {
        return "\(Strings.Profile.email): \(AuthStore.shared.user.emailId)"
    }
    
    func profilePicButtonTapped() {
        listener?.profilePicButtonTapped()
    }
    
}
