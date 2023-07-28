//
//  OtpViewController.swift
//  Dear Diary
//
//  Created by Hitesh Moudgil on 2023-06-29.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import DearDiaryStrings
import DearDiaryImages

protocol OtpViewControllerListener: AnyObject {
    func otpVerifiedSuccesfully()
}

final class OtpViewController: UIViewController,
                               ViewLoadable,
                               JSONable {
    
    static let name = Constants.Registration.storyboardName
    static let identifier =  Constants.Registration.otpViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let backButtonTintColor = Color.label.shade
        
        static let otpLabelTextColor = Color.label.shade
        static let otpLabelFont = Font.largeTitle(.bold)
        
        static let verificationCodeLabelTextColor = Color.label.shade
        static let verificationCodeLabelFont = Font.largeTitle(.semibold)
        
        static let verificationTextLabelTextColor = Color.secondaryLabel.shade
        static let verificationTextLabelFont = Font.headline(.regular)
        
        static let numberTextFieldBackgroundColor = Color.secondaryBackground.shade
        static let numberTextFieldTintColor = Color.secondaryLabel.shade
        static let numbersTextFieldTextColor = Color.label.shade
        static let numbersTextFieldFont = Font.headline(.bold)
        
        static let submitButtonTintColor = Color.white.shade
        static let submitButtonFont = Font.callout(.bold)
        static let submitButtonBackgroundColor = Color.primary.shade
        static let submitButtonCornerRadius = Constants.Layout.cornerRadius
        
        static let keyboardBottomOffset: CGFloat = 30
        
        static let animationDuration = Constants.Animation.longDuration
    }
    
    @IBOutlet private weak var otpLabel: UILabel!
    @IBOutlet private weak var otpImageView: UIImageView!
    @IBOutlet private weak var verificationCodeLabel: UILabel!
    @IBOutlet private weak var verificationTextLabel: UILabel!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private var numberTextFields: [OtpTextField]!
    @IBOutlet private weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    private var otpCode: String?
    
    var emailTextValue: String?
    
    weak var listener: OtpViewControllerListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Style.backgroundColor
        setupBackButton()
        setupOtpLabel()
        setupOtpImageView()
        setupVerificationCodeLabel()
        setupVerificationTextLabel()
        setupNumberTextFields()
        setupSubmitButton()
        fetchOtpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    func setupBackButton() {
        backButton.tintColor = Style.backButtonTintColor
        backButton.setImage(Image.back.asset, for: .normal)
        backButton.setTitle(nil, for: .normal)
    }
    
    func setupOtpLabel() {
        otpLabel.text = Strings.Registration.otp
        otpLabel.textColor = Style.otpLabelTextColor
        otpLabel.font = Style.otpLabelFont
    }
    
    func setupOtpImageView() {
        otpImageView.image = Image.otp.asset
    }
    
    func setupVerificationCodeLabel() {
        verificationCodeLabel.text = Strings.Registration.verificationCode
        verificationCodeLabel.textColor = Style.verificationCodeLabelTextColor
        verificationCodeLabel.font = Style.verificationCodeLabelFont
    }
    
    func setupVerificationTextLabel() {
        verificationTextLabel.text = Strings.Registration.otpSentTo
        verificationTextLabel.textColor = Style.verificationTextLabelTextColor
        verificationTextLabel.font = Style.verificationTextLabelFont
        guard let userEmail = emailTextValue else { return }
        verificationTextLabel.text?.append(" \(userEmail)")
    }
    
    func setupNumberTextFields() {
        numberTextFields.enumerated().forEach { (index, textField) in
            textField.tag = index
            textField.tintColor = Style.numberTextFieldTintColor
            textField.textColor = Style.numbersTextFieldTextColor
            textField.font = Style.numbersTextFieldFont
            textField.backgroundColor = Style.numberTextFieldBackgroundColor
            textField.borderStyle = .none
            textField.layer.cornerRadius = min(textField.bounds.width, textField.bounds.height) / 2
            textField.keyboardType = .numberPad
            textField.autocorrectionType = .no
            textField.delegate = self
            // Add marker to previous and next text fields
            if index == .zero {
                textField.previousTextField = nil
            } else {
                textField.previousTextField = numberTextFields[safe: index - 1]
                numberTextFields[safe: index - 1]?.nextTextField = textField
            }
        }
    }
    
    func setupSubmitButton() {
        submitButton.setTitle(Strings.Registration.submit, for: .normal)
        submitButton.titleLabel?.font = Style.submitButtonFont
        submitButton.tintColor = Style.submitButtonTintColor
        submitButton.backgroundColor = Style.submitButtonBackgroundColor
        submitButton.layer.cornerRadius = Style.submitButtonCornerRadius
    }
    
    func fetchOtpData() {
        fetchData(for: .otp) { [weak self] (otp: Otp) in
            self?.otpCode = otp.code
            // TODO: This is only for mock data, remove later
            let numberCodes = otp.code.map { $0 }
            self?.numberTextFields.enumerated().forEach { (index, textField) in
                if let number = numberCodes[safe: index] {
                    textField.text = String(number)
                }
            }
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let code = numberTextFields.compactMap { $0.text }.joined()
        // Check if code matches the one received from server
        guard code == otpCode else {
            numberTextFields.forEach { textField in
                textField.text?.removeAll()
                textField.shake(withDuration: Style.animationDuration)
            }
            numberTextFields.first?.becomeFirstResponder()
            return
        }
        listener?.otpVerifiedSuccesfully()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension OtpViewController: KeyboardObservable {
    
    var layoutableConstraint: NSLayoutConstraint {
        return stackViewBottomConstraint
    }
    
    var layoutableView: UIView? {
        return view
    }
    
    var constraintOffset: CGFloat {
        return Style.keyboardBottomOffset
    }
    
    var additionalOffset: CGFloat {
        return .zero
    }
    
    var layoutDelegate: KeyboardLayoutDelegate? {
        return nil
    }
    
}

extension OtpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? OtpTextField else { return false }
        guard range.length > 0 else {
            guard string.isEmpty else {
                let nextTextField = textField.nextTextField
                if nextTextField == nil {
                    textField.resignFirstResponder()
                } else {
                    nextTextField?.becomeFirstResponder()
                }
                textField.text = string
                return true
            }
            return false
        }
        textField.previousTextField?.becomeFirstResponder()
        textField.text?.removeAll()
        return false
    }
    
}
