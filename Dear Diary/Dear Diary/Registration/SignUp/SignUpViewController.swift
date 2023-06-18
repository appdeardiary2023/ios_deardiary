//
//  SignUpViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class SignUpViewController: UIViewController,
                                  ViewLoadable {
    
    static var name = Constants.Registration.storyboardName
    static var identifier = Constants.Registration.signUpViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let createAccountLabelTextColor = Color.label.shade
        static let createAccountLabelFont = Font.largeTitle(.bold)
        
        static let fillDetailsLabelTextColor = Color.secondaryLabel.shade
        static let fillDetailsLabelFont = Font.subheadline(.regular)
        
        static let textFieldBackgroundColor = Color.secondaryBackground.shade
        static let textFieldTextColor = Color.tertiaryLabel.shade
        static let textFieldTintColor = Color.tertiaryLabel.shade.withAlphaComponent(0.6)
        static let textFieldFont = Font.subheadline(.regular)
        static let textFieldCornerRadius = Constants.Layout.cornerRadius
        static let textFieldViewWidth: CGFloat = 25
        
        static let eyedButtonTintColor = Color.tertiaryLabel.shade.withAlphaComponent(0.6)
        static let eyeButtonImageViewSize = CGSize(width: 30, height: 30)
        
        static let signUpButtonBackgroundColor = Color.primary.shade
        static let signUpButtonTitleColor = Color.white.shade
        static let signUpButtonFont = Font.callout(.bold)
        static let signUpButtonCornerRadius = Constants.Layout.cornerRadius
        
        static let signInTextViewBackgroundColor = UIColor.clear
        static let signInTextViewStaticTextColor = Color.label.shade
        static let signInTextViewLinkTextColor = Color.primary.shade
        static let signInTextViewFont = Font.subheadline(.bold)
        
        static let keyboardBottomOffset: CGFloat = 30
        
        static let animationDuration = Constants.Animation.defaultDuration
    }
    
    @IBOutlet private weak var createAccountStackView: UIStackView!
    @IBOutlet private weak var createAccountLabel: UILabel!
    @IBOutlet private weak var fillDetailsLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var signInTextView: UITextView!
    @IBOutlet private weak var registerStackViewBottomConstraint: NSLayoutConstraint!
    
    var viewModel: SignUpViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObservers()
    }

}

// MARK: - Private Helpers
private extension SignUpViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupCreateAccountLabel()
        setupFillDetailsLabel()
        setupDetailTextFields()
        setupSignUpButton()
        setupSignInTextView()
        viewModel?.presenter = self
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupCreateAccountLabel() {
        createAccountLabel.textColor = Style.createAccountLabelTextColor
        createAccountLabel.font = Style.createAccountLabelFont
        createAccountLabel.text = viewModel?.createAccountLabelText
    }
    
    func setupFillDetailsLabel() {
        fillDetailsLabel.textColor = Style.fillDetailsLabelTextColor
        fillDetailsLabel.font = Style.fillDetailsLabelFont
        fillDetailsLabel.text = viewModel?.fillDetailsLabelText
    }
    
    func setupDetailTextFields() {
        viewModel?.fields.enumerated().forEach { (index, field) in
            let textField = getTextField(for: field)
            textField.backgroundColor = Style.textFieldBackgroundColor
            textField.textColor = Style.textFieldTextColor
            textField.tintColor = Style.textFieldTintColor
            textField.font = Style.textFieldFont
            textField.placeholder = field.placeholder
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
                eyeButton.setImage(viewModel?.eyeButtonImage, for: .normal)
                eyeButton.imageView?.frame.size = Style.eyeButtonImageViewSize
                eyeButton.addTarget(self, action: #selector(eyeButtonTapped(_:)), for: .touchUpInside)
                rightView.addSubview(eyeButton)
            }
            if field.isFirstResponder {
                // Brings up the keyboard for this text field
                textField.becomeFirstResponder()
            }
        }
    }
    
    func setupSignUpButton() {
        signUpButton.backgroundColor = Style.signUpButtonBackgroundColor
        signUpButton.setTitleColor(Style.signUpButtonTitleColor, for: .normal)
        signUpButton.titleLabel?.font = Style.signUpButtonFont
        signUpButton.setTitle(viewModel?.signUpButtonTitle, for: .normal)
        signUpButton.layer.cornerRadius = Style.signUpButtonCornerRadius
    }
    
    func setupSignInTextView() {
        guard let viewModel = viewModel else { return }
        let attributedText = NSMutableAttributedString()
        let staticText = NSAttributedString(
            string: viewModel.signInTextViewStaticText,
            attributes: [
                .foregroundColor: Style.signInTextViewStaticTextColor,
                .font: Style.signInTextViewFont
            ]
        )
        var linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Style.signInTextViewLinkTextColor,
            .font: Style.signInTextViewFont
        ]
        if let url = viewModel.signInTextViewUrl {
            linkAttributes[.link] = url
        }
        let linkText = NSAttributedString(
            string: viewModel.signInTextViewLinkText,
            attributes: linkAttributes
        )
        attributedText.append(staticText)
        attributedText.append(linkText)
        signInTextView.linkTextAttributes = linkAttributes
        signInTextView.backgroundColor = Style.signInTextViewBackgroundColor
        signInTextView.attributedText = attributedText
        signInTextView.textAlignment = .center
        signInTextView.isEditable = false
        signInTextView.isScrollEnabled = false
        signInTextView.delegate = self
    }
    
    /// Returns a text field for the specified `field` type
    func getTextField(for field: SignUpViewModel.Field) -> UITextField {
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
    
    @IBAction func signUpButtonTapped() {
        viewModel?.signUpButtonTapped()
    }
    
}

// MARK: - KeyboardObservable Helpers
extension SignUpViewController: KeyboardObservable {
    
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
extension SignUpViewController: UITextFieldDelegate {
    
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

// MARK: - UITextViewDelegate Helpers
extension SignUpViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return viewModel?.signInLinkTapped() ?? false
    }
    
}

// MARK: - KeyboardLayoutDelegate Methods
extension SignUpViewController: KeyboardLayoutDelegate {
    
    func keyboardDidShow() {
        viewModel?.keyboardDidShow()
    }
    
    func keyboardDidHide() {
        viewModel?.keyboardDidHide()
    }
    
}

// MARK: - SignUpViewModelPresenter Methods
extension SignUpViewController: SignUpViewModelPresenter {
    
    func updateCreateAccountStackView(isHidden: Bool) {
        createAccountStackView.isHidden = isHidden
        UIView.animate(withDuration: Style.animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - SignUpViewModel.Field Helpers
private extension SignUpViewModel.Field {

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
