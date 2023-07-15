//
//  ViewLoadable.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 11/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public protocol ViewLoadable {
    static var name: String { get }
    static var identifier: String { get }
}

public extension ViewLoadable where Self: UIViewController {
    
    static func loadFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
    
}

public extension ViewLoadable where Self: UIView {
    
    static func loadFromNib() -> Self {
        let nib = UINib(nibName: name, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
    
}

public extension ViewLoadable where Self: UITableViewCell {
    
    static func register(for tableView: UITableView) {
        let nib = UINib(nibName: name, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    static func deque(from tableView: UITableView, at indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        ) as! Self
    }
    
}

public extension ViewLoadable where Self: UICollectionViewCell {
    
    static func register(for collectionView: UICollectionView) {
        let nib = UINib(nibName: name, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    static func deque(from collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        return collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as! Self
    }
    
}

/// Note: - Use only for headers
public extension ViewLoadable where Self: UICollectionReusableView {
    
    static func register(for collectionView: UICollectionView) {
        let nib = UINib(nibName: name, bundle: nil)
        collectionView.register(
            nib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: identifier
        )
    }
    
    static func deque(from collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: identifier,
            for: indexPath
        ) as! Self
    }
    
}
