//
//  SignInViewModel.swift
//  Dear Diary
//
//  Created by Hitesh Moudgil on 2023-06-15.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

protocol SignInViewModelable {
    var welcomeBackLabelText: String { get }
}

final class SignInViewModel: SignInViewModelable {
        
}

extension SignInViewModel {
    
    var welcomeBackLabelText: String {
        return "Welcome Back!"
    }
    
}
