//
//  TextStyleView.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

class TextStyleView: UIView{
    
    let label = UILabel()
    
    let activeBackgroundColor = Color.primary.shade
    let inactiveBackgroundColor = UIColor.clear
    let activeTextColor = Color.white.shade
    let inactiveTextColor = Color.tertiaryLabel.shade
    
    let tapGesture = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.textAlignment = .center
        label.centerInSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: label.widthAnchor, multiplier: 1, constant: 22).isActive = true
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("StyleView: init(coder:) has not been implemented")
    }
    
    var isActive = false{
        didSet{
            backgroundColor = isActive ? activeBackgroundColor : inactiveBackgroundColor
            label.textColor = isActive ? activeTextColor : inactiveTextColor
        }
    }
}
