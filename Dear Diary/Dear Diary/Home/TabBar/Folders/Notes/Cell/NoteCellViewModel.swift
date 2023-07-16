//
//  NoteCellViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

protocol NoteCellViewModelable {
    var text: String { get }
    var isInverted: Bool { get }
}

final class NoteCellViewModel: NoteCellViewModelable {
    
    let text: String
    let isInverted: Bool
    
    init(text: String, isInverted: Bool) {
        self.text = text
        self.isInverted = isInverted
    }
    
}
