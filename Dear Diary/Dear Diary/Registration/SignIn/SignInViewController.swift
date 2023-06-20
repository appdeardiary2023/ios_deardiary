//
//  SignInViewController.swift
//  Dear Diary
//
//  Created by Hitesh Moudgil on 2023-06-15.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

class SignInViewController: UIViewController,
                            ViewLoadable {
    
    static var name = Constants.Registration.storyboardName
    static var identifier = Constants.Registration.signInViewController

    private struct Style{
        static let backgroundColor = Color.background.shade
        
        static let welcomeBackLabelTextColor = Color.label.shade
        static let welcomeBackLabelFont = Font.largeTitle(.bold)
        
        static let welcomeInfoLabelTextColor = Color.secondaryLabel.shade
        static let welcomeInfoLabelFont = Font.headline(.regular)
        
        static let textFieldTextColor = Color.tertiaryLabel.shade
        static let textFieldBackgroundColor = Color.secondaryBackground.shade
        static let textFieldTintColor = Color.tertiaryLabel.shade.withAlphaComponent(0.6)
        static let textFieldFont = Font.subheadline(.regular)
        static let textFieldCornerRadius = Constants.Layout.cornerRadius
        static let textFieldViewWidth: CGFloat = 25
        
        static let eyedButtonTintColor = Color.tertiaryLabel.shade.withAlphaComponent(0.6)
        static let eyeButtonImageViewSize = CGSize(width: 30, height: 30)
        
        static let forgotPasswordButtonTextColor = Color.secondaryLabel.shade
        static let forgotPasswordButtonFont = Font.headline(.regular)
        
        static let signInButtonTextColor = Color.label.shade
        static let signInButtonBackgroundColor = Color.primary.shade
        static let signInButtonFont = Font.callout(.bold)
        //layer.corner radius
        
        static let signInButtonWithGoogleTextColor = Color.label.shade
        static let signInButtonWithGoogleBackgroundColor = Color.secondaryBackground.shade
        static let signInButtonWithGoogleFont = Font.callout(.bold)
        //signUpTextView is remaining
    }
    
    @IBOutlet weak var welcomeBackLabel: UILabel!
    @IBOutlet weak var welcomeInfoLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInWithGoogleButton: UIButton!
    @IBOutlet weak var signUpTextView: UITextView!
    
    var viewModel: SignInViewModelable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        forgotPasswordButton.setTitleColor(Style.forgotPasswordButtonTextColor, for: .normal)
        forgotPasswordButton.titleLabel?.font = Style.forgotPasswordButtonFont
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        
        signInButton.setTitleColor(Style.signInButtonTextColor, for: .normal)
        signInButton.backgroundColor = Style.signInButtonBackgroundColor
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.font = Style.signInButtonFont
        
        signInWithGoogleButton.setTitleColor(Style.signInButtonWithGoogleTextColor, for: .normal)
        signInWithGoogleButton.backgroundColor = Style.signInButtonWithGoogleBackgroundColor
        signInWithGoogleButton.setTitle("Sign In with Google", for: .normal)
        signInWithGoogleButton.titleLabel?.font = Style.signInButtonWithGoogleFont
        
//        signUpTextView.textColor =
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

private extension SignInViewController{
    func setup(){
        view.backgroundColor = Style.backgroundColor
        setupWelcomeBackLabel()
        setupWelcomeInfoLabel()
        setupTextFields()
    }
    
    func setupWelcomeBackLabel(){
        welcomeBackLabel.textColor = Style.welcomeBackLabelTextColor
        welcomeBackLabel.font = Style.welcomeBackLabelFont
        welcomeBackLabel.text = viewModel?.welcomeBackLabelText
    }
    
    func setupWelcomeInfoLabel(){
        welcomeInfoLabel.textColor = Style.welcomeInfoLabelTextColor
        welcomeInfoLabel.font = Style.welcomeInfoLabelFont
        welcomeInfoLabel.text = viewModel?.welcomeInfoText
    }
    
    func setupTextFields(){
        viewModel?.fields.forEach { field in
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
                eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
                rightView.addSubview(eyeButton)
            }
            if field.isFirstResponder {
                // Brings up the keyboard for this text field
                textField.becomeFirstResponder()
            }
        }
    }
    
    func getTextField(for field: SignInViewModel.Field) -> UITextField {
        switch field {
        case .email:
            return emailTextField
        case .password:
            return passwordTextField
        }
    }
    
    @objc
    func eyeButtonTapped() {
        // TODO
    }
}

extension SignInViewController: UITextFieldDelegate {
    
}

private extension SignInViewModel.Field{
    var keyboardType: UIKeyboardType{
        switch self{
        case .email:
            return .emailAddress
        case .password:
            return .default
        }
    }
}

