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

protocol NoteViewModelPresenter: AnyObject {
    func addKeyboardObservables()
    func removeKeyboardObservables()
    func updateDefaultOptionsView(with height: CGFloat)
    func showTextFormattingOptionsView(_ popupView: TextFormattingOptionsView)
    func disableKeyboard()
    func enableKeyboard()
    func pop()
}

protocol NoteViewModelable {
    var backButtonImage: UIImage? { get }
    var titleLabelText: String { get }
    var defaultOptionsViewModel: FormattingOptionsViewModel { get }
    var moreOptionsViewModel: FormattingOptionsViewModel { get }
    var presenter: NoteViewModelPresenter? { get set }
    func screenWillAppear()
    func screenWillDisappear()
    func keyboardDidShow(with height: CGFloat)
    func keyboardDidHide()
    func backButtonTapped()
}

final class NoteViewModel: NoteViewModelable {
    
    private let title: String
    
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
    
    init(title: String) {
        self.title = title
    }
    
}

// MARK: - Exposed Helpers
extension NoteViewModel {
    
    var backButtonImage: UIImage? {
        return Image.back.asset
    }
    
    var titleLabelText: String {
        // TODO: Change depending on add note or edit note
        let currentDate = dateFormatter.string(from: Date())
        return "\(title) ~ \(currentDate)"
    }
    
    func screenWillAppear() {
        presenter?.addKeyboardObservables()
    }
    
    func screenWillDisappear() {
        presenter?.removeKeyboardObservables()
    }
    
    func keyboardDidShow(with height: CGFloat) {
        presenter?.updateDefaultOptionsView(with: height)
    }
    
    func keyboardDidHide() {
        presenter?.updateDefaultOptionsView(with: .zero)
    }
    
    func backButtonTapped() {
        presenter?.pop()
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
        print(formatting)
        // TODO
    }
    
}
