//
//  ViewLifecyclable.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 27/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

@objc
protocol ViewLifecyclable {
    @objc optional func screenDidLoad()
    @objc optional func screenWillAppear()
    @objc optional func screenWillDisappear()
}
