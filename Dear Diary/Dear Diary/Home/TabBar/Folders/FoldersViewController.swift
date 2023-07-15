//
//  FoldersViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class FoldersViewController: UIViewController,
                                   ViewLoadable {
    
    static let name = Constants.TabBar.storyboardName
    static let identifier = Constants.TabBar.foldersViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let titleLabelTextColor = Color.label.shade
        static let titleLabelFont = Font.largeTitle(.bold)
        
        static let searchBarTintColor = Color.secondaryBackground.shade
        static let searchBarTextFieldBackgroundColor = UIColor.clear
        static let searchBarTextFieldTextColor = Color.label.shade
        static let searchBarTextFieldPlaceholderColor = Color.tertiaryLabel.shade
        static let searchBarTextFieldTintColor = Color.secondaryLabel.shade
        static let searchBarTextFieldFont = Font.title3(.regular)
        static let searchBarTextFieldPlaceholderFont = Font.title3(.regular)
        static let searchBarImageTintColor = Color.secondaryLabel.shade
        static let searchBarImageViewSize = CGSize(width: 24, height: 24)
        static let searchBarCornerRadius = Constants.Layout.cornerRadius
        static let searchBarBorderColor = Color.secondaryBackground.shade
        static let searchBarBorderWidth: CGFloat = 1
        
        static let tableViewBackgroundColor = UIColor.clear
    }
    
    @IBOutlet private weak var profileButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: FoldersViewModelable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension FoldersViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupProfileButton()
        setupTitleLabel()
        setupSearchBar()
        setupTableView()
        viewModel?.screenDidLoad()
    }
    
    func setupProfileButton() {
        profileButton.setImage(
            viewModel?.profileButtonImage?.resize(to: profileButton.bounds.size),
            for: .normal
        )
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
        titleLabel.text = viewModel?.titleLabelText
    }
    
    func setupSearchBar() {
        guard let viewModel = viewModel else { return }
        searchBar.barTintColor = Style.searchBarTintColor
        searchBar.searchTextField.backgroundColor = Style.searchBarTextFieldBackgroundColor
        searchBar.searchTextField.textColor = Style.searchBarTextFieldTextColor
        searchBar.searchTextField.tintColor = Style.searchBarTextFieldTintColor
        searchBar.searchTextField.font = Style.searchBarTextFieldFont
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: viewModel.searchBarPlaceholder,
            attributes: [
                .foregroundColor: Style.searchBarTextFieldPlaceholderColor,
                .font: Style.searchBarTextFieldPlaceholderFont
            ]
        )
        searchBar.setImage(
            viewModel.searchBarImage?
                .withTintColor(Style.searchBarImageTintColor)
                .resize(to: Style.searchBarImageViewSize),
            for: .search,
            state: .normal
        )
        searchBar.layer.cornerRadius = Style.searchBarCornerRadius
        searchBar.layer.borderColor = Style.searchBarBorderColor.cgColor
        searchBar.layer.borderWidth = Style.searchBarBorderWidth
        searchBar.clipsToBounds = true
    }
    
    func setupTableView() {
        tableView.backgroundColor = Style.tableViewBackgroundColor
        tableView.separatorStyle = .none
        FolderTableViewCell.register(for: tableView)
    }
    
    @IBAction func profileButtonTapped() {
        viewModel?.profileButtonTapped()
    }
    
}

// MARK: - UITableViewDelegate Methods
extension FoldersViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource Methods
extension FoldersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.folders.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel?.getCellViewModel(at: indexPath) else { return UITableViewCell() }
        let folderCell = FolderTableViewCell.deque(from: tableView, at: indexPath)
        folderCell.configure(with: cellViewModel)
        return folderCell
    }
    
}

// MARK: - FoldersViewModelPresenter Methods
extension FoldersViewController: FoldersViewModelPresenter {
    
    func reload() {
        tableView.reloadData()
    }
    
}
