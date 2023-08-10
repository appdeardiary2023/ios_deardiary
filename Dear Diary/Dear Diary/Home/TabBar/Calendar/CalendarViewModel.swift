//
//  CalendarViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import JTAppleCalendar

protocol CalendarViewModelListener: AnyObject {
    func noteSelected(_ note: NoteModel, listener: NoteViewModelListener?)
}

protocol CalendarViewModelPresenter: AnyObject {
    func deleteSections(_ sections: IndexSet)
    func reloadSections(_ sections: IndexSet)
    func updateSections(inserting newSections: IndexSet, reloading oldSections: IndexSet?)
}

protocol CalendarViewModelable: ViewLifecyclable {
    var sections: [CalendarViewModel.Section] { get }
    var numberOfSections: Int { get }
    var presenter: CalendarViewModelPresenter? { get set }
    func getNumberOfItems(in section: Int) -> Int
    func getCalendarCellViewModel(at indexPath: IndexPath) -> CalendarCellViewModelable?
    func getNotesHeaderViewModel(in section: Int) -> NoteDateHeaderViewModelable?
    func getNoteCellViewModel(at indexPath: IndexPath) -> NoteCellViewModelable?
    func didSelectItem(at indexPath: IndexPath)
}

final class CalendarViewModel: CalendarViewModelable {
    
    enum Section: Int, CaseIterable {
        case calendar
    }
    
    weak var presenter: CalendarViewModelPresenter?
    
    private(set) var sections: [Section]
    
    private var selectedMonth: MonthsOfYear
    private var selectedYear: Int
    /// Mapped notes to their corresponding creation date
    private var notesDict: [Date: [NoteModel]]
    private weak var listener: CalendarViewModelListener?
    
    init(listener: CalendarViewModelListener?) {
        self.sections = Section.allCases
        self.selectedMonth = MonthsOfYear(
            rawValue: Calendar.current.component(.month, from: Date())
        ) ?? .jan
        self.selectedYear = Calendar.current.component(.year, from: Date())
        self.notesDict = [:]
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension CalendarViewModel {
    
    var numberOfSections: Int {
        // Calendar and as many different dates are selected
        return 1 + notesDict.keys.count
    }
    
    func getNumberOfItems(in section: Int) -> Int {
        guard sections[safe: section] == nil else { return 1 }
        // Note sections are dynamic and can't be declared in an enum
        return getNotes(in: section).count
    }
    
    func getCalendarCellViewModel(at indexPath: IndexPath) -> CalendarCellViewModelable? {
        return CalendarCellViewModel(
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            listener: self
        )
    }
    
    func getNotesHeaderViewModel(in section: Int) -> NoteDateHeaderViewModelable? {
        let notes = getNotes(in: section)
        // All notes will fall under the same day
        let creationTime = notesDict.keys.count > 1 ? notes.first?.creationTime : nil
        return NoteDateHeaderViewModel(creationTime: creationTime)
    }
    
    func getNoteCellViewModel(at indexPath: IndexPath) -> NoteCellViewModelable? {
        let notes = getNotes(in: indexPath.section)
        guard let note = notes[safe: indexPath.item] else { return nil }
        return NoteCellViewModel(flow: .calendar, note: note, listener: nil)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard sections[safe: indexPath.section] == nil else { return }
        // Act on selection only for notes
        let notes = getNotes(in: indexPath.section)
        guard let note = notes[safe: indexPath.item] else { return }
        listener?.noteSelected(note, listener: self)
    }

}

// MARK: - Private Helpers
private extension CalendarViewModel {
    
    var existingNotes: [NoteModel] {
        // Fetch notes inside all folders
        let folderIds = UserDefaults.folderData.models.map { $0.id }
        let notesData = folderIds.map { UserDefaults.fetchNoteData(for: $0) }
        return Array(notesData.map { $0.models }.joined())
    }
    
    func getNotes(in section: Int) -> [NoteModel] {
        let sortedDates = notesDict.keys.sorted()
        let sectionDate = sortedDates[sortedDates.count - section]
        return notesDict[sectionDate] ?? []
    }
    
    func getSection(from date: Date) -> Int? {
        let sortedDates = notesDict.keys.sorted()
        guard let index = sortedDates.firstIndex(of: date) else { return nil }
        return sortedDates.count - (index + 1) + 1 // To take into account calendar section
    }
    
    func resetCalendar() {
        let sections = IndexSet(integer: Section.calendar.rawValue)
        presenter?.reloadSections(sections)
    }
    
}

// MARK: - CalendarCellViewModelListener Methods
extension CalendarViewModel: CalendarCellViewModelListener {
    
    func monthSelected(_ month: JTAppleCalendar.MonthsOfYear) {
        guard month != selectedMonth else { return }
        selectedMonth = month
        resetCalendar()
    }
    
    func yearSelected(_ year: Int) {
        guard year != selectedYear else { return }
        selectedYear = year
        resetCalendar()
    }
    
    func dateSelected(_ date: Date) {
        let notes = existingNotes.filter {
            let createdDate = Date(timeIntervalSince1970: $0.creationTime)
            return Calendar.current.compare(createdDate, to: date, toGranularity: .day) == .orderedSame
        }
        guard !notes.isEmpty else { return }
        notesDict[date] = notes
        guard let section = getSection(from: date) else { return }
        let newSections = IndexSet(integer: section)
        let oldSectionIndices = (1...notesDict.keys.count).filter { $0 != section }
        let oldSections = notesDict.keys.count > 1
            ? IndexSet(oldSectionIndices)
            : nil
        presenter?.updateSections(inserting: newSections, reloading: oldSections)
    }
    
    func dateDeselected(_ date: Date) {
        guard let section = getSection(from: date) else { return }
        notesDict.removeValue(forKey: date)
        presenter?.deleteSections(IndexSet(integer: section))
    }
    
}

// MARK: - NoteViewModelListener Methods
extension CalendarViewModel: NoteViewModelListener {
    
    func noteAdded(_ note: NoteModel, needsDataSourceUpdate: Bool) {}
    
    func noteEdited(replacing note: NoteModel, with editedNote: NoteModel?, needsDataSourceUpdate: Bool) {
        // TODO
    }
    
    func deleteNote(_ note: NoteModel, needsDataSourceUpdate: Bool) {
        // TODO
    }
    
}
