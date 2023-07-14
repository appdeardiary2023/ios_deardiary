//
//  ThemeTableViewCell.swift
//  Dear Diary
//
//  Created by Hitesh Moudgil on 2023-07-14.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import DearDiaryStrings

protocol ThemeCellListener: AnyObject {
    func changeTheme(to style: UIUserInterfaceStyle)
}

class ThemeTableViewCell: UITableViewCell,
                          ViewLoadable {
    
    static let name = Constants.TabBar.themeTableViewCell
    static let identifier = Constants.TabBar.themeTableViewCell
    
    private struct Style {
        static let themeLabelTextColor = Color.label.shade
        static let themeLabelFont = Font.title3(.bold)
        
        static let backgroundColor = UIColor.clear
    }
    
    enum Theme: Int, CaseIterable {
        case light
        case system
        case dark
    }

    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    
    weak var listener: ThemeCellListener?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
        selectionStyle = .none
        backgroundColor = Style.backgroundColor
        setupThemeLabel()
        setupThemeSegmentedControl()
    }
    
    func setupThemeLabel(){
        themeLabel.textColor = Style.themeLabelTextColor
        themeLabel.font = Style.themeLabelFont
        themeLabel.text = Strings.Settings.manageTheme
    }
    
    func setupThemeSegmentedControl(){
        Theme.allCases.enumerated().forEach {index, theme in
            themeSegmentedControl.setTitle(theme.title, forSegmentAt: index)
        }
    }
    
    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        guard let theme = Theme(rawValue: sender.selectedSegmentIndex) else { return }
        listener?.changeTheme(to: theme.style)
        
    }
    
}

private extension ThemeTableViewCell.Theme {
    var title: String {
        switch self {
        case .light:
            return Strings.Settings.lightTheme
        case .system:
            return Strings.Settings.systemTheme
        case .dark:
            return Strings.Settings.darkTheme
        }
    }
    
    var style: UIUserInterfaceStyle {
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
