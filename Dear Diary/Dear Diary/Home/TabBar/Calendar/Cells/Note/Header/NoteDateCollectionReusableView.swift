//
//  NoteDateCollectionReusableView.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 06/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class NoteDateCollectionReusableView: UICollectionReusableView,
                                            ViewLoadable {
    
    static let name = Constants.TabBar.Calendar.noteDateCollectionReusableView
    static let identifier = Constants.TabBar.Calendar.noteDateCollectionReusableView
        
    private struct Style {
        static let separatorViewBackgroundColor = Color.secondaryBackground.shade
        static let separatorViewBottomInset: CGFloat = 20
        static let separatorViewHeight: CGFloat = 2
        
        static let titleLabelTextColor = Color.label.shade
        static let titleLabelFont = Font.title2(.semibold)
        static let titleLabelTopInset: CGFloat = 20
        static let titleLabelBottomInset: CGFloat = 20
        static let titleLabelHorizontalInset: CGFloat = 40
    }
    
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}

// MARK: - Exposed Helpers
extension NoteDateCollectionReusableView {
    
    func configure(with viewModel: NoteDateHeaderViewModelable) {
        let title = viewModel.title
        titleLabel.text = title
        titleLabel.isHidden = title == nil
    }
    
    static func calculateHeight(with viewModel: NoteDateHeaderViewModelable, width: CGFloat) -> CGFloat {
        guard let title = viewModel.title else {
            return Style.separatorViewHeight + Style.separatorViewBottomInset
        }
        let verticalSpacing = Style.titleLabelTopInset + Style.titleLabelBottomInset
        let availabeWidth = width - 2 * Style.titleLabelHorizontalInset
        let titleLabelHeight = title.calculate(
            .height(constrainedWidth: availabeWidth),
            with: Style.titleLabelFont
        )
        return verticalSpacing
            + Style.separatorViewHeight
            + titleLabelHeight
    }
    
}

// MARK: - Private Helpers
private extension NoteDateCollectionReusableView {
    
    func setup() {
        setupSeparatorView()
        setupTitleLabel()
    }
    
    func setupSeparatorView() {
        separatorView.backgroundColor = Style.separatorViewBackgroundColor
        separatorView.layer.cornerRadius = Style.separatorViewHeight / 2
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
    }
    
}
