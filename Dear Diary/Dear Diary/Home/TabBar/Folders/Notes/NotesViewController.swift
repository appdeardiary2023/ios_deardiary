//
//  NotesViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import CHTCollectionViewWaterfallLayout

final class NotesViewController: UIViewController,
                                 ViewLoadable {
    
    static let name = Constants.TabBar.storyboardName
    static let identifier = Constants.TabBar.Notes.notesViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let backButtonTintColor = Color.label.shade
        
        static let collectionViewBackgroundColor = UIColor.clear
        static let collectionViewSectionInset = UIEdgeInsets(
            top: 0,
            left: 30,
            bottom: 0,
            right: 30
        )
        static let collectionViewInteritemSpacing: CGFloat = 20
        static let collectionViewColumnSpacing: CGFloat = 20
        static let cellsPerRow: Int = 2
        static let shortCellHeight: CGFloat = 150
        static let shortCellsPerColumn: Int = 2
        
        static let addButtonBackgroundColor = Color.primary.shade
        static let addButtonTintColor = Color.white.shade
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addButton: UIButton!

    var viewModel: NotesViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension NotesViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupBackButton()
        setupCollectionView()
        setupAddButton()
        viewModel?.screenDidLoad?()
    }
    
    func setupBackButton() {
        backButton.tintColor = Style.backButtonTintColor
        backButton.setImage(viewModel?.backButtonImage, for: .normal)
        backButton.setTitle(nil, for: .normal)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = Style.collectionViewBackgroundColor
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = Style.collectionViewSectionInset
        layout.minimumInteritemSpacing = Style.collectionViewInteritemSpacing
        layout.minimumColumnSpacing = Style.collectionViewColumnSpacing
        collectionView.collectionViewLayout = layout
        collectionView.register(
            TitleCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleCollectionReusableView.reuseId
        )
        collectionView.register(
            NoteCollectionViewCell.self,
            forCellWithReuseIdentifier: NoteCollectionViewCell.reuseId
        )
    }
    
    func setupAddButton() {
        addButton.backgroundColor = Style.addButtonBackgroundColor
        addButton.tintColor = Style.addButtonTintColor
        addButton.setImage(viewModel?.addButtonImage, for: .normal)
        addButton.setTitle(nil, for: .normal)
        addButton.layer.cornerRadius = min(
            addButton.bounds.width,
            addButton.bounds.height
        ) / 2
    }
    
    @IBAction func backButtonTapped() {
        viewModel?.backButtonTapped()
    }
    
    @IBAction func addButtonTapped() {
        viewModel?.addButtonTapped()
    }
    
}

// MARK: - UICollectionViewDelegate Methods
extension NotesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleCollectionReusableView.reuseId,
                for: indexPath
            ) as? TitleCollectionReusableView else { return UICollectionReusableView() }
            headerView.configure(with: viewModel?.title)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectNote(at: indexPath)
    }
    
}

// MARK: - UICollectionViewDataSource Methods
extension NotesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.notes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = viewModel?.getCellViewModel(at: indexPath),
              let noteCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteCollectionViewCell.reuseId,
                for: indexPath
            ) as? NoteCollectionViewCell else { return UICollectionViewCell() }
        noteCell.configure(with: cellViewModel)
        return noteCell
    }
    
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout Methods
extension NotesViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
        return TitleCollectionReusableView.calculateHeight(with: viewModel?.title)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel else { return CGSize() }
        let isLongNote = viewModel.isLongNote(at: indexPath)
        let availableWidth = collectionView.bounds.width - (
            Style.collectionViewSectionInset.left + Style.collectionViewSectionInset.right
        )
        let totalSpacing = Style.collectionViewInteritemSpacing * CGFloat(Style.cellsPerRow - 1)
        let itemWidth = (availableWidth - totalSpacing) / 2
        let itemHeight = isLongNote
            ? CGFloat(Style.shortCellsPerColumn) * Style.shortCellHeight + Style.collectionViewColumnSpacing
            : Style.shortCellHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

// MARK: - NotesViewModelPresenter Methods
extension NotesViewController: NotesViewModelPresenter {

    func reloadNote(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func scroll(to indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true)
    }
    
}
