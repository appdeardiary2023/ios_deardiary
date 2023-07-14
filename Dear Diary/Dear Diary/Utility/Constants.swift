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
    }
    
    struct Registration {
        static let storyboardName = String(describing: Registration.self)
        static let registerViewController = String(describing: RegisterViewController.self)
        static let otpViewController = String(describing: OTPViewController.self)
    }
    
    struct TabBar {
        static let storyboardName = String(describing: TabBar.self)
        static let foldersViewController = String(describing: FoldersViewController.self)
        static let calendarViewController = String(describing: CalendarViewController.self)
        static let dateCollectionViewCell = String(describing: DateCollectionViewCell.self)
        static let daysCollectionReusableView = String(describing: DaysCollectionReusableView.self)
        static let settingsViewController = String(describing: SettingsViewController.self)
        static let themeTableViewCell = String(describing: ThemeTableViewCell.self)
    }
    
    struct Calendar {
        static let startDate = Date(timeIntervalSince1970: 1641032613) // First january of 2022: https://www.epochconverter.com/
    }
    
}
