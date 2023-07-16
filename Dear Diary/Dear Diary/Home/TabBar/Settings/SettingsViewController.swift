//
//  SettingsViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class SettingsViewController: UIViewController,
                                    ViewLoadable {
    
    static let name = Constants.Home.storyboardName
    static let identifier = Constants.Home.settingsViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let tableViewBackgroundColor = UIColor.clear
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: SettingsViewModelable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension SettingsViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupTableView()
    }
    
    func setupTableView() {
        tableView.backgroundColor = Style.tableViewBackgroundColor
        tableView.separatorStyle = .none
        ThemeTableViewCell.register(for: tableView)
    }
    
}

// MARK: - UITableViewDelegate Methods
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TitleHeaderView()
        headerView.configure(with: viewModel?.headerTitle)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TitleHeaderView.calculateHeight(with: viewModel?.headerTitle)
    }
    
}

// MARK: - UITableViewDataSource Methods
extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let option = viewModel?.options[safe: indexPath.row] else { return UITableViewCell() }
        switch option {
        case .theme:
            guard let cellViewModel = viewModel?.themeCellViewModel else { return UITableViewCell() }
            let themeCell = ThemeTableViewCell.deque(from: tableView, at: indexPath)
            themeCell.configure(with: cellViewModel)
            return themeCell
        }
    }
    
}

// MARK: - SettingsViewModelPresenter Methods
extension SettingsViewController: SettingsViewModelPresenter {
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .fade)
    }
    
}
