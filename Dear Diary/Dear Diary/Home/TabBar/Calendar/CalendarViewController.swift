//
//  CalendarViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class CalendarViewController: UIViewController,
                                    ViewLoadable {
    
    static let name = Constants.Home.storyboardName
    static let identifier = Constants.Home.calendarViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let collectionViewBackgroundColor = UIColor.clear
        static let collectionViewSectionInset = UIEdgeInsets(
            top: 0,
            left: 30,
            bottom: 30,
            right: 30
        )
        static let collectionViewLineSpacing: CGFloat = 20
        static let noteCellHeight: CGFloat = 130
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var viewModel: CalendarViewModelable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension CalendarViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = Style.collectionViewBackgroundColor
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = Style.collectionViewSectionInset
            layout.minimumLineSpacing = Style.collectionViewLineSpacing
        }
        CalendarCollectionViewCell.register(for: collectionView)
        NoteDateCollectionReusableView.register(for: collectionView)
        NoteCalendarCollectionViewCell.register(for: collectionView)
    }
    
}

// MARK: - UICollectionViewDelegate Methods
extension CalendarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerViewModel = viewModel?.getNotesHeaderViewModel(in: indexPath.section) else { return UICollectionReusableView() }
            let headerView = NoteDateCollectionReusableView.deque(
                from: collectionView,
                at: indexPath
            )
            headerView.configure(with: headerViewModel)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath)
    }
    
}

// MARK: - UICollectionViewDataSource Methods
extension CalendarViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getNumberOfItems(in: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = viewModel?.sections[safe: indexPath.section] else {
            guard let cellViewModel = viewModel?.getNoteCellViewModel(at: indexPath) else { return UICollectionViewCell() }
            let noteCell = NoteCalendarCollectionViewCell.deque(
              from: collectionView,
              at: indexPath
            )
            noteCell.configure(with: cellViewModel)
            return noteCell
        }
        switch section {
        case .calendar:
            guard var cellViewModel = viewModel?.getCalendarCellViewModel(at: indexPath) else { return UICollectionViewCell() }
            let calendarCell = CalendarCollectionViewCell.deque(
                from: collectionView,
                at: indexPath
            )
            cellViewModel.presenter = calendarCell
            calendarCell.configure(with: cellViewModel)
            return calendarCell
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard viewModel?.sections[safe: section] == nil,
              let headerViewModel = viewModel?.getNotesHeaderViewModel(in: section) else { return CGSize() }
        let headerWidth = collectionView.bounds.width
        let headerHeight = NoteDateCollectionReusableView.calculateHeight(
            with: headerViewModel,
            width: headerWidth
        )
        return CGSize(width: headerWidth, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width - (
            Style.collectionViewSectionInset.left + Style.collectionViewSectionInset.right
        )
        guard let section = viewModel?.sections[safe: indexPath.section] else {
            return CGSize(width: itemWidth, height: Style.noteCellHeight)
        }
        switch section {
        case .calendar:
            guard let cellViewModel = viewModel?.getCalendarCellViewModel(at: indexPath) else { return CGSize() }
            let itemHeight = CalendarCollectionViewCell.calculateHeight(with: cellViewModel)
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
}

// MARK: - CalendarViewModelPresenter Methods
extension CalendarViewController: CalendarViewModelPresenter {
    
    func deleteSections(_ sections: IndexSet) {
        collectionView.deleteSections(sections)
    }
    
    func reloadSections(_ sections: IndexSet) {
        collectionView.reloadSections(sections)
    }
    
    func updateSections(inserting newSections: IndexSet, reloading oldSections: IndexSet?) {
        collectionView.performBatchUpdates { [weak self] in
            self?.collectionView.insertSections(newSections)
            if let oldSections = oldSections {
                self?.collectionView.reloadSections(oldSections)
            }
        }
    }
    
}
