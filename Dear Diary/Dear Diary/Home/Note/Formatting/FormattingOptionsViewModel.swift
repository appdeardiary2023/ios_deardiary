//
//  FormattingOptionsViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 27/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages

protocol FormattingOptionsViewModelListener: AnyObject {
    func optionDeselected(_ option: FormattingOptionsViewModel.Option?)
    func optionSelected(_ option: FormattingOptionsViewModel.Option)
}

protocol FormattingOptionsViewModelPresenter: AnyObject {
    func deselectOption(_ option: FormattingOptionsViewModel.Option?)
    func selectOption(_ option: FormattingOptionsViewModel.Option)
}

protocol FormattingOptionsViewModelable {
    var flow: FormattingOptionsViewModel.Flow { get }
    var presenter: FormattingOptionsViewModelPresenter? { get set }
    func optionButtonTapped(with tag: Int)
}

final class FormattingOptionsViewModel: FormattingOptionsViewModelable {
    
    enum Flow {
        case `default`
        case more
    }
    
    enum Option: Int {
        case text
        case extras
        case copy
        case lock
    }
    
    let flow: Flow
    weak var presenter: FormattingOptionsViewModelPresenter?
    
    private var selectedOption: Option?
    private weak var listener: FormattingOptionsViewModelListener?
    
    init(flow: Flow, listener: FormattingOptionsViewModelListener?) {
        self.flow = flow
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension FormattingOptionsViewModel {
    
    func optionButtonTapped(with tag: Int) {
        guard let option = Option(rawValue: tag) else { return }
        guard selectedOption == option else {
            // Deselect current option
            deselectCurrentOption()
            // Select new option
            presenter?.selectOption(option)
            listener?.optionSelected(option)
            selectedOption = option
            return
        }
        // Deselect current option
        deselectCurrentOption()
    }
    
    func deselectCurrentOption() {
        presenter?.deselectOption(selectedOption)
        listener?.optionDeselected(selectedOption)
        selectedOption = nil
    }
    
}

// MARK: - FormattingOptionsViewModel.Flow Helpers
extension FormattingOptionsViewModel.Flow {
    
    var options: [FormattingOptionsViewModel.Option] {
        switch self {
        case .default:
            return [.text, .extras]
        case .more:
            return [.copy, .lock]
        }
    }
    
}

// MARK: - FormattingOptionsViewModel.Option Helpers
extension FormattingOptionsViewModel.Option {
    
    var title: String? {
        switch self {
        case .text:
            return Strings.Note.textFormatting
        case .extras, .copy, .lock:
            return nil
        }
    }
    
    var image: UIImage? {
        switch self {
        case .text:
            return nil
        case .extras:
            return Image.extras.asset
        case .copy:
            return Image.copy.asset
        case .lock:
            return Image.lock.asset
        }
    }
    
}
