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
        
        static let emailTextFieldTextColor = Color.tertiaryLabel.shade
        static let emailTextFieldBackgroundColor = Color.secondaryBackground.shade
        static let emailTextFieldFont = Font.headline(.regular)
        
        static let passwordTextFieldTextColor = Color.tertiaryLabel.shade
        static let passwordTextFieldBackgroundColor = Color.secondaryBackground.shade
        static let passwordTextFieldFont = Font.headline(.regular)
        
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

        view.backgroundColor = Style.backgroundColor
        
        welcomeBackLabel.textColor = Style.welcomeBackLabelTextColor
        welcomeBackLabel.font = Style.welcomeBackLabelFont
        welcomeBackLabel.text = viewModel?.welcomeBackLabelText
        
        welcomeInfoLabel.textColor = Style.welcomeInfoLabelTextColor
        welcomeInfoLabel.font = Style.welcomeInfoLabelFont
        welcomeInfoLabel.text = "Please sign in to your account"
        
        
        emailTextField.textColor = Style.emailTextFieldTextColor
//        emailTextField.placeholder =
        emailTextField.backgroundColor = Style.emailTextFieldBackgroundColor
        emailTextField.font = Style.emailTextFieldFont
        emailTextField.text = "Email"
        
        passwordTextField.textColor = Style.passwordTextFieldTextColor
        passwordTextField.backgroundColor = Style.passwordTextFieldBackgroundColor
        passwordTextField.font = Style.passwordTextFieldFont
        passwordTextField.text = "Password"
        
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
