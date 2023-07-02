//
//  OTPViewController.swift
//  Dear Diary
//
//  Created by Hitesh Moudgil on 2023-06-29.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import DearDiaryStrings

class OTPViewController: UIViewController,
                         ViewLoadable {
    
    static let name = Constants.Registration.storyboardName
    static let identifier =  Constants.Registration.otpViewController
    var emailTextValue: String?
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        static let OTPLabelTextColor = Color.label.shade
        static let OTPLabelFont = Font.largeTitle(.bold)
        static let verificationCodeLabelTextColor = Color.label.shade
        static let verificationCodeLabelFont = Font.largeTitle(.semibold)
        static let verificationTextLabelTextColor = Color.secondaryLabel.shade
        static let verificationTextLabelFont = Font.headline(.regular)
        static let emailLabelTextColor = Color.secondaryLabel.shade
        static let emailLabelFont = Font.headline(.regular)
        static let numbersTextFieldTextColor = Color.label.shade
        static let numbersTextFieldFont = Font.headline(.regular)
        static let submitButtonTintColor = Color.white.shade
        static let submitButtonFont = Font.callout(.bold)
        static let submitButtonBackgroundColor = Color.primary.shade
        static let submitButtonCornerRadius = Constants.Layout.cornerRadius
        static let textFieldsBackgroundColor = Color.secondaryBackground.shade
    }
    
    @IBOutlet weak var OTPLabel: UILabel!
    @IBOutlet weak var OTPImageView: UIImageView!
    @IBOutlet weak var verificationCodeLabel: UILabel!
    @IBOutlet weak var verificationTextLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var numberTextFields: [UITextField]!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Style.backgroundColor
        setupOTPLabel()
        setupVerificationCodeLabel()
        setupVerificationTextLabel()
        setupEmailLabel()
        setupNumberTextFields()
        setupSubmitButton()
        addKeyboardObservers()
    }
   
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func setupOTPLabel() {
        OTPLabel.text = Strings.Registration.OTPLabel
        OTPLabel.textColor = Style.OTPLabelTextColor
        OTPLabel.font = Style.OTPLabelFont
    }
    
    func setupVerificationCodeLabel() {
        verificationCodeLabel.text = Strings.Registration.verificationCodeLabel
        verificationCodeLabel.textColor = Style.verificationCodeLabelTextColor
        verificationCodeLabel.font = Style.verificationCodeLabelFont
    }
    
    func setupVerificationTextLabel() {
        verificationTextLabel.text = Strings.Registration.verificationTextLabel
        verificationTextLabel.textColor = Style.verificationTextLabelTextColor
        verificationTextLabel.font = Style.verificationTextLabelFont
    }
    
    func setupEmailLabel() {
        emailLabel.text = emailTextValue
        emailLabel.textColor = Style.emailLabelTextColor
        emailLabel.font = Style.emailLabelFont
    }
    
    func setupNumberTextFields() {
        for textField in numberTextFields {
            textField.textColor = Style.numbersTextFieldTextColor
            textField.font = Style.numbersTextFieldFont
            textField.backgroundColor = Style.textFieldsBackgroundColor
            textField.borderStyle = .none
            textField.layer.cornerRadius = 20.0
        }
        

        
    }
    
    func setupSubmitButton() {
        submitButton.setTitle(Strings.Registration.submitButton, for: .normal)
        submitButton.titleLabel?.font = Style.submitButtonFont
        submitButton.tintColor = Style.submitButtonTintColor
        submitButton.backgroundColor = Style.submitButtonBackgroundColor
        submitButton.layer.cornerRadius = Style.submitButtonCornerRadius
    }
}

extension OTPViewController: KeyboardObservable,
                             KeyboardLayoutDelegate {
    var layoutableConstraint: NSLayoutConstraint {
        return stackViewBottomConstraint
    }
    
    var layoutableView: UIView? {
        return view
    }
    
    var constraintOffset: CGFloat {
        return 30
    }
    
    var layoutDelegate: KeyboardLayoutDelegate? {
        return self
    }
    
    func keyboardDidShow() {
        
    }
    
    func keyboardDidHide() {

    }
}
