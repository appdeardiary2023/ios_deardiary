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
        static let signInViewController = String(describing: SignInViewController.self)
        static let signUpViewController = String(describing: SignUpViewController.self)
    }
    
}
