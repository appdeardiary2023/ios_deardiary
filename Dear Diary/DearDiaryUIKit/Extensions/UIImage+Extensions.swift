//
//  UIImage+Extensions.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 18/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

public extension UIImage {
    
    func resize(to targetSize: CGSize) -> UIImage? {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio
            ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image {_ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resizedImage.withRenderingMode(.alwaysOriginal)
    }
    
}
