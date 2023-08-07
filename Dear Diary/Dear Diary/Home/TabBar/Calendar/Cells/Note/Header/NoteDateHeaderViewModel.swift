//
//  NoteDateHeaderViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 06/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

protocol NoteDateHeaderViewModelable {
    var title: String? { get }
}

final class NoteDateHeaderViewModel: NoteDateHeaderViewModelable {
    
    private let creationTime: TimeInterval?
        
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Note.dateFormat
        return formatter
    }()
    
    init(creationTime: TimeInterval?) {
        self.creationTime = creationTime
    }
    
}

// MARK: - Exposed Helpers
extension NoteDateHeaderViewModel {
    
    var title: String? {
        guard let creationTime = creationTime else { return nil }
        let date = Date(timeIntervalSince1970: creationTime)
        return dateFormatter.string(from: date)
    }
    
}
