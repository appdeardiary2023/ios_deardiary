//
//  ProfileViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 07/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class ProfileViewController: ImagePickerViewController,
                                   ViewLoadable {
    
    static let name = Constants.Home.storyboardName
    static let identifier = Constants.Home.profileViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let tableViewBackgroundColor = UIColor.clear
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: ProfileViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

// MARK: - Private Helpers
private extension ProfileViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupTableView()
        setupImageSelection()
    }
    
    func setupTableView() {
        tableView.backgroundColor = Style.tableViewBackgroundColor
        tableView.separatorStyle = .none
        ProfileDetailsTableViewCell.register(for: tableView)
        ThemeTableViewCell.register(for: tableView)
        ProfileActionTableViewCell.register(for: tableView)
    }
    
    func setupImageSelection() {
        onImageSelected = { [weak self] image in
            self?.viewModel?.imageSelected(image)
        }
    }
    
}

// MARK: - UITableViewDelegate Methods
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectRow(at: indexPath)
    }
    
}

// MARK: - UITableViewDataSource Methods
extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel?.sections[safe: indexPath.section] else { return UITableViewCell() }
        switch section {
        case .details:
            guard let cellViewModel = viewModel?.detailsCellViewModel else { return UITableViewCell() }
            let detailsCell = ProfileDetailsTableViewCell.deque(
                from: tableView,
                at: indexPath
            )
            detailsCell.configure(with: cellViewModel)
            return detailsCell
        case .theme:
            guard let cellViewModel = viewModel?.themeCellViewModel else { return UITableViewCell() }
            let themeCell = ThemeTableViewCell.deque(
                from: tableView,
                at: indexPath
            )
            themeCell.configure(with: cellViewModel)
            return themeCell
        case .password, .delete:
            guard let cellViewModel = viewModel?.getActionCellViewModel(at: indexPath) else { return UITableViewCell() }
            let actionCell = ProfileActionTableViewCell.deque(
                from: tableView,
                at: indexPath
            )
            actionCell.configure(with: cellViewModel)
            return actionCell
        }
    }
    
}

// MARK: - ProfileViewModelPresenter Methods
extension ProfileViewController: ProfileViewModelPresenter {
    
    func showImagePickerScreen() {
        openImagePicker()
    }
    
    func reloadSections(_ sections: IndexSet) {
        tableView.reloadSections(sections, with: .automatic)
    }
    
}
