//
//  UIImage+Extensions.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 16/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

extension UIImage {
    
    func maskWithColor(_ color: UIColor?) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: .zero, size: size)
        color?.setFill()
        draw(in: rect)
        context?.setBlendMode(.sourceIn)
        context?.fill(rect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage ?? self
    }
    
}
