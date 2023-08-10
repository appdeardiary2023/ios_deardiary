//
//  GridViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class GridViewController: UIViewController,
                                ViewLoadable {
    
    static let name = Constants.Home.storyboardName
    static let identifier = Constants.Home.gridViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let collectionViewBackgroundColor = UIColor.clear
        static let collectionViewSectionInset = UIEdgeInsets(
            top: 30,
            left: 30,
            bottom: 30,
            right: 30
        )
        static let collectionViewLineSpacing: CGFloat = 20
        static let collectionViewInteritemSpacing: CGFloat = 20
        static let cellsPerRow: Int = 2
        static let itemAspectRatio = 0.8
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var viewModel: GridViewModelable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.screenWillAppear?()
    }

}

// MARK: - Private Helpers
private extension GridViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupCollectionView()
        viewModel?.screenDidLoad?()
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = Style.collectionViewBackgroundColor
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = Style.collectionViewSectionInset
            layout.minimumLineSpacing = Style.collectionViewLineSpacing
            layout.minimumInteritemSpacing = Style.collectionViewInteritemSpacing
        }
        GridCollectionViewCell.register(for: collectionView)
    }
    
}

// MARK: - UICollectionViewDelegate Methods
extension GridViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectNote(at: indexPath)
    }
    
}

// MARK: - UICollectionViewDataSource Methods
extension GridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.notes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageUrl = viewModel?.getAttachmentUrl(at: indexPath) else { return UICollectionViewCell() }
        let gridCell = GridCollectionViewCell.deque(from: collectionView, at: indexPath)
        gridCell.configure(with: imageUrl)
        return gridCell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension GridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - (
            Style.collectionViewSectionInset.left + Style.collectionViewSectionInset.right
        )
        let totalSpacing = Style.collectionViewInteritemSpacing * CGFloat(Style.cellsPerRow - 1)
        let itemWidth = (availableWidth - totalSpacing) / 2
        let itemHeight = itemWidth / Style.itemAspectRatio
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

// MARK: - GridViewModelPresenter Methods
extension GridViewController: GridViewModelPresenter {
    
    func reload() {
        collectionView.reloadData()
    }
    
}
