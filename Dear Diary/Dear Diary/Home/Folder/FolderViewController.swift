//
//  FolderViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 04/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class FolderViewController: UIViewController,
                                  ViewLoadable {
    
    static let name = Constants.Home.storyboardName
    static let identifier = Constants.Home.folderViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let backButtonTintColor = Color.label.shade
        
        static let doneButtonTintColor = Color.label.shade
        static let doneButtonFont = Font.headline(.semibold)
        
        static let titleTextFieldBackgroundColor = Color.secondaryBackground.shade
        static let titleTextFieldTextColor = Color.label.shade
        static let titleTextFieldPlaceholderColor = Color.tertiaryLabel.shade
        static let titleTextFieldTintColor = Color.secondaryLabel.shade
        static let titleTextFieldFont = Font.title3(.regular)
        static let titleTextFieldPlaceholderFont = Font.title3(.regular)
        static let titleTextFieldCornerRadius = Constants.Layout.cornerRadius
        static let titleTextFieldViewWidth: CGFloat = 25
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var titleTextField: UITextField!
    
    var viewModel: FolderViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

// MARK: - Private Helpers
private extension FolderViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupBackButton()
        setupDoneButton()
        setupTitleTextField()
    }
    
    func setupBackButton() {
        backButton.tintColor = Style.backButtonTintColor
        backButton.setImage(viewModel?.backButtonImage, for: .normal)
        backButton.setTitle(nil, for: .normal)
    }
    
    func setupDoneButton() {
        doneButton.tintColor = Style.doneButtonTintColor
        doneButton.titleLabel?.font = Style.doneButtonFont
        doneButton.setTitle(viewModel?.doneButtonTitle, for: .normal)
        doneButton.isEnabled = false
    }
    
    func setupTitleTextField() {
        guard let viewModel = viewModel else { return }
        titleTextField.backgroundColor = Style.titleTextFieldBackgroundColor
        titleTextField.textColor = Style.titleTextFieldTextColor
        titleTextField.tintColor = Style.titleTextFieldTintColor
        titleTextField.font = Style.titleTextFieldFont
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: viewModel.titleFieldPlaceholder,
            attributes: [
                .foregroundColor: Style.titleTextFieldPlaceholderColor,
                .font: Style.titleTextFieldPlaceholderFont
            ]
        )
        titleTextField.layer.cornerRadius = Style.titleTextFieldCornerRadius
        titleTextField.borderStyle = .none
        titleTextField.autocorrectionType = .no
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
        // Horizontal views
        let fieldViewFrame = CGRect(
            x: 0,
            y: 0,
            width: Style.titleTextFieldViewWidth,
            height: titleTextField.bounds.height
        )
        let leftView = UIView(frame: fieldViewFrame)
        titleTextField.leftView = leftView
        titleTextField.leftViewMode = .always
        let rightView = UIView(frame: fieldViewFrame)
        titleTextField.rightView = rightView
        titleTextField.rightViewMode = .always
    }
    
    @IBAction func backButtonTapped() {
        viewModel?.backButtonTapped()
    }
    
    @IBAction func doneButtonTapped() {
        viewModel?.doneButtonTapped()
    }
    
}

// MARK: - UITextFieldDelegate Methods
extension FolderViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel?.didChangeTitle(
            with: textField.text,
            newText: string,
            in: range
        ) ?? false
    }
    
}

// MARK: - FolderViewModelPresenter Methods
extension FolderViewController: FolderViewModelPresenter {
    
    var folderTitle: String? {
        return titleTextField.text
    }
    
    func updateDoneButton(isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
    }
    
    func dismiss(completion: (() -> Void)?) {
        navigationController?.dismiss(animated: true, completion: completion)
    }
    
}
