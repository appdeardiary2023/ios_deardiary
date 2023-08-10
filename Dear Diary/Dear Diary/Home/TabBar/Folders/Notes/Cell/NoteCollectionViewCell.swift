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
import SDWebImage

final class NoteCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = Constants.TabBar.Notes.noteCollectionViewCell
    
    private struct Style {
        static func getBackgroundColor(with traitCollection: UITraitCollection) -> UIColor {
            return Color.secondaryBackground.shade.resolvedColor(with: traitCollection)
        }
        static let cornerRadius = Constants.Layout.cornerRadius
        
        static let stackViewSpacing: CGFloat = 20
        static let stackViewVerticalInset: CGFloat = 20
        static let stackViewHorizontalInset: CGFloat = 20
        
        static let attachmentImageViewWidthMultiplier: CGFloat = 0.5
        static let attachmentImageViewCornerRadius: CGFloat = 4
        
        static func getTextLabelTextColor(with traitCollection: UITraitCollection) -> UIColor {
            return Color.label.shade.resolvedColor(with: traitCollection)
        }
        static let textLabelFont = Font.title3(.regular)
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [attachmentImageView, textLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = Style.stackViewSpacing
        return view
    }()
    
    private lazy var attachmentImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = Style.attachmentImageViewCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
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
        attachmentImageView.sd_setImage(with: viewModel.imageUrl)
        attachmentImageView.isHidden = viewModel.imageUrl == nil
        textLabel.textColor = viewModel.isInverted
            ? Style.getTextLabelTextColor(with: invertedTraitCollection)
            : Style.getTextLabelTextColor(with: traitCollection)
        textLabel.text = viewModel.text
        textLabel.isHidden = viewModel.text == nil
    }
    
}

// MARK: - Private Helpers
private extension NoteCollectionViewCell {
    
    func setup() {
        layer.cornerRadius = Style.cornerRadius
        addStackView()
        setupAttachmentImageView()
        addLongPressGesture()
    }
    
    func addStackView() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Style.stackViewVerticalInset)
            $0.bottom.lessThanOrEqualToSuperview().inset(Style.stackViewVerticalInset)
            $0.leading.trailing.equalToSuperview().inset(Style.stackViewHorizontalInset)
        }
    }
    
    func setupAttachmentImageView() {
        attachmentImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(Style.attachmentImageViewWidthMultiplier)
            $0.height.equalTo(attachmentImageView.snp.width)
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
