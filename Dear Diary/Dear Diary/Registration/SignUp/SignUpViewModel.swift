//
//  SignUpViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings

protocol SignUpViewModelable {
    var createAccountLabelText: String { get }
    var fillDetailsLabelText: String { get }
    var eyeButtonImage: UIImage? { get }
    var fields: [SignUpViewModel.Field] { get }
    func signUpButtonTapped()
}

final class SignUpViewModel: SignUpViewModelable {
    
    enum Field: CaseIterable {
        case name
        case email
        case password
        case confirmPassword
    }
    
}

// MARK: - Exposed Helpers
extension SignUpViewModel {
    
    var createAccountLabelText: String {
        return Strings.Registration.createNewAccount
    }
    
    var fillDetailsLabelText: String {
        return Strings.Registration.fillDetails
    }
    
    var eyeButtonImage: UIImage? {
        return UIImage(named: "eye.opened")
    }
    
    var fields: [Field] {
        return Field.allCases
    }
    
    func signUpButtonTapped() {
        // Perform validation for all text fields
        
    }
    
}

// MARK: - SignUpViewModel.Field Helpers
extension SignUpViewModel.Field {
    
    var placeholder: String {
        switch self {
        case .name:
            return Strings.Registration.fullName
        case .email:
            return Strings.Registration.emailAddress
        case .password:
            return Strings.Registration.password
        case .confirmPassword:
            return Strings.Registration.confirmPassword
        }
    }
    
    var isPasswordProtected: Bool {
        switch self {
        case .name, .email:
            return false
        case .password, .confirmPassword:
            return true
        }
    }
    
    var isFirstResponder: Bool {
        switch self {
        case .name:
            return true
        case .email, .password, .confirmPassword:
            return false
        }
    }
    
}
