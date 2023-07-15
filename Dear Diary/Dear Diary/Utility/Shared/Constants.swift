//
//  Constants.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 11/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Layout {
        static let cornerRadius: CGFloat = 16
    }
    
    struct Animation {
        static let defaultDuration: TimeInterval = 0.3
        static let longDuration: TimeInterval = 1
    }
    
    struct Registration {
        static let storyboardName = String(describing: Registration.self)
        static let registerViewController = String(describing: RegisterViewController.self)
        static let otpViewController = String(describing: OtpViewController.self)
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    struct TabBar {
        static let storyboardName = String(describing: TabBar.self)
        static let foldersViewController = String(describing: FoldersViewController.self)
        static let calendarViewController = String(describing: CalendarViewController.self)
        static let dateCollectionViewCell = String(describing: DateCollectionViewCell.self)
        static let daysCollectionReusableView = String(describing: DaysCollectionReusableView.self)
    }
    
    struct Calendar {
        static let startDate = Date(timeIntervalSince1970: 1641032613) // First january of 2022: https://www.epochconverter.com/
    }
    
    struct Mock {
        static let user = "UserMockData"
        static let otp = "OtpMockData"
    }
    
}
