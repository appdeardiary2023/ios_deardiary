//
//  CalendarViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages
import JTAppleCalendar

protocol CalendarViewModelPresenter: AnyObject {
    func updateMonthButton()
    func updateYearButton()
    func reloadItem(_ cell: JTAppleCell?, with state: CellState)
    func reload()
}

protocol CalendarViewModelable {
    var monthMenu: UIMenu? { get }
    var yearMenu: UIMenu? { get }
    var monthButtonTitle: String { get }
    var yearButtonTitle: String { get }
    var downwardArrowImage: UIImage? { get }
    var calendarParameters: ConfigurationParameters { get }
    var presenter: CalendarViewModelPresenter? { get set }
    func getHeaderDays() -> [String]
    func getCellViewModel(with state: CellState) -> DateCellViewModelable
    func willDisplayDate(_ cell: JTAppleCell?, state: CellState)
    func didSelectDate(_ cell: JTAppleCell?, state: CellState)
    func didDeselectDate(_ cell: JTAppleCell?, state: CellState)
}

final class CalendarViewModel: CalendarViewModelable {
    
    weak var presenter: CalendarViewModelPresenter?
    
    private var selectedMonth: MonthsOfYear
    private var selectedYear: Int
    private var selectedDates: [Date]
    
    init() {
        self.selectedMonth = MonthsOfYear(
            rawValue: Calendar.current.component(.month, from: Date())
        ) ?? .jan
        self.selectedYear = Calendar.current.component(.year, from: Date())
        self.selectedDates = []
    }
    
}

// MARK: - Exposed Helpers
extension CalendarViewModel {
    
    var monthMenu: UIMenu? {
        var yearMonths: [MonthsOfYear] = [.jan, .feb, .mar, .apr, .may, .jun, .jul, .aug, .sep, .oct, .nov, .dec]
        // Show only those months which have passed in the current year
        let currentYear = Calendar.current.component(.year, from: Date())
        if currentYear == selectedYear {
            yearMonths = yearMonths.filter { month in
                let endMonth = Calendar.current.component(.month, from: Date())
                return endMonth >= month.rawValue
            }
        }
        let actions = yearMonths.map { month in
            return UIAction(title: month.title) { [weak self] _ in
                self?.updateMonth(with: month)
            }
        }
        return UIMenu(children: actions)
    }
    
    var yearMenu: UIMenu? {
        let startYear = Calendar.current.component(.year, from: Constants.TabBar.Calendar.startDate)
        var endYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        // Check if the selected month has passed in the selected year
        if currentMonth < selectedMonth.rawValue {
            endYear -= 1
        }
        let actions = (startYear...endYear).map { year in
            return UIAction(title: String(year)) { [weak self] _ in
                self?.updateYear(with: year)
            }
        }
        return UIMenu(children: actions)
    }
    
    var monthButtonTitle: String {
        return selectedMonth.title
    }
    
    var yearButtonTitle: String {
        return String(selectedYear)
    }
    
    var downwardArrowImage: UIImage? {
        return Image.downArrow.asset
    }
    
    var calendarParameters: ConfigurationParameters {
        let startComponents = DateComponents(year: selectedYear, month: selectedMonth.rawValue)
        let startDate = Calendar.current.date(from: startComponents)
        let nextComponents = DateComponents(
            year: getNextYear(for: selectedMonth),
            month: selectedMonth.nextValue
        )
        let nextMonthDate = Calendar.current.date(from: nextComponents) ?? Date()
        let endDate = Calendar.current.date(byAdding: .day, value: -1, to: nextMonthDate)
        return ConfigurationParameters(
            startDate: startDate ?? Date(),
            endDate: endDate ?? Date(),
            firstDayOfWeek: .monday
        )
    }
    
    func getHeaderDays() -> [String] {
        let weekDays: [DaysOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        // Only need the first two letters of the day
        return weekDays.map { String($0.title.prefix(2)) }
    }
    
    func getCellViewModel(with state: CellState) -> DateCellViewModelable {
        return DateCellViewModel(state: state)
    }
    
    func willDisplayDate(_ cell: JTAppleCell?, state: CellState) {
        presenter?.reloadItem(cell, with: state)
    }
    
    func didSelectDate(_ cell: JTAppleCell?, state: CellState) {
        selectedDates.append(state.date)
        presenter?.reloadItem(cell, with: state)
    }
    
    func didDeselectDate(_ cell: JTAppleCell?, state: CellState) {
        selectedDates.removeAll(where: { $0 == state.date })
        presenter?.reloadItem(cell, with: state)
    }
    
}

// MARK: - Private Helpers
private extension CalendarViewModel {
    
    func updateMonth(with month: MonthsOfYear) {
        guard month != selectedMonth else { return }
        selectedMonth = month
        presenter?.updateMonthButton()
        presenter?.updateYearButton()
        presenter?.reload()
    }
    
    func updateYear(with year: Int) {
        guard year != selectedYear else { return }
        selectedYear = year
        presenter?.updateMonthButton()
        presenter?.updateYearButton()
        presenter?.reload()
    }
    
    func getNextYear(for month: MonthsOfYear) -> Int {
        switch month {
        case .jan, .feb, .mar, .apr, .may, .jun, .jul, .aug, .sep, .oct, .nov:
            return selectedYear
        case .dec:
            return selectedYear + 1
        }
    }
    
}

// MARK: - DateOwner Helpers
extension DateOwner {
    
    var isSelectionAllowed: Bool {
        switch self {
        case .thisMonth:
            return true
        case .previousMonthWithinBoundary, .previousMonthOutsideBoundary, .followingMonthWithinBoundary, .followingMonthOutsideBoundary:
            return false
        }
    }
    
}

// MARK: - DaysOfWeek Helpers
private extension DaysOfWeek {
    
    var title: String {
        switch self {
        case .sunday:
            return Strings.Calendar.sunday
        case .monday:
            return Strings.Calendar.monday
        case .tuesday:
            return Strings.Calendar.tuesday
        case .wednesday:
            return Strings.Calendar.wednesday
        case .thursday:
            return Strings.Calendar.thursday
        case .friday:
            return Strings.Calendar.friday
        case .saturday:
            return Strings.Calendar.saturday
        }
    }

}

// MARK: - MonthsOfYear Helpers
private extension MonthsOfYear {
    
    var nextValue: Int {
        switch self {
        case .jan, .feb, .mar, .apr, .may, .jun, .jul, .aug, .sep, .oct, .nov:
            return rawValue + 1
        case .dec:
            return MonthsOfYear.jan.rawValue
        }
    }
    
    var title: String {
        switch self {
        case .jan:
            return Strings.Calendar.january
        case .feb:
            return Strings.Calendar.february
        case .mar:
            return Strings.Calendar.march
        case .apr:
            return Strings.Calendar.april
        case .may:
            return Strings.Calendar.may
        case .jun:
            return Strings.Calendar.june
        case .jul:
            return Strings.Calendar.july
        case .aug:
            return Strings.Calendar.august
        case .sep:
            return Strings.Calendar.september
        case .oct:
            return Strings.Calendar.october
        case .nov:
            return Strings.Calendar.november
        case .dec:
            return Strings.Calendar.decemeber
        }
    }

}
