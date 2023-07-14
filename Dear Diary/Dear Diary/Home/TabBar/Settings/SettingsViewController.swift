//
//  SettingsViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import DearDiaryStrings

final class SettingsViewController: UIViewController,
                                    ViewLoadable {
    
    static let name = Constants.TabBar.storyboardName
    static let identifier = Constants.TabBar.settingsViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let titleLabelTextColor = Color.label.shade
        static let titleLabelFont = Font.largeTitle(.bold)
        
        static let tableViewBackgroundColor = UIColor.clear
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SettingsViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeTableViewCell.register(for: tableView)
        setup()
    }
    
    func setup(){
        view.backgroundColor = Style.backgroundColor
        setupTitleLabel()
        setupTableView()
    }
    
    func setupTitleLabel(){
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
        titleLabel.text = Strings.Settings.settings
//        titleLabel.text = viewModel?.titleLabelText
    }

    func setupTableView(){
        tableView.backgroundColor = Style.tableViewBackgroundColor
        tableView.separatorStyle = .none
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let themeCell = ThemeTableViewCell.deque(from: tableView, at: indexPath)
        themeCell.listener = self
        return themeCell
    }
}

extension SettingsViewController: ThemeCellListener {
    
    func changeTheme(to style: UIUserInterfaceStyle) {
        viewModel?.changeTheme(to: style)
    }
    
}

