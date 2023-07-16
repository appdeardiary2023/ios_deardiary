//
//  GridViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class GridViewController: UIViewController {
    
    private struct Style {
        static let backgroundColor = Color.background.shade
    }
    
    private let viewModel: GridViewModelable
    
    init(viewModel: GridViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension GridViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
    }
    
}
