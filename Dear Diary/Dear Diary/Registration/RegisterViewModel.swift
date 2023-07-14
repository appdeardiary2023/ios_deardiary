//
//  RegisterViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 29/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages

protocol RegisterViewModelListener: AnyObject {
    func userSignedUp()
    func userSignedIn()
}

protocol RegisterViewModelPresenter: AnyObject {
    var userEmail: String? { get }
    func addKeyboardObservables()
    func removeKeyboardObservables()
    func updateHeadingStackView(isHidden: Bool)
    func push(_ viewController: UIViewController)
    func pop()
    func dismiss(completion: @escaping () -> Void)
}

protocol RegisterViewModelable {
    var flow: RegisterViewModel.Flow { get }
    var eyeButtonImage: UIImage? { get }
    var forgotPasswordButtonTitle: String { get }
    var googleButtonImage: UIImage? { get }
    var googleButtonTitle: String { get }
    var presenter: RegisterViewModelPresenter? { get set }
    func screenWillAppear()
    func screenWillDisappear()
    func keyboardDidShow()
    func keyboardDidHide()
    func forgotPasswordButtonTapped()
    func primaryButtonTapped()
    func googleButtonTapped()
    func messageButtonTapped(with controllersCount: Int)
}

final class RegisterViewModel: RegisterViewModelable {
    
    enum Flow {
        case signUp
        case signIn
    }
    
    enum Field: CaseIterable {
        case name
        case email
        case password
        case confirmPassword
    }

    let flow: Flow
    weak var presenter: RegisterViewModelPresenter?
    
    private weak var listener: RegisterViewModelListener?
    
    init(flow: Flow, listener: RegisterViewModelListener?) {
        self.flow = flow
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension RegisterViewModel {
    
    var eyeButtonImage: UIImage? {
        return Image.eyeOpened.asset
    }
    
    var forgotPasswordButtonTitle: String {
        return Strings.Registration.forgotPassword
    }
    
    var googleButtonImage: UIImage? {
        return Image.google.asset
    }
    
    var googleButtonTitle: String {
        return Strings.Registration.signInWithGoogle
    }
    
    func screenWillAppear() {
        presenter?.addKeyboardObservables()
    }
    
    func screenWillDisappear() {
        presenter?.removeKeyboardObservables()
    }
    
    func keyboardDidShow() {
        presenter?.updateHeadingStackView(isHidden: true)
    }
    
    func keyboardDidHide() {
        presenter?.updateHeadingStackView(isHidden: false)
    }
    
    func forgotPasswordButtonTapped() {
        // TODO
    }
    
    func primaryButtonTapped() {
        // TODO: - Perform validation for all text fields
        // TODO: - Create user account
        presenter?.dismiss {[weak self] in
            self?.listener?.userSignedUp()
        }
//        let viewController = OTPViewController.loadFromStoryboard()
//        viewController.emailTextValue = presenter?.userEmail
//        presenter?.push(viewController)
    }
    
    func googleButtonTapped() {
        // TODO
    }
    
    func messageButtonTapped(with controllersCount: Int) {
        guard controllersCount > 1 else {
            // New controller not present in the stack
            let viewModel = RegisterViewModel(flow: flow.nextFlow, listener: listener)
            let viewController = RegisterViewController.loadFromStoryboard()
            viewController.viewModel = viewModel
            viewModel.presenter = viewController
            presenter?.push(viewController)
            return
        }
        // Old controller already present in the stack
        presenter?.pop()
    }
    
}

// MARK: - Private Helpers
private extension RegisterViewModel {
    
}

// MARK: - RegisterViewModel.Flow Helpers
extension RegisterViewModel.Flow {
    
    var titleLabelText: String {
        switch self {
        case .signUp:
            return Strings.Registration.createAccount
        case .signIn:
            return Strings.Registration.welcomeBack
        }
    }
    
    var subtitleLabelText: String {
        switch self {
        case .signUp:
            return Strings.Registration.fillDetails
        case .signIn:
            return Strings.Registration.signInToAccount
        }
    }
    
    var fields: [RegisterViewModel.Field] {
        switch self {
        case .signUp:
            return [.name, .email, .password, .confirmPassword]
        case .signIn:
            return [.email, .password]
        }
    }
    
    var hiddenFields: [RegisterViewModel.Field] {
        return RegisterViewModel.Field.allCases.filter { !fields.contains($0) }
    }
    
    var firstRespondingField: RegisterViewModel.Field? {
        return fields.first
    }
    
    var isForgotPasswordButtonHidden: Bool {
        switch self {
        case .signUp:
            return true
        case .signIn:
            return false
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
        case .signUp:
            return Strings.Registration.signUp
        case .signIn:
            return Strings.Registration.signIn
        }
    }
    
    var isGoogleButtonHidden: Bool {
        switch self {
        case .signUp:
            return true
        case .signIn:
            return false
        }
    }
    
    var messageLabelText: String {
        switch self {
        case .signUp:
            return Strings.Registration.haveAnAccount
        case .signIn:
            return Strings.Registration.dontHaveAnAccount
        }
    }
    
    var messageButtonTitle: String {
        let title: String
        switch self {
        case .signUp:
            title = Strings.Registration.signIn
        case .signIn:
            title = Strings.Registration.signUp
        }
        return " \(title)"
    }
    
}

// MARK: - RegisterViewModel.Field Helpers
extension RegisterViewModel.Field {
    
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
    
}

// MARK: - RegisterViewModel.Flow Helpers
private extension RegisterViewModel.Flow {
    
    var nextFlow: RegisterViewModel.Flow {
        switch self {
        case .signUp:
            return .signIn
        case .signIn:
            return .signUp
        }
    }
    
}
