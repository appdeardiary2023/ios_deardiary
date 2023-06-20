//
//  SignInViewModel.swift
//  Dear Diary
//
//  Created by Hitesh Moudgil on 2023-06-15.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages

protocol SignInViewModelable {
    var welcomeBackLabelText: String { get }
    var welcomeInfoText: String {get}
    var fields: [SignInViewModel.Field] { get }
    var eyeButtonImage: UIImage? { get }
}

final class SignInViewModel: SignInViewModelable {
    
    enum Field: CaseIterable {
        case email
        case password
    }
    
    let fields: [Field]
    
    init() {
        self.fields = Field.allCases
    }
    
}

extension SignInViewModel {
    
    var welcomeBackLabelText: String {
        return Strings.Registration.welcomeBack
    }
    
    var welcomeInfoText: String {
        return Strings.Registration.welcomeInfo
    }
    
    var eyeButtonImage: UIImage? {
        return Image.eyeOpened.asset
    }
}

extension SignInViewModel.Field {
    
    var placeholder: String {
        switch self {
        case .email:
            return Strings.Registration.emailAddress
        case .password:
            return Strings.Registration.password
        }
    }
    
    var isPasswordProtected: Bool{
//        if(self == .password){
//            return true
//        }
//        return false
//        return self == .password
        switch self {
        case .email:
            return false
        case .password:
            return true
        }
    }
    
    var isFirstResponder: Bool {
        switch self {
        case .email:
            return true
        case .password:
            return false
        }
    }
    
}
