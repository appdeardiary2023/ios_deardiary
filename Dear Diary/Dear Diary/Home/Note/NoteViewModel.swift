//
//  NoteViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 25/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import DearDiaryStrings
import DearDiaryImages

protocol NoteViewModelListener: AnyObject {
    func noteAdded(_ note: NoteModel, needsDataSourceUpdate: Bool)
    func noteEdited(replacing note: NoteModel, with editedNote: NoteModel?, needsDataSourceUpdate: Bool)
    func deleteNote(_ note: NoteModel, needsDataSourceUpdate: Bool)
}

protocol NoteViewModelPresenter: AnyObject {
    var noteTitle: NSAttributedString? { get }
    var noteContent: NSAttributedString? { get }
    func updateDetails(with details: String)
    func updateTitle(with title: String)
    func updateTitle(with attributedText: NSAttributedString?)
    func updateContent(with attributedText: NSAttributedString?)
    func popOrDismiss(completion: (() -> Void)?)
}

protocol NoteViewModelable: ViewLifecyclable {
    var backButtonImage: UIImage? { get }
    var presenter: NoteViewModelPresenter? { get set }
    func backButtonTapped()
}

final class NoteViewModel: NoteViewModelable {
    
    enum Flow {
        case add(date: Date, number: Int)
        case edit(note: NoteModel)
    }
    
    private let flow: Flow
    private let folderTitle: String
    private var editTimer: Timer?
    private var editedNote: NoteModel?
    private weak var listener: NoteViewModelListener?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Note.dateFormat
        return formatter
    }()

    weak var presenter: NoteViewModelPresenter?
    
    init(flow: Flow, folderTitle: String, listener: NoteViewModelListener?) {
        self.flow = flow
        self.folderTitle = folderTitle
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension NoteViewModel {
    
    var backButtonImage: UIImage? {
        return Image.back.asset
    }
    
    func screenDidLoad() {
        updateDetails()
        updateTitleAndContent()
        scheduleEditTimer()
        addAppLifecycleObservers()
    }
    
    func backButtonTapped() {
        saveNote(isTerminating: false)
    }
    
}

// MARK: - Private Helpers
private extension NoteViewModel {
    
    func updateDetails() {
        let creationDate: String
        switch flow {
        case let .add(date, _):
            creationDate = dateFormatter.string(from: date)
        case let .edit(note):
            let date = Date(timeIntervalSince1970: note.creationTime)
            creationDate = dateFormatter.string(from: date)
        }
        let title = "\(folderTitle) ~ \(creationDate)"
        presenter?.updateDetails(with: title)
    }
    
    func updateTitleAndContent() {
        switch flow {
        case let .add(_, number):
            let title = "\(Strings.Note.note) \(number)"
            presenter?.updateTitle(with: title)
        case let .edit(note):
            presenter?.updateTitle(with: note.title?.toAttributedString)
            presenter?.updateContent(with: note.content?.toAttributedString)
        }
    }
    
    func updateNoteLocally() {
        switch flow {
        case .add:
            // Not applicable
            return
        case .edit:
            editedNote?.title = presenter?.noteTitle?.toData
            editedNote?.content = presenter?.noteContent?.toData
        }
    }
    
    func scheduleEditTimer() {
        switch flow {
        case .add:
            // Not applicable
            return
        case let .edit(note):
            editedNote = note
            let timer = Timer.scheduledTimer(
                withTimeInterval: Constants.Note.editSaveTimeInterval,
                repeats: true
            ) { [weak self] timer in
                guard timer.isValid else { return }
                // Update note after every 10 seconds
                self?.updateNoteLocally()
            }
            RunLoop.main.add(timer, forMode: .common)
            editTimer = timer
        }
    }
    
    func saveNote(isTerminating: Bool) {
        guard let title = presenter?.noteTitle,
              let content = presenter?.noteContent else {
            isTerminating ? () : presenter?.popOrDismiss(completion: nil)
            return
        }
        switch flow {
        case let .add(date, _):
            guard title.string.isEmpty && content.string.isEmpty else {
                // TODO: - Handle attachment later
                let newNote = NoteModel(
                    id: UUID().uuidString,
                    title: title.toData,
                    content: content.toData,
                    attachment: nil,
                    creationTime: date.timeIntervalSince1970 // In seconds
                )
                isTerminating
                    ? listener?.noteAdded(newNote, needsDataSourceUpdate: false)
                    : presenter?.popOrDismiss { [weak self] in
                        self?.listener?.noteAdded(newNote, needsDataSourceUpdate: true)
                    }
                return
            }
            // Don't add an empty note
            isTerminating ? () : presenter?.popOrDismiss(completion: nil)
        case let .edit(note):
            guard title.string.isEmpty && content.string.isEmpty else {
                updateNoteLocally()
                destroyEditTimer()
                isTerminating
                    ? listener?.noteEdited(
                        replacing: note,
                        with: editedNote,
                        needsDataSourceUpdate: false
                    )
                    : presenter?.popOrDismiss { [weak self] in
                        self?.listener?.noteEdited(
                            replacing: note,
                            with: self?.editedNote,
                            needsDataSourceUpdate: true
                        )
                    }
                return
            }
            // Delete the empty note
            isTerminating
                ? listener?.deleteNote(note, needsDataSourceUpdate: false)
                : presenter?.popOrDismiss { [weak self] in
                    self?.listener?.deleteNote(note, needsDataSourceUpdate: true)
                }
        }
    }
    
    func destroyEditTimer() {
        editTimer?.invalidate()
        editTimer = nil
    }
        
}

// MARK: - AppLifecyclable Methods
extension NoteViewModel: AppLifecyclable {
    
    func applicationEnteredBackground() {}
    
    func applicationWillEnterForeground() {}
    
    func applicationWillTerminate() {
        // Save note in the current state
        saveNote(isTerminating: true)
        removeAppLifecycleObservers()
    }
    
}
