//
//  HomeViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private struct Style {
        static let backgroundColor = Color.background.shade
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tabBarView: TabBarView = {
        let viewModel = viewModel.tabBarViewModel
        let view = TabBarView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        viewModel.presenter = view
        return view
    }()
    
    private let viewModel: HomeViewModelable
    
    init(viewModel: HomeViewModelable) {
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

}

// MARK: - Private Helpers
private extension HomeViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupTabBarView()
        setupContainerView()
        viewModel.screenDidLoad?()
    }
    
    func setupTabBarView() {
        view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setupContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabBarView.snp.top)
        }
    }
    
}

// MARK: - HomeViewModelPresenter Methods
extension HomeViewController: HomeViewModelPresenter {
    
    func presentChild(_ viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.didMove(toParent: self)
    }
    
    func present(_ viewController: UIViewController) {
        navigationController?.present(viewController, animated: true)
    }
    
}
