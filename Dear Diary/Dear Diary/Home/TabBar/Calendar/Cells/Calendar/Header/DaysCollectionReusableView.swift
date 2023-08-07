//
//  DaysCollectionReusableView.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 02/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import JTAppleCalendar

final class DaysCollectionReusableView: JTAppleCollectionReusableView,
                                        ViewLoadable {
    
    static let name = Constants.TabBar.Calendar.daysCollectionReusableView
    static let identifier = Constants.TabBar.Calendar.daysCollectionReusableView
    
    private struct Style {
        static let dayLabelTextColor = Color.label.shade
        static let dayLabelFont = Font.callout(.semibold)
    }
    
    @IBOutlet private var dayLabels: [UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}

// MARK: - Exposed Helpers
extension DaysCollectionReusableView {
    
    func configure(with days: [String]) {
        dayLabels.enumerated().forEach { (index, label) in
            label.text = days[safe: index]
        }
    }
    
}

// MARK: - Private Helpers
private extension DaysCollectionReusableView {
    
    func setup() {
        setupDayLabels()
    }
    
    func setupDayLabels() {
        dayLabels.forEach { label in
            label.textColor = Style.dayLabelTextColor
            label.font = Style.dayLabelFont
            label.textAlignment = .center
        }
    }
    
}
