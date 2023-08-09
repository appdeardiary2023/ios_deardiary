//
//  Alertable.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 04/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit
import DearDiaryStrings

protocol Alertable {}

extension Alertable {
    
    /// Creates an action sheet alert with a `cancel` and `destructive` action
    func showAlert(with title: String, message: String? = nil, actionTitle: String? = nil, onCancel: (() -> Void)? = nil, onAction: @escaping () -> Void) {
        guard let window = UIApplication.shared.windows.first else { return }
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(
            title: Strings.Alert.cancel,
            style: .cancel
        ) {_ in
            onCancel?()
        }
        let destructiveAction = UIAlertAction(
            title: actionTitle,
            style: .destructive
        ) {_ in
            onAction()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(destructiveAction)
        window.rootViewController?.topMostViewController.present(
            alertController,
            animated: true
        )
    }
    
}
