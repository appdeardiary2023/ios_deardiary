//
//  DateCellViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 01/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation
import JTAppleCalendar

protocol DateCellViewModelable {
    var state: CellState { get }
    var isToday: Bool { get }
}

final class DateCellViewModel: DateCellViewModelable {
    
    let state: CellState
    
    init(state: CellState) {
        self.state = state
    }
    
}

// MARK: - Exposed Helpers
extension DateCellViewModel {
    
    var isToday: Bool {
        return Calendar.current.compare(state.date, to: Date(), toGranularity: .day) == .orderedSame
    }
    
}
