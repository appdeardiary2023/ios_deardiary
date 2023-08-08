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
        static let floatingButtonBackgroundColor = Color.primary.shade
        static let floatingButtonTintColor = Color.white.shade
        static let floatingButtonTrailingInset: CGFloat = 30
        static let floatingButtonBottomInset: CGFloat = 20
        static let floatingButtonWidthMultiplier: CGFloat = 0.147
        
        static let animationDuration = Constants.Animation.defaultDuration
    }
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Style.floatingButtonBackgroundColor
        button.tintColor = Style.floatingButtonTintColor
        button.setImage(viewModel.floatingButtonImage, for: .normal)
        button.addTarget(
            self,
            action: #selector(floatingButtonTapped),
            for: .touchUpInside
        )
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
        delegate = self
        setupViewControllers()
        setupFloatingButton()
    }
    
    func setupViewControllers() {
        viewControllers = viewModel.tabs.map { tab in
            switch tab {
            case .home:
                let viewModel = viewModel.foldersViewModel
                let viewController = FoldersViewController.loadFromStoryboard()
                viewController.tabBarItem.tag = tab.rawValue
                viewController.viewModel = viewModel
                viewModel.presenter = viewController
                return viewController
            case .grid:
                let viewModel = viewModel.gridViewModel
                let viewController = GridViewController.loadFromStoryboard()
                viewController.tabBarItem.tag = tab.rawValue
                viewController.viewModel = viewModel
                viewModel.presenter = viewController
                return viewController
            case .calendar:
                let viewModel = viewModel.calendarViewModel
                let viewController = CalendarViewController.loadFromStoryboard()
                viewController.tabBarItem.tag = tab.rawValue
                viewController.viewModel = viewModel
                viewModel.presenter = viewController
                return viewController
            case .settings:
                let viewModel = viewModel.profileViewModel
                let viewController = ProfileViewController.loadFromStoryboard()
                viewController.tabBarItem.tag = tab.rawValue
                viewController.viewModel = viewModel
                viewModel.presenter = viewController
                return viewController
            }
        }
    }
    
    func setupFloatingButton() {
        view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Style.floatingButtonBottomInset)
            $0.trailing.equalToSuperview().inset(Style.floatingButtonTrailingInset)
            $0.width.equalToSuperview().multipliedBy(Style.floatingButtonWidthMultiplier)
            $0.height.equalTo(floatingButton.snp.width)
        }
    }
    
    func setCornerRadius() {
        floatingButton.layer.cornerRadius = min(
            floatingButton.bounds.width,
            floatingButton.bounds.height
        ) / 2
    }
    
    @objc
    func floatingButtonTapped() {
        viewModel.floatingButtonTapped()
    }
    
}

// MARK: - UITabBarControllerDelegate Methods
extension BaseTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideTransitionAnimator(animationDuration: Style.animationDuration)
    }
    
}

// MARK: - BaseTabBarViewModelPresenter Methods
extension BaseTabBarViewController: BaseTabBarViewModelPresenter {
    
    func switchViewController(to index: Int) {
        selectedIndex = index
    }
    
    func updateFloatingButton(with image: UIImage?, isHidden: Bool) {
        floatingButton.setImage(image, for: .normal)
        floatingButton.isHidden = isHidden
    }
    
}
