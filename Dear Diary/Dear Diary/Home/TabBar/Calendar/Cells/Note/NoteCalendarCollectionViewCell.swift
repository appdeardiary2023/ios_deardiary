//
//  NoteCalendarCollectionViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 10/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SnapKit
import SDWebImage

final class NoteCalendarCollectionViewCell: UICollectionViewCell,
                                            ViewLoadable {
    
    static let name = Constants.TabBar.Calendar.noteCalendarCollectionViewCell
    static let identifier = Constants.TabBar.Calendar.noteCalendarCollectionViewCell
    
    private struct Style {
        static var backgroundColor = Color.secondaryBackground.shade
        static let cornerRadius = Constants.Layout.cornerRadius
        
        static let attachmentImageViewCornerRadius: CGFloat = 4
        
        static var textLabelTextColor = Color.label.shade
        static let textLabelFont = Font.title3(.regular)
    }
    
    @IBOutlet private weak var attachmentImageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    private var viewModel: NoteCellViewModelable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}

// MARK: - Exposed Helpers
extension NoteCalendarCollectionViewCell {
    
    func configure(with viewModel: NoteCellViewModelable) {
        self.viewModel = viewModel
        attachmentImageView.sd_setImage(with: viewModel.imageUrl)
        attachmentImageView.isHidden = viewModel.imageUrl == nil
        textLabel.text = viewModel.text
        textLabel.isHidden = viewModel.text == nil
    }
    
}

// MARK: - Private Helpers
private extension NoteCalendarCollectionViewCell {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        layer.cornerRadius = Style.cornerRadius
        setupTextLabel()
        setupAttachmentImageView()
        addLongPressGesture()
    }
    
    func setupTextLabel() {
        textLabel.textColor = Style.textLabelTextColor
        textLabel.font = Style.textLabelFont
    }
    
    func setupAttachmentImageView() {
        attachmentImageView.layer.cornerRadius = Style.attachmentImageViewCornerRadius
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
