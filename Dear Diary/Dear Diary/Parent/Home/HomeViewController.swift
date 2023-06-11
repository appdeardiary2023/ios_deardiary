//
//  HomeViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 11/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController,
                                ViewLoadable {

    static var name = Constants.tabBarStoryboardName
    static var identifier = Constants.homeViewControllerIdentifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
    }

}
