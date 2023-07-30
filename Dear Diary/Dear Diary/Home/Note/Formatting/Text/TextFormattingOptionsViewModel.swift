//
//  TextFormattingOptionsViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 27/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages

protocol TextFormattingOptionsViewModelListener: AnyObject {
    func willRemoveFromParentView()
    func formattingSelected(_ formatting: TextFormattingOptionsViewModel.Formatting)
}

protocol TextFormattingOptionsViewModelPresenter: AnyObject {
    func removeFromParentView()
    func deselectFormatting(_ formatting: TextFormattingOptionsViewModel.Formatting)
    func selectFormatting(_ formatting: TextFormattingOptionsViewModel.Formatting)
}

protocol TextFormattingOptionsViewModelable {
    var formatLabelText: String { get }
    var closeButtonImage: UIImage? { get }
    var formattings: [TextFormattingOptionsViewModel.Formatting] { get }
    var presenter: TextFormattingOptionsViewModelPresenter? { get set }
    func closeButtonTapped()
    func formattingButtonTapped(with tag: Int)
}

final class TextFormattingOptionsViewModel: TextFormattingOptionsViewModelable {
    
    enum Formatting: Int, CaseIterable {
        case title
        case body
        case monospaced
        case bold
        case italic
        case underline
        case strikethrough
        case bulletList
        case numberList
        case leftAlign
        case centerAlign
        case rightAlign
    }
    
    let formattings: [Formatting]
    weak var presenter: TextFormattingOptionsViewModelPresenter?
    
    private weak var listener: TextFormattingOptionsViewModelListener?
    
    init(listener: TextFormattingOptionsViewModelListener?) {
        self.formattings = Formatting.allCases
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension TextFormattingOptionsViewModel {
    
    var formatLabelText: String {
        return Strings.Note.Text.format
    }
    
    var closeButtonImage: UIImage? {
        return Image.close.asset
    }
    
    func closeButtonTapped() {
        listener?.willRemoveFromParentView()
        presenter?.removeFromParentView()
    }
    
    func formattingButtonTapped(with tag: Int) {
        guard let formatting = Formatting(rawValue: tag) else { return }
        listener?.formattingSelected(formatting)
    }
    
}

// MARK: - TextFormattingOptionsViewModel.Formatting Helpers
extension TextFormattingOptionsViewModel.Formatting {
    
    var title: String? {
        switch self {
        case .title:
            return Strings.Note.Text.title
        case .body:
            return Strings.Note.Text.body
        case .monospaced:
            return Strings.Note.Text.monospaced
        case .bold:
            return Strings.Note.Text.bold
        case .italic:
            return Strings.Note.Text.italic
        case .underline:
            return Strings.Note.Text.underline
        case .strikethrough:
            return Strings.Note.Text.strikethrough
        case .bulletList, .numberList, .leftAlign, .centerAlign, .rightAlign:
            return nil
        }
    }
    
    var image: UIImage? {
        switch self {
        case .title, .body, .monospaced, .bold, .italic, .underline, .strikethrough:
            return nil
        case .bulletList:
            return Image.bulletList.asset
        case .numberList:
            return Image.numberList.asset
        case .leftAlign:
            return Image.leftAlign.asset
        case .centerAlign:
            return Image.centerAlign.asset
        case .rightAlign:
            return Image.rightAlign.asset
        }
    }
    
}
