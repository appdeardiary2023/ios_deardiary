//
//  BaseTabBarViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SnapKit

final class BaseTabBarViewController: UITabBarController {
    
    private struct Style {
        static let animationDuration = Constants.Animation.defaultDuration
        
        static let addButtonBackgroundColor = Color.primary.shade
        static let addButtonTintColor = Color.white.shade
        static let addButtonTrailingInset: CGFloat = 30
        static let addButtonBottomInset: CGFloat = 20
        static let addButtonWidthMultiplier: CGFloat = 0.147
    }
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Style.addButtonBackgroundColor
        button.tintColor = Style.addButtonTintColor
        button.setImage(viewModel.addButtonImage, for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: BaseTabBarViewModelable
    
    init(viewModel: BaseTabBarViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadius()
    }

}

// MARK: - Private Helpers
private extension BaseTabBarViewController {
    
    func setup() {
        // Using a custom tab bar instead to have more control over selection
        tabBar.isHidden = true
        setupViewControllers()
        setupAddButton()
    }
    
    func setupViewControllers() {
        viewControllers = viewModel.tabs.map { tab in
            switch tab {
            case .home:
                let viewModel = viewModel.foldersViewModel
                let viewController = FoldersViewController.loadFromStoryboard()
                viewController.viewModel = viewModel
                return viewController
            case .grid:
                return GridViewController(viewModel: viewModel.gridViewModel)
            case .calendar:
                return CalendarViewController(viewModel: viewModel.calendarViewModel)
            case .settings:
                return SettingsViewController(viewModel: viewModel.settingsViewModel)
            }
        }
    }
    
    func setupAddButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Style.addButtonBottomInset)
            $0.trailing.equalToSuperview().inset(Style.addButtonTrailingInset)
            $0.width.equalToSuperview().multipliedBy(Style.addButtonWidthMultiplier)
            $0.height.equalTo(addButton.snp.width)
        }
    }
    
    func setCornerRadius() {
        addButton.layer.cornerRadius = min(addButton.bounds.width, addButton.bounds.height) / 2
    }
    
    @objc
    func addButtonTapped() {
        viewModel.addButtonTapped()
    }
    
}

// MARK: - BaseTabBarViewModelPresenter Methods
extension BaseTabBarViewController: BaseTabBarViewModelPresenter {
    
    func switchViewController(to index: Int) {
        guard let currentViewController = selectedViewController,
              let newViewController = viewControllers?[safe: index] else { return }
        // TODO: Change this to slide in transition
        UIView.transition(
            from: currentViewController.view,
            to: newViewController.view,
            duration: Style.animationDuration,
            options: .transitionCrossDissolve
        ) { [weak self] _ in
            self?.selectedIndex = index
        }
    }
    
}
