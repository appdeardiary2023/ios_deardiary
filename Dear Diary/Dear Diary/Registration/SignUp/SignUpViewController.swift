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
        
        static let fillDetailsLabelTextColor = Color.tertiaryLabel.shade
        static let fillDetailsLabelFont = Font.subheadline(.regular)
        
        static let textFieldBackgroundColor = Color.secondaryBackground.shade
        static let textFieldTextColor = Color.secondaryLabel.shade
        static let textFieldFont = Font.subheadline(.regular)
        static let textFieldCornerRadius = Constants.Layout.cornerRadius
        static let textFieldViewWidth: CGFloat = 25
        
        static let eyedButtonTintColor = Color.secondaryLabel.shade
        static let eyeButtonImageViewSize = CGSize(width: 30, height: 30)
    }
    
    @IBOutlet private weak var createAccountLabel: UILabel!
    @IBOutlet private weak var fillDetailsLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var signInTextView: UITextView!
    
    var viewModel: SignUpViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension SignUpViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupCreateAccountLabel()
        setupFillDetailsLabel()
        setupDetailTextFields()
        viewModel?.presenter = self
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
            textField.font = Style.textFieldFont
            textField.placeholder = field.placeholder
            textField.layer.cornerRadius = Style.textFieldCornerRadius
            textField.borderStyle = .none
            textField.keyboardType = field.keyboardType
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

// MARK: - SignUpViewModelPresenter Methods
extension SignUpViewController: SignUpViewModelPresenter {
    
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
