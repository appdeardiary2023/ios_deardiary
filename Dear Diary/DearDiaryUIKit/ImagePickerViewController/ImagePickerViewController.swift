//
//  ImagePickerViewController.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 09/08/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit

open class ImagePickerViewController: UIViewController {
    
    public var onImageSelected: ((UIImage) -> Void)?
    
    public func openImagePicker() {
        let viewController = UIImagePickerController()
        viewController.sourceType = .photoLibrary
        viewController.delegate = self
        present(viewController, animated: true)
    }

}

// MARK: - UIImagePickerControllerDelegate Methods
extension ImagePickerViewController: UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        onImageSelected?(selectedImage)
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
