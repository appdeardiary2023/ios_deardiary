//
//  RegisterViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 29/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class RegisterViewController: UIViewController,
                                    ViewLoadable {
    
    static let name = Constants.Registration.storyboardName
    static let identifier = Constants.Registration.registerViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let titleLabelTextColor = Color.label.shade
        static let titleLabelFont = Font.largeTitle(.bold)
        
        static let subtitleLabelTextColor = Color.secondaryLabel.shade
        static let subtitleLabelFont = Font.subheadline(.regular)
        
        static let textFieldBackgroundColor = Color.secondaryBackground.shade
        static let textFieldTextColor = Color.label.shade
        static let textFieldPlaceholderColor = Color.tertiaryLabel.shade
        static let textFieldTintColor = Color.secondaryLabel.shade
        static let textFieldFont = Font.subheadline(.regular)
        static let textFieldPlaceholderFont = Font.subheadline(.regular)
        static let textFieldCornerRadius = Constants.Layout.cornerRadius
        static let textFieldViewWidth: CGFloat = 25
        
        static let eyedButtonTintColor = Color.tertiaryLabel.shade
        static let eyeButtonImageViewSize = CGSize(width: 30, height: 30)
        
        static let forgotPasswordButtonTintColor = Color.secondaryLabel.shade
        static let forgotPasswordButtonFont = Font.subheadline(.regular)
        static let forgotPasswordButtonCornerRadius = Constants.Layout.cornerRadius
        
        static let primaryButtonBackgroundColor = Color.primary.shade
        static let primaryButtonTintColor = Color.white.shade
        static let primaryButtonFont = Font.callout(.bold)
        static let primaryButtonCornerRadius = Constants.Layout.cornerRadius
        
        static let googleButtonBackgroundColor = Color.label.shade
        static let googleButtonTintColor = Color.invertedLabel.shade
        static let googleButtonFont = Font.callout(.bold)
        static let googleButtonImageViewSize = CGSize(width: 24, height: 24)
        static let googleButtonContentSpacing: CGFloat = 6
        static let googleButtonCornerRadius = Constants.Layout.cornerRadius
        
        static let messageLabelTextColor = Color.label.shade
        static let messageLabelFont = Font.callout(.bold)
        
        static let messageButtonTintColor = Color.primary.shade
        static let messageButtonFont = Font.callout(.bold)
        
        static let keyboardBottomOffset: CGFloat = 30
        
        static let animationDuration = Constants.Animation.defaultDuration
    }
    
    @IBOutlet private weak var headingStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var primaryButton: UIButton!
    @IBOutlet private weak var googleButton: UIButton!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageButton: UIButton!
    @IBOutlet private weak var registerStackViewBottomConstraint: NSLayoutConstraint!
    
    var viewModel: RegisterViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.screenWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.screenWillDisappear()
    }
    
}

