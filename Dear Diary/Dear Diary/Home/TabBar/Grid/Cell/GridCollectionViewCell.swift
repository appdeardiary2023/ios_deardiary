//
//  GridCollectionViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SDWebImage

final class GridCollectionViewCell: UICollectionViewCell,
                                    ViewLoadable {
    
    static let name = Constants.TabBar.Grid.gridCollectionViewCell
    static let identifier = Constants.TabBar.Grid.gridCollectionViewCell
    
    private struct Style {
        static let noteImageViewCornerRadius = Constants.Layout.cornerRadius
    }
    
    @IBOutlet private weak var noteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension GridCollectionViewCell {
    
    func configure(with imageUrl: URL) {
        noteImageView.sd_setImage(with: imageUrl)
    }
    
}

// MARK: - Private Helpers
private extension GridCollectionViewCell {
    
    func setup() {
        noteImageView.layer.cornerRadius = Style.noteImageViewCornerRadius
        noteImageView.contentMode = .scaleAspectFill
    }
    
}
