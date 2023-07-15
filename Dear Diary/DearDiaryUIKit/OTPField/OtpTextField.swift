//
//  OtpTextField.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public final class OtpTextField: UITextField {

    public weak var previousTextField: OtpTextField?
    public weak var nextTextField: OtpTextField?
        
    override public func deleteBackward() {
        guard text?.isEmpty ?? false else { return }
        previousTextField?.becomeFirstResponder()
    }
    
}
