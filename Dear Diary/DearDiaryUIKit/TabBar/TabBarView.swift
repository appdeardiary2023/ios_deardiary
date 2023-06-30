//
//  TabBarView.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import SnapKit

public final class TabBarView: UIView {
    
    private struct Style {
        static let backgroundColor = Color.secondaryBackground.shade
        static let cornerRadius: CGFloat = 12
       
        static let stackViewSpacing: CGFloat = 10
        static let stackViewTopInset: CGFloat = 10
        static var stackViewBottomInset: CGFloat {
            let safeAreaBottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
            return safeAreaBottomInset.isZero ? 10 : safeAreaBottomInset
        }
        static let stackViewHorizontalInset: CGFloat = 20
        
        static let tabButtonDefaultTintColor = Color.label.shade
        static let tabButtonSelectedTintColor = Color.primary.shade
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: tabButtons)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = Style.stackViewSpacing
        return view
    }()
    
    private lazy var tabButtons: [UIButton] = {
        return viewModel.tabs.map { tab in
            let button = UIButton(type: .system)
            button.tag = tab.rawValue
            button.tintColor = tab == viewModel.selectedTab
                ? Style.tabButtonSelectedTintColor
                : Style.tabButtonDefaultTintColor
            button.setImage(tab.image, for: .normal)
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            return button
        }
    }()

    private let viewModel: TabBarViewModelable
    
    public init(viewModel: TabBarViewModelable) {
        self.viewModel = viewModel
        super.init(frame: CGRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Helpers
private extension TabBarView {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = Style.cornerRadius
        addStackView()
    }
    
    func addStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Style.stackViewTopInset)
            $0.bottom.equalToSuperview().inset(Style.stackViewBottomInset)
            $0.leading.trailing.equalToSuperview().inset(Style.stackViewHorizontalInset)
        }
    }
    
    @objc
    func tabButtonTapped(_ sender: UIButton) {
        viewModel.tabButtonTapped(with: sender.tag)
    }
    
}

// MARK: - TabBarViewModelPresenter Methods
extension TabBarView: TabBarViewModelPresenter {
    
    public func updateTabButtons(deselecting oldTag: Int, selecting newTag: Int) {
        guard let oldButton = tabButtons.first(where: { $0.tag == oldTag }),
              let newButton = tabButtons.first(where: { $0.tag == newTag }) else { return }
        oldButton.tintColor = Style.tabButtonDefaultTintColor
        newButton.tintColor = Style.tabButtonSelectedTintColor
    }
    
}