// MARK: - Private Helpers
private extension RegisterViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupTitleLabel()
        setupSubtitleLabel()
        setupDetailTextFields()
        setupForgotPasswordButton()
        setupPrimaryButton()
        setupGoogleButton()
        setupMessageLabel()
        setupMessageButton()
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
        titleLabel.text = viewModel?.flow.titleLabelText
    }
    
    func setupSubtitleLabel() {
        subtitleLabel.textColor = Style.subtitleLabelTextColor
        subtitleLabel.font = Style.subtitleLabelFont
        subtitleLabel.text = viewModel?.flow.subtitleLabelText
    }
    
    func setupDetailTextFields() {
        viewModel?.flow.fields.enumerated().forEach { (index, field) in
            let textField = getTextField(for: field)
            textField.backgroundColor = Style.textFieldBackgroundColor
            textField.textColor = Style.textFieldTextColor
            textField.tintColor = Style.textFieldTintColor
            textField.font = Style.textFieldFont
            textField.attributedPlaceholder = NSAttributedString(
                string: field.placeholder,
                attributes: [
                    .foregroundColor: Style.textFieldPlaceholderColor,
                    .font: Style.textFieldPlaceholderFont
                ]
            )
            textField.layer.cornerRadius = Style.textFieldCornerRadius
            textField.borderStyle = .none
            textField.keyboardType = field.keyboardType
            textField.autocorrectionType = .no
            textField.isSecureTextEntry = field.isPasswordProtected
            textField.delegate = self
            // Horizontal views
            let fieldViewFrame = CGRect(
                x: 0,
                y: 0,
                width: Style.textFieldViewWidth,
                height: textField.bounds.height
            )
            let leftView = UIView(frame: fieldViewFrame)
            textField.leftView = leftView
            textField.leftViewMode = .always
            let rightView = UIView(frame: fieldViewFrame)
            textField.rightView = rightView
            textField.rightViewMode = .always
            if field.isPasswordProtected {
                // Add eye button
                let eyeButtonImageSize = Style.eyeButtonImageViewSize
                rightView.frame.size = CGSize(
                    width: 2 * fieldViewFrame.width + eyeButtonImageSize.width,
                    height: fieldViewFrame.height
                )
                let eyeButton = UIButton(type: .system)
                let eyeButtonFrame = CGRect(
                    x: rightView.frame.midX - eyeButtonImageSize.width / 2,
                    y: rightView.frame.midY - eyeButtonImageSize.height / 2,
                    width: eyeButtonImageSize.width,
                    height: eyeButtonImageSize.height
                )
                eyeButton.frame = eyeButtonFrame
                eyeButton.tintColor = Style.eyedButtonTintColor
                eyeButton.setImage(
                    viewModel?.eyeButtonImage?
                        .resize(to: Style.eyeButtonImageViewSize),
                    for: .normal
                )
                eyeButton.addTarget(self, action: #selector(eyeButtonTapped(_:)), for: .touchUpInside)
                rightView.addSubview(eyeButton)
            }
            if field == viewModel?.flow.firstRespondingField {
                // Brings up the keyboard for this text field
                textField.becomeFirstResponder()
            }
        }
        viewModel?.flow.hiddenFields.forEach { field in
            let textField = getTextField(for: field)
            textField.isHidden = true
        }
    }
    
    func setupForgotPasswordButton() {
        forgotPasswordButton.tintColor = Style.forgotPasswordButtonTintColor
        forgotPasswordButton.titleLabel?.font = Style.forgotPasswordButtonFont
        forgotPasswordButton.setTitle(viewModel?.forgotPasswordButtonTitle, for: .normal)
        forgotPasswordButton.isHidden = viewModel?.flow.isForgotPasswordButtonHidden ?? false
    }
    
    func setupPrimaryButton() {
        primaryButton.backgroundColor = Style.primaryButtonBackgroundColor
        primaryButton.tintColor = Style.primaryButtonTintColor
        primaryButton.titleLabel?.font = Style.primaryButtonFont
        primaryButton.setTitle(viewModel?.flow.primaryButtonTitle, for: .normal)
        primaryButton.layer.cornerRadius = Style.primaryButtonCornerRadius
    }
    
    func setupGoogleButton() {
        googleButton.backgroundColor = Style.googleButtonBackgroundColor
        googleButton.tintColor = Style.googleButtonTintColor
        googleButton.titleLabel?.font = Style.googleButtonFont
        googleButton.setImage(
            viewModel?.googleButtonImage?
                .resize(to: Style.googleButtonImageViewSize),
            for: .normal
        )
        googleButton.setTitle(viewModel?.googleButtonTitle, for: .normal)
        googleButton.setContentSpacing(Style.googleButtonContentSpacing)
        googleButton.layer.cornerRadius = Style.googleButtonCornerRadius
        googleButton.isHidden = viewModel?.flow.isGoogleButtonHidden ?? false
    }
    
    func setupMessageLabel() {
        messageLabel.textColor = Style.messageLabelTextColor
        messageLabel.font = Style.messageLabelFont
        messageLabel.text = viewModel?.flow.messageLabelText
    }
    
    func setupMessageButton() {
        messageButton.tintColor = Style.messageButtonTintColor
        messageButton.titleLabel?.font = Style.messageButtonFont
        messageButton.setTitle(viewModel?.flow.messageButtonTitle, for: .normal)
    }
    
    /// Returns a text field for the specified `field` type
    func getTextField(for field: RegisterViewModel.Field) -> UITextField {
        switch field {
        case .name:
            return nameTextField
        case .email:
            return emailTextField
        case .password:
            return passwordTextField
        case .confirmPassword:
            return confirmPasswordTextField
        }
    }
    
    @objc
    func eyeButtonTapped(_ sender: UIButton) {
        // TODO
    }
    
    @IBAction func forgotPasswordButtonTapped() {
        viewModel?.forgotPasswordButtonTapped()
    }
    
    @IBAction func primaryButtonTapped() {
        viewModel?.primaryButtonTapped()
    }
    
    @IBAction func googleButtonTapped() {
        viewModel?.googleButtonTapped()
    }
    
    @IBAction func messageButtonTapped() {
        viewModel?.messageButtonTapped(with: navigationController?.viewControllers.count ?? 0)
    }
    
}

// MARK: - KeyboardObservable Helpers
extension RegisterViewController: KeyboardObservable {
    
    var layoutableConstraint: NSLayoutConstraint {
        return registerStackViewBottomConstraint
    }
    
    var layoutableView: UIView? {
        return view
    }
    
    var constraintOffset: CGFloat {
        return Style.keyboardBottomOffset
    }
    
    var layoutDelegate: KeyboardLayoutDelegate? {
        return self
    }
    
}

// MARK: - UITextFieldDelegate Helpers
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // TODO
        return true
    }
    
}

// MARK: - KeyboardLayoutDelegate Methods
extension RegisterViewController: KeyboardLayoutDelegate {
    
    func keyboardDidShow() {
        viewModel?.keyboardDidShow()
    }
    
    func keyboardDidHide() {
        viewModel?.keyboardDidHide()
    }
    
}

// MARK: - RegisterViewModelPresenter Methods
extension RegisterViewController: RegisterViewModelPresenter {
    
    func addKeyboardObservables() {
        addKeyboardObservers()
    }
    
    func removeKeyboardObservables() {
        removeKeyboardObservers()
    }
    
    func updateHeadingStackView(isHidden: Bool) {
        headingStackView.isHidden = isHidden
        UIView.animate(withDuration: Style.animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismiss(completion: @escaping () -> Void) {
        // TODO: Nicely animate removal
        navigationController?.dismiss(animated: false, completion: completion)
    }
    
}

// MARK: - RegisterViewModel.Field Helpers
private extension RegisterViewModel.Field {

    var keyboardType: UIKeyboardType {
        switch self {
        case .name:
            return .alphabet
        case .email:
            return .emailAddress
        case .password, .confirmPassword:
            return .default
        }
    }
    
}
