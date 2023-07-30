//
//  NoteViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 25/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import DearDiaryImages

protocol NoteViewModelListener: AnyObject {
    func noteAdded(with text: String)
    func noteEdited(with id: String, text: String)
}

protocol NoteViewModelPresenter: AnyObject {
    var content: String? { get }
    var selectedRange: NSRange { get }
    func addKeyboardObservables()
    func removeKeyboardObservables()
    func updateDetails(with paragraphs: [NoteParagraph])
    func updateDefaultOptionsView(with height: CGFloat)
    func showTextFormattingOptionsView(_ popupView: TextFormattingOptionsView)
    func disableKeyboard()
    func enableKeyboard()
    func pop()
}

protocol NoteViewModelable: ViewLifecyclable {
    var backButtonImage: UIImage? { get }
    var titleLabelText: String? { get }
    var paragraphSeparator: String { get }
    var defaultOptionsViewModel: FormattingOptionsViewModel { get }
    var moreOptionsViewModel: FormattingOptionsViewModel { get }
    var presenter: NoteViewModelPresenter? { get set }
    func didChangeContent(with text: String)
    func keyboardDidShow(with height: CGFloat)
    func keyboardDidHide()
    func backButtonTapped()
}

final class NoteViewModel: NoteViewModelable,
                           JSONable {
    
    enum Flow {
        case add
        case edit(note: NoteModel)
    }
    
    private let flow: Flow
    private let title: String
    private var details: NoteDetails?
    /// Map to keep a track of updated content in the text view corresponding to its paragraph number
    private var paragraphsDict: [Int: NoteParagraph]
    private weak var listener: NoteViewModelListener?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Note.dateFormat
        return formatter
    }()
    
    lazy var defaultOptionsViewModel: FormattingOptionsViewModel = {
        return FormattingOptionsViewModel(flow: .default, listener: self)
    }()
    
    lazy var moreOptionsViewModel: FormattingOptionsViewModel = {
        return FormattingOptionsViewModel(flow: .more, listener: self)
    }()
    
    weak var presenter: NoteViewModelPresenter?
    
    init(flow: Flow, title: String, listener: NoteViewModelListener?) {
        self.flow = flow
        self.title = title
        self.paragraphsDict = [:]
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension NoteViewModel {
    
    var backButtonImage: UIImage? {
        return Image.back.asset
    }
    
    var titleLabelText: String? {
        let creationDate: String
        switch flow {
        case .add:
            creationDate = dateFormatter.string(from: Date())
        case .edit:
            guard let time = details?.creationTime else { return nil }
            let date = Date(timeIntervalSince1970: time)
            creationDate = dateFormatter.string(from: date)
        }
        return "\(title) ~ \(creationDate)"
    }
    
    var paragraphSeparator: String {
        return Constants.Note.paragraphSeparator
    }
    
    var contentParagraphs: [NoteParagraph]? {
        return details?.paragraphs
    }
    
    func screenDidLoad() {
        fetchNoteDetails()
    }
    
    func screenWillAppear() {
        presenter?.addKeyboardObservables()
    }
    
    func screenWillDisappear() {
        presenter?.removeKeyboardObservables()
    }
    
    func didChangeContent(with text: String) {
        // Remove all text from existing paragraphs and preserve formatting
        paragraphsDict.forEach { (index, paragraph) in
            paragraphsDict[index] = NoteParagraph(
                text: String(),
                formatting: paragraph.formatting
            )
        }
        let paragraphs = text.components(separatedBy: paragraphSeparator)
        // Reset paragraphs
        paragraphs.enumerated().forEach { (index, paragraph) in
            if !paragraph.isEmpty {
                if paragraphsDict[index] == nil {
                    paragraphsDict[index] = NoteParagraph.emptyObject
                }
                paragraphsDict[index]?.text = paragraph
            }
        }
//        paragraphsDict = paragraphsDict.filter { !$1.text.isEmpty }
    }
    
    func keyboardDidShow(with height: CGFloat) {
        presenter?.updateDefaultOptionsView(with: height)
    }
    
    func keyboardDidHide() {
        presenter?.updateDefaultOptionsView(with: .zero)
    }
    
    func backButtonTapped() {
        // TODO: - Correct logic
        if let text = presenter?.content,
           !text.isEmpty {
            switch flow {
            case .add:
                listener?.noteAdded(with: text)
            case let .edit(note):
                listener?.noteEdited(with: note.id, text: text)
            }
        }
        presenter?.pop()
    }
    
}

// MARK: - Private Helpers
private extension NoteViewModel {
    
    func fetchNoteDetails() {
        switch flow {
        case .add:
            presenter?.updateDetails(with: [])
        case let .edit(note):
            guard note.isMockRequest else {
                let paragraph = NoteParagraph(
                    text: note.text ?? String(),
                    formatting: NoteParagraph.emptyObject.formatting
                )
                let details = NoteDetails(
                    id: note.id,
                    title: String(),
                    paragraphs: [paragraph],
                    attachment: note.attachment,
                    creationTime: note.creationTime
                )
                self.details = details
                presenter?.updateDetails(with: details.paragraphs)
                return
            }
            fetchData(for: .noteDetails) { [weak self] (details: NoteDetails) in
                self?.details = details
                details.paragraphs.enumerated().forEach { (index, paragraph) in
                    self?.paragraphsDict[index] = paragraph
                }
                self?.presenter?.updateDetails(with: details.paragraphs)
            }
        }
    }
    
}

// MARK: - FormattingOptionsViewModelListener Methods
extension NoteViewModel: FormattingOptionsViewModelListener {
    
    func optionDeselected(_ option: FormattingOptionsViewModel.Option?) {
        // TODO
        presenter?.enableKeyboard()
    }
    
    func optionSelected(_ option: FormattingOptionsViewModel.Option) {
        presenter?.disableKeyboard()
        switch option {
        case .text:
            let viewModel = TextFormattingOptionsViewModel(listener: self)
            let view = TextFormattingOptionsView.loadFromNib()
            view.viewModel = viewModel
            viewModel.presenter = view
            presenter?.showTextFormattingOptionsView(view)
        case .extras:
            // TODO
            return
        case .copy:
            // TODO
            return
        case .lock:
            // TODO
            return
        }
    }
    
}

// MARK: - TextFormattingOptionsViewModelListener Methods
extension NoteViewModel: TextFormattingOptionsViewModelListener {
    
    func willRemoveFromParentView() {
        defaultOptionsViewModel.deselectCurrentOption()
        presenter?.enableKeyboard()
    }
    
    func formattingSelected(_ formatting: TextFormattingOptionsViewModel.Formatting) {
        // TODO
//        print(presenter?.selectedRange)
//        guard let text = presenter?.content,
//              let range = presenter?.selectedRange else { return }
//        var paragraphIndices = [Int]()
//        paragraphsDict.forEach { (key, value) in
//
//        }
//        text.components(separatedBy: paragraphSeparator).count - 1
//        print(paragraphIndex)
//        guard range.upperBound > 0 else {
//            // Apply paragraph level attributes
//
//            return
//        }
//        // Apply text level attributes
    }
    
}
