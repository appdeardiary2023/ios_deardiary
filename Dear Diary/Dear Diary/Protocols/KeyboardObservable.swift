//
//  KeyboardObservable.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

protocol KeyboardLayoutDelegate: AnyObject {
    func keyboardDidShow()
    func keyboardDidHide()
}

protocol KeyboardObservable: NSObjectProtocol {
    var layoutableConstraint: NSLayoutConstraint { get }
    var layoutableView: UIView? { get }
    var constraintOffset: CGFloat { get }
    var layoutDelegate: KeyboardLayoutDelegate? { get }
}

extension KeyboardObservable {
  
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.keyboardWillHide()
        }
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
}

// MARK: - Private Helpers
private extension KeyboardObservable {
    
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let safeAreaBottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        layoutableConstraint.constant = keyboardSize.height + (safeAreaBottomInset.isZero ? constraintOffset : 0)
        UIView.animate(withDuration: Constants.Animation.defaultDuration) { [weak self] in
            self?.layoutableView?.layoutIfNeeded()
        }
        layoutDelegate?.keyboardDidShow()
    }
    
    func keyboardWillHide() {
        layoutableConstraint.constant = constraintOffset
        UIView.animate(withDuration: Constants.Animation.defaultDuration) { [weak self] in
            self?.layoutableView?.layoutIfNeeded()
        }
        layoutDelegate?.keyboardDidHide()
    }
    
}
