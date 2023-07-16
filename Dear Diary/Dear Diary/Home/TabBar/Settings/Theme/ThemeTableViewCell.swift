//
//  ThemeTableViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 16/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class ThemeTableViewCell: UITableViewCell,
                                ViewLoadable {
    
    static let name = Constants.TabBar.Settings.themeTableViewCell
    static let identifier = Constants.TabBar.Settings.themeTableViewCell
    
    private struct Style {
        static let backgroundColor = UIColor.clear
       
        static let titleLabelTextColor = Color.label.shade
        static let titleLabelFont = Font.title3(.bold)
        
        static let themeSegmentedControlBackgroundColor = UIColor.clear
        static let themeSegmentedControlTintColor = UIColor.clear
        static let themeSegmentedControlSelectedTintColor = Color.primary.shade
        static let themeSegmentedControlTextColor = Color.label.shade
        static let themeSegmentedControlSelectedTextColor = Color.white.shade
        static let themeSegmentedControlFont = Font.subheadline(.semibold)
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var themeSegmentedControl: UISegmentedControl!
    
    private var viewModel: ThemeCellViewModelable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension ThemeTableViewCell {
    
    func configure(with viewModel: ThemeCellViewModelable) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.titleLabelText
        themeSegmentedControl.selectedSegmentIndex = viewModel.selectedTheme.rawValue
        viewModel.themes.enumerated().forEach { (index, theme) in
            themeSegmentedControl.setTitle(theme.title, forSegmentAt: index)
        }
    }
    
}

// MARK: - Private Helpers
private extension ThemeTableViewCell {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        selectionStyle = .none
        setupTitleLabel()
        setupThemeSegmentedControl()
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
    }
    
    func setupThemeSegmentedControl() {
        themeSegmentedControl.backgroundColor = Style.themeSegmentedControlBackgroundColor
        themeSegmentedControl.tintColor = Style.themeSegmentedControlTintColor
        themeSegmentedControl.selectedSegmentTintColor = Style.themeSegmentedControlSelectedTintColor
        themeSegmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: Style.themeSegmentedControlTextColor,
                .font: Style.themeSegmentedControlFont
            ],
            for: .normal
        )
        themeSegmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: Style.themeSegmentedControlSelectedTextColor,
                .font: Style.themeSegmentedControlFont
            ],
            for: .selected
        )
        themeSegmentedControl.setBackgroundImage(nil, for: .normal, barMetrics: .default)
        themeSegmentedControl.setBackgroundImage(nil, for: .selected, barMetrics: .default)
        themeSegmentedControl.setBackgroundImage(nil, for: .highlighted, barMetrics: .default)
        themeSegmentedControl.setDividerImage(
            UIImage(),
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .default
        )
        themeSegmentedControl.setDividerImage(
            UIImage(),
            forLeftSegmentState: .selected,
            rightSegmentState: .selected,
            barMetrics: .default
        )
        themeSegmentedControl.setDividerImage(
            UIImage(),
            forLeftSegmentState: .highlighted,
            rightSegmentState: .highlighted,
            barMetrics: .default
        )
    }
    
    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        viewModel?.themeValueChanged(to: sender.selectedSegmentIndex)
    }
    
}
