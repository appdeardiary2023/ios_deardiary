//
//  DateCollectionViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 01/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import JTAppleCalendar

final class DateCollectionViewCell: JTAppleCell,
                                    ViewLoadable {
    
    static let name = Constants.TabBar.Calendar.dateCollectionViewCell
    static let identifier = Constants.TabBar.Calendar.dateCollectionViewCell
    
    fileprivate struct Style {
        static let backgroundColor = UIColor.clear
        
        static let containerViewDefaultBackgroundColor = UIColor.clear
        static let containerViewTodayBackgroundColor = Color.secondaryBackground.shade
        
        static let dayLabelCurrentMonthTextColor = Color.label.shade
        static let dayLabelOutdatedTextColor = Color.tertiaryLabel.shade
        static let dayLabelFont = Font.subheadline(.regular)
        
        static let dotViewSelectedBackgroundColor = Color.primary.shade
        static let dotViewDeselectedBackgroundColor = UIColor.clear
    }
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dotView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
    
}

// MARK: - Exposed Helpers
extension DateCollectionViewCell {
    
    func configure(with viewModel: DateCellViewModelable) {
        containerView.backgroundColor = viewModel.isToday
            ? Style.containerViewTodayBackgroundColor
            : Style.containerViewDefaultBackgroundColor
        dayLabel.textColor = viewModel.state.dateBelongsTo.dayLabelTextColor
        dayLabel.text = viewModel.state.text
        let isSelected = viewModel.state.isSelected
        dotView.backgroundColor = isSelected
            ? Style.dotViewSelectedBackgroundColor
            : Style.dotViewDeselectedBackgroundColor
        dotView.isHidden = !isSelected
    }
    
}

// MARK: - Private Helpers
private extension DateCollectionViewCell {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        setupDayLabel()
    }
    
    func setupDayLabel() {
        dayLabel.font = Style.dayLabelFont
    }
    
    func setCornerRadius() {
        containerView.layer.cornerRadius = min(
            containerView.bounds.width,
            containerView.bounds.height
        ) / 2
        dotView.layer.cornerRadius = min(
            dotView.bounds.width,
            dotView.bounds.height
        ) / 2
    }
    
}

// MARK: - DateOwner Helpers
private extension DateOwner {
    
    var dayLabelTextColor: UIColor {
        switch self {
        case .thisMonth:
            return DateCollectionViewCell.Style.dayLabelCurrentMonthTextColor
        case .previousMonthWithinBoundary, .previousMonthOutsideBoundary, .followingMonthWithinBoundary, .followingMonthOutsideBoundary:
            return DateCollectionViewCell.Style.dayLabelOutdatedTextColor
        }
    }
    
}
