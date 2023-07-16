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
        static let collectionViewInterItemSpacing: CGFloat = 20
        static let collectionViewColumnSpacing: CGFloat = 20
        static let collectionViewSectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        static let defaultCellSize = CGSize(width: 150, height: 150)
        
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
        viewModel?.screenDidLoad()
    }
    
    func setupBackButton() {
        backButton.tintColor = Style.backButtonTintColor
        backButton.setImage(viewModel?.backButtonImage, for: .normal)
        backButton.setTitle(nil, for: .normal)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = Style.collectionViewBackgroundColor
        // Assign waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumInteritemSpacing = Style.collectionViewInterItemSpacing
        layout.minimumColumnSpacing = Style.collectionViewColumnSpacing
        layout.sectionInset = Style.collectionViewSectionInset
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
        addButton.layer.cornerRadius = min(addButton.bounds.width, addButton.bounds.height) / 2
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

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension NotesViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
        return TitleCollectionReusableView.calculateHeight(with: viewModel?.title)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = Style.defaultCellSize
        return (viewModel?.isMosaicCell(at: indexPath) ?? false)
            ? cellSize
            : CGSize(
                width: cellSize.width,
                height: 2 * cellSize.height + Style.collectionViewColumnSpacing
            )
    }
    
}

// MARK: - NotesViewModelPresenter Methods
extension NotesViewController: NotesViewModelPresenter {
    
    func reload() {
        collectionView.reloadData()
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
}
