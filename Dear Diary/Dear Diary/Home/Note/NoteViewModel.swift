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
import SDWebImage

protocol NoteViewModelListenable: AnyObject {
    func noteSelected(_ note: Note, listener: NoteViewModelListener?)
}

protocol NoteViewModelListener: AnyObject {
    func noteAdded(_ note: Note, needsDataSourceUpdate: Bool)
    func noteEdited(replacing note: Note, with editedNote: Note?, needsDataSourceUpdate: Bool)
    func deleteNote(_ note: Note, needsDataSourceUpdate: Bool)
}

protocol NoteViewModelPresenter: AnyObject {
    func updateDetails(with details: String)
    func openImagePickerScreen()
    func getNoteDetails(at indexPath: IndexPath) -> NSAttributedString?
    func insertSections(_ sections: IndexSet)
    func deleteSections(_ sections: IndexSet)
    func reloadSections(_ sections: IndexSet)
    func reload()
    func present(_ viewController: UIViewController)
    func popOrDismiss(completion: (() -> Void)?)
}

protocol NoteViewModelable: ViewLifecyclable {
    var backButtonImage: UIImage? { get }
    var sections: [NoteViewModel.Section] { get }
    var presenter: NoteViewModelPresenter? { get set }
    func backButtonTapped()
    func imageSelected(_ image: UIImage)
    func showShareActivity(with text: String)
    func getImageCellViewModel(at indexPath: IndexPath) -> NoteImageCellViewModelable?
    func getDetailsCellViewModel(at indexPath: IndexPath, viewController: NoteViewController?) -> NoteDetailsCellViewModelable?
    func didSelectRow(at indexPath: IndexPath)
}

final class NoteViewModel: NoteViewModelable {
    
    enum Flow {
        case add(id: String, date: Date, number: Int)
        case edit(note: Note)
    }
    
    enum Section: Int {
        case image
        case title
        case content
    }
    
    private let flow: Flow
    private let folderTitle: String
    private var noteTimer: Timer?
    /// Keeps track of updated attachment, title and content
    private var localNote: Note?
    private weak var listener: NoteViewModelListener?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Note.dateFormat
        return formatter
    }()
    
    private(set) var sections: [Section]
    
    weak var presenter: NoteViewModelPresenter?
    
    init(flow: Flow, folderTitle: String, listener: NoteViewModelListener?) {
        self.sections = [.title, .content]
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
        addImageSection()
        // Important method call, this sets local note
        scheduleNoteTimer()
        addAppLifecycleObservers()
        presenter?.reload()
    }
    
    func backButtonTapped() {
        saveNote(isTerminating: false)
    }
    
    func imageSelected(_ image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first,
              let imageData = image.jpegData(compressionQuality: 1) else { return }
        let imageUrl: URL
        switch flow {
        case let .add(id, _, _):
            imageUrl = documentsDirectory.appendingPathComponent(id)
        case let .edit(note):
            imageUrl = documentsDirectory.appendingPathComponent(note.id)
        }
        try? imageData.write(to: imageUrl)
        localNote?.attachment = imageUrl.absoluteString
        // Insert section if it doesn't exist
        let index = Section.image.rawValue
        let indexSet = IndexSet(integer: index)
        guard sections.contains(.image) else {
            sections.insert(.image, at: index)
            presenter?.insertSections(indexSet)
            return
        }
        // Reload image section
        presenter?.reloadSections(indexSet)
    }
    
    func showShareActivity(with text: String) {
        var activityItems = [Any]()
        text.isEmpty ? () : activityItems.append(text)
        guard let imageUrl = localNote?.attachmentUrl else {
            showShareActivity(with: activityItems)
            return
        }
        SDWebImageDownloader.shared.downloadImage(with: imageUrl) { [weak self] (image, _, _, _) in
            guard let image = image else { return }
            activityItems.append(image)
            self?.showShareActivity(with: activityItems)
        }
    }
    
    func getImageCellViewModel(at indexPath: IndexPath) -> NoteImageCellViewModelable? {
        return NoteImageCellViewModel(
            imageUrl: localNote?.attachmentUrl,
            listener: self
        )
    }
    
    func getDetailsCellViewModel(at indexPath: IndexPath, viewController: NoteViewController?) -> NoteDetailsCellViewModelable? {
        guard let section = sections[safe: indexPath.section] else { return nil }
        let dependency: NoteDetailsCellViewModel.Dependency
        switch section {
        case .image:
            return nil
        case .title:
            switch flow {
            case let .add(_, _, number):
                let title = "\(Strings.Note.note) \(number)"
                dependency = NoteDetailsCellViewModel.Dependency(
                    textStyle: .title,
                    text: title,
                    adjustsContentWithKeyboard: false,
                    isFirstResponder: false,
                    parentViewController: viewController
                )
            case .edit:
                dependency = NoteDetailsCellViewModel.Dependency(
                    textStyle: .title,
                    attributedText: localNote?.title?.toAttributedString,
                    adjustsContentWithKeyboard: false,
                    isFirstResponder: false,
                    parentViewController: viewController
                )
            }
        case .content:
            switch flow {
            case .add:
                dependency = NoteDetailsCellViewModel.Dependency(
                    textStyle: .body,
                    adjustsContentWithKeyboard: true,
                    isFirstResponder: true,
                    parentViewController: viewController
                )
            case .edit:
                dependency = NoteDetailsCellViewModel.Dependency(
                    textStyle: .body,
                    attributedText: localNote?.content?.toAttributedString,
                    adjustsContentWithKeyboard: true,
                    isFirstResponder: true,
                    parentViewController: viewController
                )
            }
        }
        return NoteDetailsCellViewModel(dependency: dependency)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let section = sections[safe: indexPath.section] else { return }
        switch section {
        case .image:
            presenter?.openImagePickerScreen()
        case .title, .content:
            // Not applicable
            return
        }
    }
    
}

