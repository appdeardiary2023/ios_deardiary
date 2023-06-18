//
//  SignUpViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings

protocol SignUpViewModelPresenter: AnyObject {
    func updateCreateAccountStackView(isHidden: Bool)
    func push(_ viewController: UIViewController)
}

protocol SignUpViewModelable {
    var createAccountLabelText: String { get }
    var fillDetailsLabelText: String { get }
    var eyeButtonImage: UIImage? { get }
    var fields: [SignUpViewModel.Field] { get }
    var signUpButtonTitle: String { get }
    var signInTextViewStaticText: String { get }
    var signInTextViewLinkText: String { get }
    var signInTextViewUrl: URL? { get }
    var presenter: SignUpViewModelPresenter? { get set }
    func keyboardDidShow()
    func keyboardDidHide()
    func signUpButtonTapped()
    func signInLinkTapped() -> Bool
}

final class SignUpViewModel: SignUpViewModelable {
    
    enum Field: CaseIterable {
        case name
        case email
        case password
        case confirmPassword
    }
    
    weak var presenter: SignUpViewModelPresenter?
    
}

// MARK: - Exposed Helpers
extension SignUpViewModel {
    
    var createAccountLabelText: String {
        return Strings.Registration.createAccount
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
    
    var signUpButtonTitle: String {
        return Strings.Registration.signUp
    }
    
    var signInTextViewStaticText: String {
        return Strings.Registration.haveAnAccount
    }
    
    var signInTextViewLinkText: String {
        return " \(Strings.Registration.signIn)"
    }
    
    var signInTextViewUrl: URL? {
        return URL(string: signInTextViewLinkText.replacingOccurrences(of: " ", with: String()))
    }
    
    func keyboardDidShow() {
        presenter?.updateCreateAccountStackView(isHidden: true)
    }
    
    func keyboardDidHide() {
        presenter?.updateCreateAccountStackView(isHidden: false)
    }
    
    func signUpButtonTapped() {
        // Perform validation for all text fields
    }
    
    func signInLinkTapped() -> Bool {
        let viewModel = SignInViewModel()
        let viewController = SignInViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        presenter?.push(viewController)
        return false
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
