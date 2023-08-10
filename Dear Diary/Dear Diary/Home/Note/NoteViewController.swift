//
//  NoteViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 25/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class NoteViewController: ImagePickerViewController,
                                ViewLoadable {
    
    static let name = Constants.Home.storyboardName
    static let identifier = Constants.Home.noteViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let backButtonTintColor = Color.label.shade
        
        static let detailsLabelTextColor = Color.secondaryLabel.shade
        static let detailsLabelFont = Font.title2(.regular)
                
        static let tableViewBackgroundColor = UIColor.clear
        static let contentCellHeightMultiplier: CGFloat = 0.8
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
            
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
        setupTableView()
        setupImageSelection()
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
    
    func setupTableView() {
        tableView.backgroundColor = Style.tableViewBackgroundColor
        tableView.separatorStyle = .none
        tableView.register(
            NoteDetailsTableViewCell.self,
            forCellReuseIdentifier: NoteDetailsTableViewCell.reuseId
        )
        NoteImageTableViewCell.register(for: tableView)
    }
    
    func setupImageSelection() {
        onImageSelected = { [weak self] image in
            self?.viewModel?.imageSelected(image)
        }
    }
    
    @IBAction func backButtonTapped() {
        viewModel?.backButtonTapped()
    }
    
}

// MARK: - NotesExtrasDelegate Methods
extension NoteViewController: NotesExtrasDelegate {
    
    func showImagePickerScreen() {
        openImagePicker()
    }
    
    func showShareActivity(with text: String) {
        viewModel?.showShareActivity(with: text)
    }
    
}

// MARK: - UITableViewDelegate Methods
extension NoteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight = UITableView.automaticDimension
        guard let section = viewModel?.sections[safe: indexPath.section] else { return defaultHeight }
        switch section {
        case .image:
            return defaultHeight
        case .title:
            guard let cellViewModel = viewModel?.getDetailsCellViewModel(
                at: indexPath,
                viewController: self
            ) else { return defaultHeight }
            return NoteDetailsTableViewCell.calculateHeight(
                with: cellViewModel,
                width: tableView.bounds.width
            )
        case .content:
            return Style.contentCellHeightMultiplier * tableView.bounds.height
        }
    }
    
}

// MARK: - UITableViewDataSource Methods
extension NoteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel?.sections[safe: indexPath.section] else { return UITableViewCell() }
        switch section {
        case .image:
            guard let cellViewModel = viewModel?.getImageCellViewModel(at: indexPath) else { return UITableViewCell() }
            let imageCell = NoteImageTableViewCell.deque(from: tableView, at: indexPath)
            imageCell.configure(with: cellViewModel)
            return imageCell
        case .title, .content:
            guard let cellViewModel = viewModel?.getDetailsCellViewModel(
                at: indexPath,
                viewController: self
            ), let detailsCell = tableView.dequeueReusableCell(
                withIdentifier: NoteDetailsTableViewCell.reuseId,
                for: indexPath
            ) as? NoteDetailsTableViewCell else { return UITableViewCell() }
            detailsCell.configure(with: cellViewModel)
            return detailsCell
        }
    }
    
}

// MARK: - NoteViewModelPresenter Methods
extension NoteViewController: NoteViewModelPresenter {
    
    func updateDetails(with details: String) {
        detailsLabel.text = details
    }
    
    func openImagePickerScreen() {
        openImagePicker()
    }
    
    func getNoteDetails(at indexPath: IndexPath) -> NSAttributedString? {
        guard let detailsCell = tableView.cellForRow(at: indexPath) as? NoteDetailsTableViewCell else { return nil }
        return detailsCell.attributedText
    }
    
    func insertSections(_ sections: IndexSet) {
        tableView.insertSections(sections, with: .fade)
    }
    
    func deleteSections(_ sections: IndexSet) {
        tableView.deleteSections(sections, with: .fade)
    }
    
    func reloadSections(_ sections: IndexSet) {
        tableView.reloadSections(sections, with: .fade)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
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
