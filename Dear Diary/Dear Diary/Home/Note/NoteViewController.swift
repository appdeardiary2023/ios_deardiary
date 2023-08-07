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
        
        static let detailsLabelTextColor = Color.secondaryLabel.shade
        static let detailsLabelFont = Font.title2(.regular)
        
        static let titleTextViewTopInset: CGFloat = 20
        
        static let separatorViewBackgroundColor = Color.secondaryBackground.shade
        static let separatorViewTopInset: CGFloat = 15
        static let separatorViewHeight: CGFloat = 2
        
        static let noteTextViewTopInset: CGFloat = 10
        static let noteTextViewBottomInset: CGFloat = 30

        static let textViewBackgroundColor = UIColor.clear
        static let textViewTextColor = Color.label.shade
        static let textViewTintColor = Color.secondaryLabel.shade
        static let textViewContainerInset = UIEdgeInsets()
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var detailsLabel: UILabel!
    
    private lazy var titleTextView: NotesTextView = {
        let view = NotesTextView(textStyle: .title)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Style.textViewBackgroundColor
        view.tintColor = Style.textViewTintColor
        view.textContainerInset = Style.textViewContainerInset
        view.hostingViewController = self
        view.isScrollEnabled = false
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Style.separatorViewBackgroundColor
        view.layer.cornerRadius = Style.separatorViewHeight / 2
        return view
    }()
    
    private lazy var noteTextView: NotesTextView = {
        let view = NotesTextView(textStyle: .body)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Style.textViewBackgroundColor
        view.tintColor = Style.textViewTintColor
        view.textContainerInset = Style.textViewContainerInset
        view.shouldAdjustInsetBasedOnKeyboardHeight = true
        view.hostingViewController = self
        _ = view.becomeFirstResponder()
        return view
    }()
        
    var viewModel: NoteViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

// MARK: - Private Helpers
private extension NoteViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupBackButton()
        setupDetailsLabel()
        addTitleTextView()
        addSeparatorView()
        addNoteTextView()
        viewModel?.screenDidLoad?()
    }
    
    func setupBackButton() {
        backButton.tintColor = Style.backButtonTintColor
        backButton.setImage(viewModel?.backButtonImage, for: .normal)
        backButton.setTitle(nil, for: .normal)
    }
    
    func setupDetailsLabel() {
        detailsLabel.textColor = Style.detailsLabelTextColor
        detailsLabel.font = Style.detailsLabelFont
    }
    
    func addTitleTextView() {
        view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints {
            $0.top.equalTo(detailsLabel.snp.bottom).inset(-Style.titleTextViewTopInset)
            $0.leading.trailing.equalTo(detailsLabel)
        }
    }
    
    func addSeparatorView() {
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).inset(-Style.separatorViewTopInset)
            $0.leading.trailing.equalTo(detailsLabel)
            $0.height.equalTo(Style.separatorViewHeight)
        }
    }

    func addNoteTextView() {
        view.addSubview(noteTextView)
        noteTextView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).inset(-Style.noteTextViewTopInset)
            $0.leading.trailing.equalTo(detailsLabel)
            $0.bottom.equalToSuperview().inset(Style.noteTextViewBottomInset)
        }
    }
    
    @IBAction func backButtonTapped() {
        viewModel?.backButtonTapped()
    }
    
}

// MARK: - NoteViewModelPresenter Methods
extension NoteViewController: NoteViewModelPresenter {
    
    var noteTitle: NSAttributedString? {
        return titleTextView.attributedText
    }
    
    var noteContent: NSAttributedString? {
        return noteTextView.attributedText
    }
    
    func updateDetails(with details: String) {
        detailsLabel.text = details
    }
    
    func updateTitle(with title: String) {
        guard let font = titleTextView.font else { return }
        titleTextView.attributedText = NSAttributedString(
            string: title,
            attributes: [.font: font]
        )
    }
    
    func updateTitle(with attributedText: NSAttributedString?) {
        titleTextView.attributedText = attributedText
    }
    
    func updateContent(with attributedText: NSAttributedString?) {
        noteTextView.attributedText = attributedText
    }
    
    func popOrDismiss(completion: (() -> Void)?) {
        guard let navigationController = navigationController else {
            dismiss(animated: true, completion: completion)
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.popViewController(animated: true)
        CATransaction.commit()
    }
    
}
