//
//  NoteDetailsTableViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 09/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SnapKit

final class NoteDetailsTableViewCell: UITableViewCell {
    
    static let reuseId = String(describing: NoteDetailsTableViewCell.self)
    
    private struct Style {
        static let backgroundColor = UIColor.clear
        
        static let textViewBackgroundColor = UIColor.clear
        static let textViewTintColor = Color.secondaryLabel.shade
        static let textViewTextColor = Color.label.shade
        static let textViewFont = Font.title1(.bold)
        static let textViewContainerInset = UIEdgeInsets()
        static let textViewBottomInset: CGFloat = 10
    }
    
    private lazy var textView: NotesTextView = {
        let view = NotesTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Style.textViewBackgroundColor
        view.tintColor = Style.textViewTintColor
        view.textContainerInset = Style.textViewContainerInset
        view.isScrollEnabled = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Exposed Helpers
extension NoteDetailsTableViewCell {
    
    var attributedText: NSAttributedString? {
        return textView.attributedText
    }

    func configure(with viewModel: NoteDetailsCellViewModelable) {
        textView.setup(with: viewModel.dependency.textStyle)
        if let attributedText = viewModel.dependency.attributedText {
            textView.attributedText = attributedText
        } else if let text = viewModel.dependency.text {
            textView.attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .foregroundColor: Style.textViewTextColor,
                    .font: Style.textViewFont
                ]
            )
        }
        textView.shouldAdjustInsetBasedOnKeyboardHeight = viewModel.dependency.adjustsContentWithKeyboard
        _ = viewModel.dependency.isFirstResponder ? textView.becomeFirstResponder() : false
        textView.hostingViewController = viewModel.dependency.parentViewController
        textView.imageDelegate = viewModel.dependency.parentViewController
    }
    
    /// Use only for title cell
    static func calculateHeight(with viewModel: NoteDetailsCellViewModelable, width: CGFloat) -> CGFloat {
        guard viewModel.dependency.isFirstResponder else {
            var details = String()
            var attributes = [NSAttributedString.Key: Any]()
            attributes[.font] = Style.textViewFont
            if let attributedText = viewModel.dependency.attributedText {
                details = attributedText.string
                attributes = details.isEmpty
                    ? attributes
                    : attributedText.attributes(at: 0, effectiveRange: nil)
            } else if let text = viewModel.dependency.text {
                details = text
            }
            return Style.textViewBottomInset + details.calculate(
                .height(constrainedWidth: width),
                with: attributes
            )
        }
        return UITableView.automaticDimension
    }
    
}

// MARK: - Private Helpers
private extension NoteDetailsTableViewCell {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        selectionStyle = .none
        addTextView()
    }
    
    func addTextView() {
        contentView.addSubview(textView)
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
