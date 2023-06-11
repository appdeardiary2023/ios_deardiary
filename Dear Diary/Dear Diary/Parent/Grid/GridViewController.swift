//
//  GridViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 11/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

final class GridViewController: UIViewController,
                                ViewLoadable {

    static var name = Constants.tabBarStoryboardName
    static var identifier = Constants.gridViewControllerIdentifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Grid"
    }
    
}
