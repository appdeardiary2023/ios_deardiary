//
//  SplashViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class SplashViewController: UIViewController,
                                  ViewLoadable {
    
    static let name = Constants.Splash.storyboardName
    static let identifier = Constants.Splash.splashViewController
    
    private struct Style {
        static let backgroundColor = Color.background.shade
        
        static let logoImageViewTintColor = Color.label.shade
        static let logoImageViewMinAlpha: CGFloat = 0.7
        
        static let dismissAnimationDuration = Constants.Animation.defaultDuration
        static let logoAnimationDuration = Constants.Animation.longDuration
    }
    
    @IBOutlet private weak var logoImageView: UIImageView!
    
    var viewModel: SplashViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension SplashViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        setupLogoImageView()
        viewModel?.screenDidLoad?()
    }
    
    func setupLogoImageView() {
        logoImageView.image = viewModel?.logoImage?.withTintColor(Style.logoImageViewTintColor)
    }
    
}

// MARK: - SplashViewModelPresenter Methods
extension SplashViewController: SplashViewModelPresenter {
    
    func beginAnimation() {
        UIView.animate(
            withDuration: Style.logoAnimationDuration,
            delay: 0,
            options: [.autoreverse, .repeat]
        ) { [weak self] in
            self?.logoImageView.alpha = Style.logoImageViewMinAlpha
        }
    }
    
    func dismiss(completion: @escaping () -> Void) {
        logoImageView.fadeOut(withDuration: Style.dismissAnimationDuration) { [weak self] in
            self?.navigationController?.dismiss(animated: false, completion: completion)
        }
    }
    
}
