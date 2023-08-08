//
//  ProfileActionTableViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 07/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class ProfileActionTableViewCell: UITableViewCell,
                                        ViewLoadable {
    
    static let name = Constants.TabBar.Profile.actionTableViewCell
    static let identifier = Constants.TabBar.Profile.actionTableViewCell
    
    private struct Style {
        static let backgroundColor = UIColor.clear
        
        static let titleLabelTextColor = Color.label.shade
        static let titleLabelFont = Font.title3(.bold)
        
        static let arrowImageViewTintColor = Color.label.shade
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension ProfileActionTableViewCell {
    
    func configure(with viewModel: ProfileActionCellViewModelable) {
        titleLabel.text = viewModel.titleLabelText
        arrowImageView.image = viewModel.arrowImage?
            .withTintColor(Style.arrowImageViewTintColor)
    }
    
}

// MARK: - Private Helpers
private extension ProfileActionTableViewCell {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        selectionStyle = .none
        setupTitleLabel()
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
    }
    
}
