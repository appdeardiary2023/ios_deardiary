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
    
    /// Creates an action sheet alert with a `cancel` and `delete` action
    func showAlert(with title: String, message: String? = nil, onCancel: (() -> Void)? = nil, onDelete: @escaping () -> Void) {
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
        let deleteAction = UIAlertAction(
            title: Strings.Alert.delete,
            style: .destructive
        ) {_ in
            onDelete()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        window.rootViewController?.topMostViewController.present(
            alertController,
            animated: true
        )
    }
    
}
