//
//  FormattingOptionsView.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 27/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SnapKit

final class FormattingOptionsView: UIView {
    
    private struct Style {
        static let backgroundColor = Color.secondaryBackground.shade
        static let cornerRadius = Constants.Layout.cornerRadius
        
        static let stackViewVerticalInset: CGFloat = 16
        static let stackViewHorizontalInset: CGFloat = 30
        
        static let stackViewSpacing: CGFloat = 20
        
        static let optionButtonDefaultTintColor = Color.label.shade
        static let optionButtonSelectedTintColor = Color.primary.shade
        static let optionButtonFont = Font.title2(.regular)
        static let optionButtonImageViewSize = CGSize(width: 24, height: 24)
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: optionButtons)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalCentering
        view.spacing = Style.stackViewSpacing
        return view
    }()
    
    private lazy var optionButtons: [UIButton] = {
        guard let viewModel = viewModel else { return [] }
        return viewModel.flow.options.map { option in
            let button = UIButton(type: .system)
            button.tag = option.rawValue
            button.tintColor = Style.optionButtonDefaultTintColor
            button.titleLabel?.font = Style.optionButtonFont
            button.setImage(
                option.image?.resize(to: Style.optionButtonImageViewSize)?
                    .withRenderingMode(.alwaysTemplate),
                for: .normal
            )
            button.setTitle(option.title, for: .normal)
            button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
            return button
        }
    }()
    
    private let viewModel: FormattingOptionsViewModelable?

    init(viewModel: FormattingOptionsViewModelable?) {
        self.viewModel = viewModel
        super.init(frame: CGRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Helpers
private extension FormattingOptionsView {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        layer.cornerRadius = Style.cornerRadius
        setupStackView()
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Style.stackViewVerticalInset)
            $0.leading.trailing.equalToSuperview().inset(Style.stackViewHorizontalInset)
        }
    }
    
    @objc
    func optionButtonTapped(_ sender: UIButton) {
        viewModel?.optionButtonTapped(with: sender.tag)
    }
    
}

// MARK: - FormattingOptionsViewModelPresenter Methods
extension FormattingOptionsView: FormattingOptionsViewModelPresenter {
    
    func deselectOption(_ option: FormattingOptionsViewModel.Option?) {
        guard let button = optionButtons.first(where: { $0.tag == option?.rawValue }) else { return }
        button.tintColor = Style.optionButtonDefaultTintColor
    }
    
    func selectOption(_ option: FormattingOptionsViewModel.Option) {
        guard let button = optionButtons.first(where: { $0.tag == option.rawValue }) else { return }
        button.tintColor = Style.optionButtonSelectedTintColor
    }
    
}
