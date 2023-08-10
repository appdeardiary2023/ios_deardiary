//
//  NoteImageTableViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 09/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SDWebImage

final class NoteImageTableViewCell: UITableViewCell,
                                    ViewLoadable {
    
    static let name = Constants.Note.noteImageTableViewCell
    static let identifier = Constants.Note.noteImageTableViewCell
    
    private struct Style {
        static let backgroundColor = UIColor.clear
        
        static let noteImageViewCornerRadius: CGFloat = 8
        
        static let deleteButtonBackgroundColor = Color.primary.shade
        static let deleteButtonImageSize = CGSize(width: 24, height: 24)
    }
    
    @IBOutlet private weak var noteImageView: UIImageView!
    @IBOutlet private weak var deleteButton: UIButton!
    
    private var viewModel: NoteImageCellViewModelable?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension NoteImageTableViewCell {
    
    func configure(with viewModel: NoteImageCellViewModelable) {
        self.viewModel = viewModel
        noteImageView.sd_setImage(with: viewModel.imageUrl)
        deleteButton.setImage(
            viewModel.deleteButtonImage?.resize(to: Style.deleteButtonImageSize)?
                .withTintColor(Color.white.shade),
            for: .normal
        )
    }
    
}

// MARK: - Private Helpers
private extension NoteImageTableViewCell {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        selectionStyle = .none
        setupNoteImageView()
        setupDeleteButton()
    }
    
    func setupNoteImageView() {
        noteImageView.layer.cornerRadius = Style.noteImageViewCornerRadius
    }
    
    func setupDeleteButton() {
        deleteButton.backgroundColor = Style.deleteButtonBackgroundColor
        deleteButton.setTitle(nil, for: .normal)
        deleteButton.layer.cornerRadius = min(
            deleteButton.bounds.width,
            deleteButton.bounds.height
        ) / 2
    }
    
    @IBAction func deleteButtonTapped() {
        viewModel?.deleteButtonTapped()
    }
    
}
