//
//  ProfileDetailsTableViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 07/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SDWebImage

final class ProfileDetailsTableViewCell: UITableViewCell,
                                         ViewLoadable {
    
    static let name = Constants.TabBar.Profile.detailsTableViewCell
    static let identifier = Constants.TabBar.Profile.detailsTableViewCell
    
    private struct Style {
        static let backgroundColor = UIColor.clear
        
        static let nameLabelTextColor = Color.label.shade
        static let nameLabelFont = Font.largeTitle(.bold)
        
        static let emailLabelTextColor = Color.secondaryLabel.shade
        static let emailLabelFont = Font.title3(.bold)
    }
    
    @IBOutlet private weak var profilePicButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    private var viewModel: ProfileDetailsCellViewModelable?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension ProfileDetailsTableViewCell {
    
    func configure(with viewModel: ProfileDetailsCellViewModelable) {
        self.viewModel = viewModel
        profilePicButton.sd_setImage(
            with: viewModel.profilePicUrl,
            for: .normal,
            placeholderImage: viewModel.profilePicPlaceholderImage?
                .resize(to: profilePicButton.bounds.size)
        )
        nameLabel.text = viewModel.userName
        emailLabel.text = viewModel.userEmail
    }
    
}

// MARK: - Private Helpers
private extension ProfileDetailsTableViewCell {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        selectionStyle = .none
        setupProfilePicButton()
        setupNameLabel()
        setupEmailLabel()
    }
    
    func setupProfilePicButton() {
        profilePicButton.layer.cornerRadius = min(
            profilePicButton.bounds.width,
            profilePicButton.bounds.height
        ) / 2
    }
    
    func setupNameLabel() {
        nameLabel.textColor = Style.nameLabelTextColor
        nameLabel.font = Style.nameLabelFont
    }
    
    func setupEmailLabel() {
        emailLabel.textColor = Style.emailLabelTextColor
        emailLabel.font = Style.emailLabelFont
    }
    
    @IBAction func profilePicButtonTapped() {
        viewModel?.profilePicButtonTapped()
    }
    
}
