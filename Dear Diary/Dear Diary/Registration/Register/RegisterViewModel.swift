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
    var userName: String? { get }
    var userEmail: String? { get }
    var userPassword: String? { get }
    var userConfirmedPassword: String? { get }
    func addKeyboardObservables()
    func removeKeyboardObservables()
    func updateHeadingStackView(isHidden: Bool)
    func updateDetailTextFields(with emailId: String, password: String)
    func updatePasswordField(_ field: RegisterViewModel.Field, isTextHidden: Bool)
    func updateEyeButtonImage(for field: RegisterViewModel.Field, with image: UIImage?)
    func updateErrorLabel(for field: RegisterViewModel.Field, with error: String?)
    func push(_ viewController: UIViewController)
    func pop()
    func dismiss(completion: @escaping () -> Void)
}

protocol RegisterViewModelable {
    var flow: RegisterViewModel.Flow { get }
    var forgotPasswordButtonTitle: String { get }
    var googleButtonImage: UIImage? { get }
    var googleButtonTitle: String { get }
    var presenter: RegisterViewModelPresenter? { get set }
    func screenDidLoad()
    func screenWillAppear()
    func screenWillDisappear()
    func keyboardDidShow()
    func keyboardDidHide()
    func eyeButtonTapped(with tag: Int)
    func didChangeText(in tag: Int, newText: String) -> Bool
    func forgotPasswordButtonTapped()
    func primaryButtonTapped()
    func googleButtonTapped()
    func messageButtonTapped(with controllersCount: Int)
}

final class RegisterViewModel: RegisterViewModelable,
                               JSONable {
    
    enum Flow {
        case signUp
        case signIn
    }
    
    enum Field: Int, CaseIterable {
        case name
        case email
        case password
        case confirmPassword
    }

    let flow: Flow
    weak var presenter: RegisterViewModelPresenter?
    
    /// Map to keep a track of password visibilty for protected fields
    private var protectedFieldsHiddenDict: [Field: Bool]
    private weak var listener: RegisterViewModelListener?
    
    init(flow: Flow, listener: RegisterViewModelListener?) {
        self.flow = flow
        self.protectedFieldsHiddenDict = [:]
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension RegisterViewModel {
    
    var forgotPasswordButtonTitle: String {
        return Strings.Registration.forgotPassword
    }
    
    var googleButtonImage: UIImage? {
        return Image.google.asset
    }
    
    var googleButtonTitle: String {
        return Strings.Registration.signInWithGoogle
    }
    
    func screenDidLoad() {
        setupProtectedFieldsHiddenDict()
        fetchUserData()
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
    
    func eyeButtonTapped(with tag: Int) {
        guard let field = Field(rawValue: tag),
              let isHidden = protectedFieldsHiddenDict[field] else { return }
        protectedFieldsHiddenDict[field] = !isHidden
        presenter?.updatePasswordField(field, isTextHidden: !isHidden)
        let eyeButtonImage = !isHidden ? Image.eyeClosed.asset : Image.eyeOpened.asset
        presenter?.updateEyeButtonImage(for: field, with: eyeButtonImage)
    }
    
    func didChangeText(in tag: Int, newText: String) -> Bool {
        guard let field = Field(rawValue: tag) else { return false }
        validateField(field, with: newText, shouldCheckPassword: true)
        return true
    }
    
    func forgotPasswordButtonTapped() {
        // TODO
    }
    
    func primaryButtonTapped() {
        for field in flow.fields {
            guard validateField(field, shouldCheckPassword: false) else { return }
        }
        // This code won't be executed if a validation error is found
        switch flow {
        case .signUp:
            guard let name = presenter?.userName,
                  let emailId = presenter?.userEmail,
                  let password = presenter?.userPassword else { return }
            let newUser = User.createObject(name: name, emailId: emailId, password: password)
            AuthStore.shared.user = newUser
            showOtpScreen(with: emailId)
        case .signIn:
            guard doesPassSignInValidation else { return }
            presenter?.dismiss { [weak self] in
                self?.listener?.userSignedIn()
            }
        }
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
    
    var doesPassSignInValidation: Bool {
        guard let emailId = presenter?.userEmail,
              let password = presenter?.userPassword else { return false }
        // TODO: These work only for mock data, change error texts
        let user = AuthStore.shared.user
        guard emailId == user.emailId else {
            updateError(Strings.Registration.emailIncorrectError, for: .email)
            return false
        }
        guard password == user.password else {
            updateError(Strings.Registration.passwordIncorrectError, for: .password)
            return false
        }
        return true
    }
    
    func fetchUserData() {
        switch flow {
        case .signUp:
            // No need to mock anything, user will create a new account
            return
        case .signIn:
            fetchData(for: .signIn) { [weak self] (user: User) in
                AuthStore.shared.user = user
                self?.presenter?.updateDetailTextFields(with: user.emailId, password: user.password)
            }
        }
    }
    
    func setupProtectedFieldsHiddenDict() {
        flow.fields.forEach { field in
            if field.isPasswordProtected {
                protectedFieldsHiddenDict[field] = true
                presenter?.updateEyeButtonImage(for: field, with: Image.eyeClosed.asset)
            }
        }
    }
    
    @discardableResult
    func validateField(_ field: Field, with text: String = String(), shouldCheckPassword: Bool) -> Bool {
        switch field {
        case .name:
            guard let name = presenter?.userName,
                  !(name + text).isEmpty else {
                updateError(Strings.Registration.genericError, for: field)
                return false
            }
        case .email:
            guard let emailId = presenter?.userEmail,
                  !(emailId + text).isEmpty else {
                updateError(Strings.Registration.genericError, for: field)
                return false
            }
            guard isValidEmail(emailId + text) else {
                updateError(Strings.Registration.emailIncorrectError, for: field)
                return false
            }
        case .password:
            guard let password = presenter?.userPassword,
                  !(password + text).isEmpty else {
                updateError(Strings.Registration.genericError, for: field)
                return false
            }
        case .confirmPassword:
            guard shouldCheckPassword else { return true }
            guard let password = presenter?.userPassword,
                  var confirmedPassword = presenter?.userConfirmedPassword,
                  !(confirmedPassword + text).isEmpty else {
                updateError(Strings.Registration.genericError, for: field)
                return false
            }
            confirmedPassword = text.isEmpty
                ? String(confirmedPassword.dropLast())
                : confirmedPassword + text
            guard password == confirmedPassword else {
                updateError(Strings.Registration.passwordsDontMatchError, for: field)
                return false
            }
        }
        // No error found
        updateError(for: field)
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = Constants.Registration.emailRegex
        do {
            let regex = try NSRegularExpression(
                pattern: emailRegex,
                options: .caseInsensitive
            )
            let matches = regex.matches(
                in: email,
                options: [],
                range: NSRange(location: 0, length: email.utf16.count)
            )
            return matches.count > 0
        } catch {
            return false
        }
    }
    
    func updateError(_ error: String? = nil, for field: Field) {
        presenter?.updateErrorLabel(for: field, with: error)
    }
    
    func showOtpScreen(with userEmail: String) {
        let viewController = OtpViewController.loadFromStoryboard()
        viewController.emailTextValue = userEmail
        viewController.listener = self
        presenter?.push(viewController)
    }
    
}

// MARK: - OtpViewControllerListener Methods
extension RegisterViewModel: OtpViewControllerListener {
    
    func otpVerifiedSuccesfully() {
        presenter?.dismiss { [weak self] in
            self?.listener?.userSignedUp()
        }
    }
    
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
