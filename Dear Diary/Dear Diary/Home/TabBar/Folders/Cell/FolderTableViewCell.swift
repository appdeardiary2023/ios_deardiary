//
//  FolderTableViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class FolderTableViewCell: UITableViewCell,
                                 ViewLoadable {
    
    static let name = Constants.TabBar.Folders.folderTableViewCell
    static let identifier = Constants.TabBar.Folders.folderTableViewCell
    
    private struct Style {
        static let backgroundColor = UIColor.clear
        
        static let containerViewBackgroundColor = Color.secondaryBackground.shade
        static let conainerViewCornerRadius = Constants.Layout.cornerRadius
        
        static let titleLabelTextColor = Color.label.shade
        static let titleLabelFont = Font.title3(.regular)
        
        static let arrowImageViewTintColor = Color.label.shade
        
        static let countLabelTextColor = Color.label.shade
        static let countLabelFont = Font.largeTitle(.bold)
    }
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension FolderTableViewCell {
    
    func configure(with viewModel: FolderCellViewModelable) {
        titleLabel.text = viewModel.folder.title
        arrowImageView.image = viewModel.arrowImage?.withTintColor(Style.arrowImageViewTintColor)
        countLabel.text = String(viewModel.folder.notesCount)
    }
    
}

// MARK: - Private Helpers
private extension FolderTableViewCell {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        selectionStyle = .none
        setupContainerView()
        setupTitleLabel()
        setupCountLabel()
    }
    
    func setupContainerView() {
        containerView.backgroundColor = Style.containerViewBackgroundColor
        containerView.layer.cornerRadius = Style.conainerViewCornerRadius
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
    }
    
    func setupCountLabel() {
        countLabel.textColor = Style.countLabelTextColor
        countLabel.font = Style.countLabelFont
    }
    
}
