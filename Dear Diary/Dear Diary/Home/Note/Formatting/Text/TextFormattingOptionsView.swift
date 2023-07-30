//
//  TextFormattingOptionsView.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 27/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class TextFormattingOptionsView: UIView,
                                       ViewLoadable {
    
    static let name = Constants.Note.textFormattingOptionsView
    static let identifier = Constants.Note.textFormattingOptionsView
    
    fileprivate struct Style {
        static let backgroundColor = Color.secondaryBackground.shade
        static let cornerRadius = Constants.Layout.cornerRadius
        
        static let formatLabelTextColor = Color.label.shade
        static let formatLabelFont = Font.title2(.bold)
        
        static let closeButtonBackgroundColor = Color.primary.shade
        static let closeButtonTintColor = Color.white.shade
        static let closeButtonImageViewSize = CGSize(width: 24, height: 24)
        
        static let formattingContainerViewBackgroundColor = Color.background.shade
        
        static let formattingButtonDefaultTintColor = Color.label.shade
        static let formattingButtonSelectedTintColor = Color.primary.shade
        static let formattingButtonTitleFont = Font.title1(.bold)
        static let formattingButtonBodyFont = Font.headline(.regular)
        static let formattingButtonBoldBodyFont = Font.headline(.bold)
        static let formattingButtonItalicBodyFont = Font.headline(.regularItalic)
        static let formattingButtonBoldItalicBodyFont = Font.headline(.boldItalic)
        static let formattingButtonMonospacedFont = Font.headline(.regularMonospaced)
        static let formattingButtonBoldMonospacedFont = Font.headline(.boldMonospaced)
        static let formattingButtonImageViewSize = CGSize(width: 24, height: 24)
        
        static let animationDuration = Constants.Animation.defaultDuration
    }

    @IBOutlet private weak var formatLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private var formattingButtons: [UIButton]!
    @IBOutlet private var formattingContainerViews: [UIView]!
    
    var viewModel: TextFormattingOptionsViewModelable? {
        didSet {
            setup()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFormattingContainerViews()
    }
    
}

// MARK: - Private Helpers
private extension TextFormattingOptionsView {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        layer.cornerRadius = Style.cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupFormatLabel()
        setupCloseButton()
        setupFormattingButtons()
        slideUp(withDuration: Style.animationDuration)
    }
    
    func setupFormatLabel() {
        formatLabel.textColor = Style.formatLabelTextColor
        formatLabel.font = Style.formatLabelFont
        formatLabel.text = viewModel?.formatLabelText
    }
    
    func setupCloseButton() {
        closeButton.backgroundColor = Style.closeButtonBackgroundColor
        closeButton.tintColor = Style.closeButtonTintColor
        closeButton.setImage(
            viewModel?.closeButtonImage?
            .resize(to: Style.closeButtonImageViewSize),
            for: .normal
        )
        closeButton.setTitle(nil, for: .normal)
        closeButton.layer.cornerRadius = min(closeButton.bounds.width, closeButton.bounds.height) / 2
    }
    
    func setupFormattingButtons() {
        guard let viewModel = viewModel else { return }
        for (index, formatting) in viewModel.formattings.enumerated() {
            guard let button = formattingButtons[safe: index] else { return }
            button.tag = formatting.rawValue
            button.tintColor = Style.formattingButtonDefaultTintColor
            button.setImage(formatting.image?.resize(to: Style.formattingButtonImageViewSize)?
                .withRenderingMode(.alwaysTemplate),
                for: .normal
            )
            if let font = formatting.font,
               let title = formatting.title {
                var titleAttributes: [NSAttributedString.Key: Any] = [.font: font]
                switch formatting {
                case .title, .body, .monospaced, .bold, .italic, .bulletList, .numberList, .leftAlign, .centerAlign, .rightAlign:
                    let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
                    button.setAttributedTitle(attributedTitle, for: .normal)
                    continue
                case .underline:
                    titleAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
                case .strikethrough:
                    titleAttributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
                }
                let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
                button.setAttributedTitle(attributedTitle, for: .normal)
            } else {
                button.setTitle(nil, for: .normal)
            }
        }
    }
    
    func setupFormattingContainerViews() {
        DispatchQueue.main.async { [weak self] in
            self?.formattingContainerViews.forEach { view in
                view.backgroundColor = Style.formattingContainerViewBackgroundColor
                view.layer.cornerRadius = min(view.bounds.width, view.bounds.height) / 2
            }
        }
    }
    
    @IBAction func closeButtonTapped() {
        viewModel?.closeButtonTapped()
    }
    
    @IBAction func formattingButtonTapped(_ sender: UIButton) {
        viewModel?.formattingButtonTapped(with: sender.tag)
    }
    
}

// MARK: - TextFormattingOptionsViewModelPresenter Methods
extension TextFormattingOptionsView: TextFormattingOptionsViewModelPresenter {
    
    func removeFromParentView() {
        slideDown(withDuration: Style.animationDuration)
    }
    
    func deselectFormatting(_ formatting: TextFormattingOptionsViewModel.Formatting) {
        // TODO
    }
    
    func selectFormatting(_ formatting: TextFormattingOptionsViewModel.Formatting) {
        // TODO
    }
    
}

// MARK: - TextFormattingOptionsViewModel.Formatting Helpers
extension TextFormattingOptionsViewModel.Formatting {
    
    var font: UIFont? {
        switch self {
        case .title:
            return TextFormattingOptionsView.Style.formattingButtonTitleFont
        case .body, .underline, .strikethrough:
            return TextFormattingOptionsView.Style.formattingButtonBodyFont
        case .monospaced:
            return TextFormattingOptionsView.Style.formattingButtonMonospacedFont
        case .bold:
            return TextFormattingOptionsView.Style.formattingButtonBoldBodyFont
        case .italic:
            return TextFormattingOptionsView.Style.formattingButtonItalicBodyFont
        case .bulletList, .numberList, .leftAlign, .centerAlign, .rightAlign:
            return nil
        }
    }
    
}
