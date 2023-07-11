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
}

final class DateCellViewModel: DateCellViewModelable {
    
    let state: CellState
    
    init(state: CellState) {
        self.state = state
    }
    
}
