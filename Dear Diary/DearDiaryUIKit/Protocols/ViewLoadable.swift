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