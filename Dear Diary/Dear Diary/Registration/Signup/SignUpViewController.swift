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
    }
    
    @IBAction func signUpButtonTapped() {
        
    }
    
}
