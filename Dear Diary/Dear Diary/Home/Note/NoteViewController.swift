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
    
    fileprivate struct Style {
        static let backgroundColor = Color.background.shade
        
        static let backButtonTintColor = Color.label.shade
        
        static let titleLabelTextColor = Color.secondaryLabel.shade
        static let titleLabelFont = Font.title2(.regular)
        
        static let contentTextViewBackgroundColor = UIColor.clear
        static let contentTextViewTextColor = Color.label.shade
        static let contentTextViewTintColor = Color.secondaryLabel.shade
        static let contentTextViewFont = Font.headline(.regular)
        static let contentTextViewBoldTitleFont = Font.title1(.bold)
        static let contentTextViewItalicTitleFont = Font.title1(.regularItalic)
        static let contentTextViewBoldBodyFont = Font.headline(.bold)
        static let contentTextViewItalicBodyFont = Font.headline(.regularItalic)
        static let contentTextViewBoldMonospacedFont = Font.headline(.boldMonospaced)
        static let contentTextViewItalicMonospacedFont = Font.headline(.regularItalicMonospaced)
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
        viewModel?.screenWillAppear?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.screenWillDisappear?()
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
        viewModel?.screenDidLoad?()
    }
    
    func setupBackButton() {
        backButton.tintColor = Style.backButtonTintColor
        backButton.setImage(viewModel?.backButtonImage, for: .normal)
        backButton.setTitle(nil, for: .normal)
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
    }
    
    func setupContentTextView() {
        contentTextView.backgroundColor = Style.contentTextViewBackgroundColor
        contentTextView.textColor = Style.contentTextViewTextColor
        contentTextView.tintColor = Style.contentTextViewTintColor
        contentTextView.font = Style.contentTextViewFont
        contentTextView.textContainerInset = Style.contentTextViewInset
        contentTextView.showsVerticalScrollIndicator = false
        contentTextView.delegate = self
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
    
    func setupContent(with paragraphs: [NoteParagraph]) {
        guard let viewModel = viewModel else { return }
        guard paragraphs.isEmpty else {
            let attributedContentText = NSMutableAttributedString()
            for paragraph in paragraphs {
                let attributedText = NSMutableAttributedString(string: paragraph.text)
                let font = paragraph.formatting.font
                if let paragraphFont = font.paragraphFont {
                    attributedText.addAttributes(
                        [.foregroundColor: Style.contentTextViewTextColor, .font: paragraphFont],
                        range: NSRange(location: 0, length: attributedText.length)
                    )
                }
                // Combine and sort the formatting ranges based on their starting positions
                var formattingRanges: [(range: NSRange, attributes: [NSAttributedString.Key: Any])] = []
                // Bold
                let boldRange = paragraph.formatting.boldWords.map {
                    return (
                        NSRange(location: $0.start, length: $0.end - $0.start),
                        [NSAttributedString.Key.font: font.boldContentFont]
                    )
                }
                formattingRanges.append(contentsOf: boldRange)
                // Italic
                let italicRange = paragraph.formatting.italicWords.map {
                    return (
                        NSRange(location: $0.start, length: $0.end - $0.start),
                        [NSAttributedString.Key.font: font.italicContentFont]
                    )
                }
                formattingRanges.append(contentsOf: italicRange)
                // Underline
                let underlineRange = paragraph.formatting.underlineWords.map {
                    return (
                        NSRange(location: $0.start, length: $0.end - $0.start),
                        [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
                    )
                }
                formattingRanges.append(contentsOf: underlineRange)
                // Strikethrough
                let strikethroughRange = paragraph.formatting.strikethroughWords.map {
                    return (
                        NSRange(location: $0.start, length: $0.end - $0.start),
                        [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
                    )
                }
                formattingRanges.append(contentsOf: strikethroughRange)
                formattingRanges.sort(by: { $0.range.location < $1.range.location })
                // Apply attributes to the attributed string
                formattingRanges.forEach { (range, attributes) in
                    attributedText.addAttributes(attributes, range: range)
                }
                // Apply alignment to the paragraph
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = paragraph.formatting.alignment.contentAlignment
                attributedText.addAttribute(
                    .paragraphStyle,
                    value: paragraphStyle,
                    range: NSRange(location: 0, length: attributedText.length)
                )
                attributedContentText.append(attributedText)
                // Append a new line for the next paragraph
                attributedContentText.append(NSAttributedString(string: viewModel.paragraphSeparator))
            }
            contentTextView.attributedText = attributedContentText
            return
        }
        contentTextView.text = nil
    }
    
    @IBAction func backButtonTapped() {
        viewModel?.backButtonTapped()
    }
    
}

// MARK: - UITextViewDelegate Helpers
extension NoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel?.didChangeContent(with: textView.text)
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
    
    var content: String? {
        return contentTextView.text
    }
    
    var selectedRange: NSRange {
        return contentTextView.selectedRange
    }
    
    func addKeyboardObservables() {
        addKeyboardObservers()
    }
    
    func removeKeyboardObservables() {
        removeKeyboardObservers()
    }
    
    func updateDetails(with paragraphs: [NoteParagraph]) {
        titleLabel.text = viewModel?.titleLabelText
        setupContent(with: paragraphs)
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
        contentTextView.inputView = UIView()
        contentTextView.reloadInputViews()
    }
    
    func enableKeyboard() {
        contentTextView.inputView = nil
        contentTextView.reloadInputViews()
        contentTextView.becomeFirstResponder()
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - NoteFont Helpers
private extension NoteFont {
    
    var paragraphFont: UIFont? {
        switch self {
        case .title:
            return TextFormattingOptionsViewModel.Formatting.title.font
        case .body:
            return TextFormattingOptionsViewModel.Formatting.body.font
        case .monospaced:
            return TextFormattingOptionsViewModel.Formatting.monospaced.font
        }
    }
    
    var boldContentFont: UIFont {
        switch self {
        case .title:
            return NoteViewController.Style.contentTextViewBoldTitleFont
        case .body:
            return NoteViewController.Style.contentTextViewBoldBodyFont
        case .monospaced:
            return NoteViewController.Style.contentTextViewBoldMonospacedFont
        }
    }
    
    var italicContentFont: UIFont {
        switch self {
        case .title:
            return NoteViewController.Style.contentTextViewItalicTitleFont
        case .body:
            return NoteViewController.Style.contentTextViewItalicBodyFont
        case .monospaced:
            return NoteViewController.Style.contentTextViewItalicMonospacedFont
        }
    }
    
}

// MARK: - NoteAlignment Helpers
private extension NoteAlignment {
    
    var contentAlignment: NSTextAlignment {
        switch self {
        case .left:
            return .natural
        case .center:
            return .center
        case .right:
            return .right
        }
    }
    
}