// MARK: - Private Helpers
private extension NoteViewModel {
    
    func updateDetails() {
        let creationDate: String
        switch flow {
        case let .add(_, date, _):
            creationDate = dateFormatter.string(from: date)
        case let .edit(note):
            let date = Date(timeIntervalSince1970: note.creationTime)
            creationDate = dateFormatter.string(from: date)
        }
        let title = "\(folderTitle) ~ \(creationDate)"
        presenter?.updateDetails(with: title)
    }
    
    func addImageSection() {
        switch flow {
        case .add:
            return
        case let .edit(note):
            guard note.attachment != nil else { return }
            sections.insert(.image, at: 0)
        }
    }
    
    func scheduleNoteTimer() {
        switch flow {
        case let .add(id, date, _):
            localNote = Note(id: id, creationTime: date.timeIntervalSince1970)
        case let .edit(note):
            localNote = note
        }
        let timer = Timer.scheduledTimer(
            withTimeInterval: Constants.Note.editSaveTimeInterval,
            repeats: true
        ) { [weak self] timer in
            guard timer.isValid else { return }
            // Update note after every 10 seconds
            self?.updateNoteLocally()
        }
        RunLoop.main.add(timer, forMode: .common)
        noteTimer = timer
    }
    
    func updateNoteLocally() {
        for (index, section) in sections.enumerated() {
            switch section {
            case .image:
                continue
            case .title:
                let indexPath = IndexPath(row: 0, section: index)
                localNote?.title = presenter?.getNoteDetails(at: indexPath)?.toData
            case .content:
                let indexPath = IndexPath(row: 0, section: index)
                localNote?.content = presenter?.getNoteDetails(at: indexPath)?.toData
            }
        }
    }
    
    func showShareActivity(with activityItems: [Any]) {
        let viewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        // TODO: - Manage popover presentation in case of iPad
        presenter?.present(viewController)
    }
    
    func saveNote(isTerminating: Bool) {
        updateNoteLocally()
        guard let title = localNote?.title?.toAttributedString,
              let content = localNote?.content?.toAttributedString else {
            isTerminating ? () : presenter?.popOrDismiss(completion: nil)
            return
        }
        switch flow {
        case let .add(id, date, _):
            guard title.string.isEmpty
                    && content.string.isEmpty
                    && localNote?.attachment == nil else {
                destroyNoteTimer()
                let newNote = Note(
                    id: id,
                    title: title.toData,
                    content: content.toData,
                    attachment: localNote?.attachment,
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
            guard title.string.isEmpty
                    && content.string.isEmpty
                    && localNote?.attachment == nil else {
                destroyNoteTimer()
                isTerminating
                    ? listener?.noteEdited(
                        replacing: note,
                        with: localNote,
                        needsDataSourceUpdate: false
                    )
                    : presenter?.popOrDismiss { [weak self] in
                        self?.listener?.noteEdited(
                            replacing: note,
                            with: self?.localNote,
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
    
    func destroyNoteTimer() {
        noteTimer?.invalidate()
        noteTimer = nil
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

// MARK: - NoteImageCellViewModelListener Methods
extension NoteViewModel: NoteImageCellViewModelListener {
    
    func deleteButtonTapped() {
        // Delete image section
        let index = Section.image.rawValue
        let indexSet = IndexSet(integer: index)
        sections.remove(at: index)
        localNote?.attachment = nil
        presenter?.deleteSections(indexSet)
    }
    
}
