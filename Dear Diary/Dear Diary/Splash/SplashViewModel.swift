//
//  SplashViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryImages

protocol SplashViewModelListener: AnyObject {
    func splashTimedOut()
}

protocol SplashViewModelPresenter: AnyObject {
    func beginAnimation()
    func dismiss(completion: @escaping () -> Void)
}

protocol SplashViewModelable: ViewLifecyclable {
    var logoImage: UIImage? { get }
    var presenter: SplashViewModelPresenter? { get set }
}

final class SplashViewModel: SplashViewModelable {
    
    weak var presenter: SplashViewModelPresenter?
    weak var listener: SplashViewModelListener?
    
}

// MARK: - Exposed Helpers
extension SplashViewModel {
    
    var logoImage: UIImage? {
        return Image.logo.asset
    }
    
    func screenDidLoad() {
        presenter?.beginAnimation()
        scheduleTimeout()
    }
    
}

// MARK: - Private Helpers
private extension SplashViewModel {
    
    func scheduleTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Constants.Splash.timeout)) { [weak self] in
            self?.presenter?.dismiss { [weak self] in
                self?.listener?.splashTimedOut()
            }
        }
    }
    
}
