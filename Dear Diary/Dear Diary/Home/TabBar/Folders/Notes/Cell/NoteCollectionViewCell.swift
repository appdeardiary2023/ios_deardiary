//
//  NoteCollectionViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SnapKit

final class NoteCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = Constants.TabBar.Notes.noteCollectionViewCell
    
    private struct Style {
        static func getBackgroundColor(with traitCollection: UITraitCollection) -> UIColor {
            return Color.secondaryBackground.shade.resolvedColor(with: traitCollection)
        }
        static let cornerRadius = Constants.Layout.cornerRadius
        
        static func getTextLabelTextColor(with traitCollection: UITraitCollection) -> UIColor {
            return Color.label.shade.resolvedColor(with: traitCollection)
        }
        static let textLabelFont = Font.title3(.regular)
        static let textLabelVerticalInset: CGFloat = 20
        static let textLabelHorizontalInset: CGFloat = 20
    }
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Style.textLabelFont
        label.numberOfLines = .zero
        return label
    }()
    
    private var viewModel: NoteCellViewModelable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Exposed Helpers
extension NoteCollectionViewCell {
    
    func configure(with viewModel: NoteCellViewModelable) {
        self.viewModel = viewModel
        let invertedTraitCollection: UITraitCollection
        switch traitCollection.userInterfaceStyle {
        case .dark:
            invertedTraitCollection = UITraitCollection(userInterfaceStyle: .light)
        default:
            invertedTraitCollection = UITraitCollection(userInterfaceStyle: .dark)
        }
        backgroundColor = viewModel.isInverted
            ? Style.getBackgroundColor(with: invertedTraitCollection)
            : Style.getBackgroundColor(with: traitCollection)
        textLabel.textColor = viewModel.isInverted
            ? Style.getTextLabelTextColor(with: invertedTraitCollection)
            : Style.getTextLabelTextColor(with: traitCollection)
        textLabel.text = viewModel.text
    }
    
}

// MARK: - Private Helpers
private extension NoteCollectionViewCell {
    
    func setup() {
        layer.cornerRadius = Style.cornerRadius
        addTextLabel()
        addLongPressGesture()
    }
    
    func addTextLabel() {
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Style.textLabelVerticalInset)
            $0.bottom.lessThanOrEqualToSuperview().inset(Style.textLabelVerticalInset)
            $0.leading.trailing.equalToSuperview().inset(Style.textLabelHorizontalInset)
        }
    }
    
    func addLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(longPressRecognized(_:))
        )
        addGestureRecognizer(longPressGesture)
    }
    
    @objc
    func longPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
        viewModel?.longPressRecognized(recognizer)
    }
    
}
