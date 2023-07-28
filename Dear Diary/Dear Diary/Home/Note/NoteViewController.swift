//
//  NoteViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 25/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import SnapKit

final class NoteViewController: UIViewController,
                                ViewLoadable {
    
    static let name = Constants.Home.storyboardName
    static let identifier = Constants.Home.noteViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let backButtonTintColor = Color.label.shade
        
        static let titleLabelTextColor = Color.secondaryLabel.shade
        static let titleLabelFont = Font.title2(.regular)
        
        static let contentTextViewBackgroundColor = UIColor.clear
        static let contentTextViewTextColor = Color.label.shade
        static let contentTextViewTintColor = Color.secondaryLabel.shade
        static let contentTextViewFont = Font.headline(.regular)
        static let contentTextViewInset = UIEdgeInsets()
        
        static let defaultOptionsViewBottomInset: CGFloat = 30
        
        static let keyboardBottomOffset: CGFloat = 30
        
        static let animationDuration = Constants.Animation.defaultDuration
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var contentTextViewBottomConstraint: NSLayoutConstraint!
    
    private lazy var defaultOptionsView: FormattingOptionsView = {
        let viewModel = viewModel?.defaultOptionsViewModel
        let view = FormattingOptionsView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        viewModel?.presenter = view
        return view
    }()
    
    private var defaultOptionsViewBottomConstraint: Constraint?
        
    var viewModel: NoteViewModelable?

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
private extension NoteViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupBackButton()
        setupTitleLabel()
        setupContentTextView()
        addDefaultFormattingOptionsView()
    }
    
    func setupBackButton() {
        backButton.tintColor = Style.backButtonTintColor
        backButton.setImage(viewModel?.backButtonImage, for: .normal)
        backButton.setTitle(nil, for: .normal)
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
        titleLabel.text = viewModel?.titleLabelText
    }
    
    func setupContentTextView() {
        contentTextView.backgroundColor = Style.contentTextViewBackgroundColor
        contentTextView.textColor = Style.contentTextViewTextColor
        contentTextView.tintColor = Style.contentTextViewTintColor
        contentTextView.font = Style.contentTextViewFont
        // TODO: Change depending on add note or edit note
        contentTextView.text = nil
        contentTextView.textContainerInset = Style.contentTextViewInset
        contentTextView.keyboardDismissMode = .onDrag
        contentTextView.showsVerticalScrollIndicator = false
        contentTextView.becomeFirstResponder()
    }
    
    func addDefaultFormattingOptionsView() {
        view.addSubview(defaultOptionsView)
        defaultOptionsView.snp.makeConstraints {
            defaultOptionsViewBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide)
                .inset(Style.defaultOptionsViewBottomInset)
                .constraint
            $0.centerX.equalToSuperview()
        }
    }
    
    @IBAction func backButtonTapped() {
        viewModel?.backButtonTapped()
    }
    
}

// MARK: - KeyboardObservable Helpers
extension NoteViewController: KeyboardObservable {
    
    var layoutableConstraint: NSLayoutConstraint {
        return contentTextViewBottomConstraint
    }
   
    var layoutableView: UIView? {
        return view
    }
    
    var constraintOffset: CGFloat {
        return Style.keyboardBottomOffset + additionalOffset
    }
    
    var additionalOffset: CGFloat {
        return Style.defaultOptionsViewBottomInset + defaultOptionsView.bounds.height
    }
    
    var layoutDelegate: KeyboardLayoutDelegate? {
        return self
    }
    
}

// MARK: - KeyboardLayoutDelegate Helpers
extension NoteViewController: KeyboardLayoutDelegate {
    
    func keyboardDidShow(with height: CGFloat) {
        viewModel?.keyboardDidShow(with: height)
    }
    
    func keyboardDidHide() {
        viewModel?.keyboardDidHide()
    }
    
}

// MARK: - NoteViewModelPresenter Methods
extension NoteViewController: NoteViewModelPresenter {
    
    func addKeyboardObservables() {
        addKeyboardObservers()
    }
    
    func removeKeyboardObservables() {
        removeKeyboardObservers()
    }
    
    func updateDefaultOptionsView(with height: CGFloat) {
        let bottomInset = height.isZero ? Style.defaultOptionsViewBottomInset : height
        defaultOptionsViewBottomConstraint?.update(inset: bottomInset)
    }
    
    func showTextFormattingOptionsView(_ popupView: TextFormattingOptionsView) {
        view.addSubview(popupView)
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func disableKeyboard() {
        contentTextView.resignFirstResponder()
    }
    
    func enableKeyboard() {
        contentTextView.becomeFirstResponder()
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
}
