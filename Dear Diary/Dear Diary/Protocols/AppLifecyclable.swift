//
//  AppLifecyclable.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 05/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

@objc
protocol AppLifecyclable {
    @objc func applicationWillTerminate()
    @objc func applicationEnteredBackground()
    @objc func applicationWillEnterForeground()
}

extension AppLifecyclable {
    
    func addAppLifecycleObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(applicationWillTerminate),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(applicationEnteredBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    func removeAppLifecycleObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(
            self,
            name: UIApplication.willTerminateNotification,
            object: nil
        )
        notificationCenter.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        notificationCenter.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
}
