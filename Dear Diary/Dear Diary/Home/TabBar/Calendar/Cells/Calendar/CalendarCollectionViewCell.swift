//
//  CalendarCollectionViewCell.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 05/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import JTAppleCalendar

final class CalendarCollectionViewCell: UICollectionViewCell,
                                        ViewLoadable {
    
    static let name = Constants.TabBar.Calendar.calendarCollectionViewCell
    static let identifier = Constants.TabBar.Calendar.calendarCollectionViewCell
    
    private struct Style {
        static let backgroundColor = UIColor.clear
        
        static let buttonBackgroundColor = Color.secondaryBackground.shade
        static let buttonTitleColor = Color.label.shade
        static let buttonImageTintColor = Color.primary.shade
        static let buttonFont = Font.headline(.semibold)
        static let buttonContentSpacing: CGFloat = 4
        static let buttonContentEdgeInsets = UIEdgeInsets(
            top: 10,
            left: 20,
            bottom: 10,
            right: 20
        )
        static let buttonCornerRadius = Constants.Layout.cornerRadius
        static let buttonsStackViewTopInset: CGFloat = 30
        
        static let calendarViewBackgroundColor = UIColor.clear
        static let calendarHeaderViewSize: CGFloat = 44
        static let calendarViewTopInset: CGFloat = 15
        static let calendarViewHeight: CGFloat = 240
    }
    
    @IBOutlet private weak var monthButton: UIButton!
    @IBOutlet private weak var yearButton: UIButton!
    @IBOutlet private weak var calendarView: JTAppleCalendarView!
    
    private var viewModel: CalendarCellViewModelable?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension CalendarCollectionViewCell {
    
    func configure(with viewModel: CalendarCellViewModelable) {
        self.viewModel = viewModel
        // Month button
        monthButton.setTitle(viewModel.monthButtonTitle, for: .normal)
        monthButton.menu = viewModel.monthMenu
        // Year button
        yearButton.setTitle(viewModel.yearButtonTitle, for: .normal)
        yearButton.menu = viewModel.yearMenu
        [monthButton, yearButton].forEach { button in
            button.setImage(
                viewModel.downwardArrowImage?
                    .withTintColor(Style.buttonImageTintColor),
                for: .normal
            )
        }
        calendarView.reloadData()
    }
    
    static func calculateHeight(with viewModel: CalendarCellViewModelable) -> CGFloat {
        let verticalSpacing = Style.buttonsStackViewTopInset + Style.calendarViewTopInset
        let buttonsStackViewHeight = viewModel.monthButtonTitle.calculate(
            .height(constrainedWidth: .greatestFiniteMagnitude),
            with: Style.buttonFont
        ) + (Style.buttonContentEdgeInsets.top + Style.buttonContentEdgeInsets.bottom)
        return verticalSpacing
            + buttonsStackViewHeight
            + Style.calendarViewHeight
    }
    
}

// MARK: - Private Helpers
private extension CalendarCollectionViewCell {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        setupButtons()
        setupCalendarView()
    }
    
    func setupButtons() {
        [monthButton, yearButton].forEach { button in
            button.backgroundColor = Style.buttonBackgroundColor
            button.setTitleColor(Style.buttonTitleColor, for: .normal)
            button.titleLabel?.font = Style.buttonFont
            button.setContentSpacing(
                Style.buttonContentSpacing,
                edgeInsets: Style.buttonContentEdgeInsets,
                isLTR: false
            )
            button.layer.cornerRadius = Style.buttonCornerRadius
            button.semanticContentAttribute = .forceRightToLeft
            button.showsMenuAsPrimaryAction = true
        }
    }
    
    func setupCalendarView() {
        calendarView.backgroundColor = Style.calendarViewBackgroundColor
        calendarView.scrollDirection = .horizontal
        calendarView.allowsMultipleSelection = true
        calendarView.showsHorizontalScrollIndicator = false
        DaysCollectionReusableView.register(for: calendarView)
        DateCollectionViewCell.register(for: calendarView)
    }
    
}

// MARK: - JTAppleCalendarViewDelegate Methods
extension CalendarCollectionViewCell: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        guard let days = viewModel?.getHeaderDays() else { return JTAppleCollectionReusableView() }
        let headerView = DaysCollectionReusableView.deque(
            from: calendar,
            at: indexPath
        )
        headerView.configure(with: days)
        return headerView
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: Style.calendarHeaderViewSize)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        viewModel?.willDisplayDate(cell, state: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cellViewModel = viewModel?.getCellViewModel(with: cellState) else { return JTAppleCell() }
        let dateCell = DateCollectionViewCell.deque(from: calendar, at: indexPath)
        dateCell.configure(with: cellViewModel)
        return dateCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        viewModel?.didSelectDate(cell, state: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        viewModel?.didDeselectDate(cell, state: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return cellState.dateBelongsTo.isSelectionAllowed
    }
    
}

// MARK: - JTAppleCalendarViewDataSource Methods
extension CalendarCollectionViewCell: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let currentDate = Date()
        return viewModel?.calendarParameters ?? ConfigurationParameters(
            startDate: currentDate,
            endDate: currentDate
        )
    }
    
}

// MARK: - CalendarCellViewModelPresenter Methods
extension CalendarCollectionViewCell: CalendarCellViewModelPresenter {
    
    func reloadDate(_ cell: JTAppleCell?, with state: CellState) {
        guard let dateCell = cell as? DateCollectionViewCell,
              let cellViewModel = viewModel?.getCellViewModel(with: state) else { return }
        dateCell.configure(with: cellViewModel)
    }
    
    func reload() {
        calendarView.reloadData()
    }
    
}
