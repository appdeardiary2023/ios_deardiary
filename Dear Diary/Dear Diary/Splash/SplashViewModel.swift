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
    func splashTimedOut(screen: SplashViewModel.Screen)
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
    
    enum Screen {
        case register(flow: RegisterViewModel.Flow)
        case home
    }
    
    private let screen: Screen
        
    weak var presenter: SplashViewModelPresenter?
    weak var listener: SplashViewModelListener?
    
    init(screen: Screen) {
        self.screen = screen
    }
    
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
                guard let self = self else { return }
                self.listener?.splashTimedOut(screen: self.screen)
            }
        }
    }
    
}
