//
//  SKImagePicker.swift
//
//  Created by Shiv Kumar on 01/08/18.
//  Copyright © 2018 Shiv Kumar. All rights reserved.
//
/// - Requires: Swift 4.2 +

import UIKit
import Foundation

///- Remarks: ==: Protocal to get the image
protocol ImagePickerPresentable: class {
    func showImagePicker()
    func selectedImage(data: Data?, filePath: URL?)
}
//MARK: Extension
extension ImagePickerPresentable where Self: UIViewController {
    
    fileprivate var preferedStyle: UIAlertController.Style {
        return UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
    }
    
    fileprivate func pickerControllerAction(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            let pickerController           = UIImagePickerController()
            pickerController.delegate      = ImagePickerHelper.shared
            pickerController.sourceType    = type
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true)
        }
    }
    ///- Remark: ==: To Call the Menthod to show the Imagepicker :==
    internal func showImagePicker() {
        
        ImagePickerHelper.shared.delegate = self
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: preferedStyle)
        if let action = self.pickerControllerAction(for: .camera, title: "Take photo") {
            optionMenu.addAction(action)
        }
        if let action = self.pickerControllerAction(for: .photoLibrary, title: "Select from library") {
            optionMenu.addAction(action)
        }
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(optionMenu, animated: true)
        }
    }
}
//MARK: ==: Helper Class :==
fileprivate class ImagePickerHelper: NSObject {
    
    weak var delegate: ImagePickerPresentable?
    
    fileprivate struct `Static` {
        fileprivate static var instance: ImagePickerHelper?
    }
    
    fileprivate class var shared: ImagePickerHelper {
        if ImagePickerHelper.Static.instance == nil {
            ImagePickerHelper.Static.instance = ImagePickerHelper()
        }
        return ImagePickerHelper.Static.instance!
    }
    
    fileprivate func dispose() {
        ImagePickerHelper.Static.instance = nil
    }
    
    func picker(picker: UIImagePickerController, selectedImage data: Data?, filePath: URL?) {
        
        picker.dismiss(animated: true, completion: nil)
        guard delegate != nil else {
            return
        }
        self.delegate?.selectedImage(data: data, filePath: filePath)
        self.delegate = nil
        self.dispose()
    }
}
//MARK: ==: ImagePicker delagate :==
extension ImagePickerHelper: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker(picker: picker, selectedImage: nil, filePath: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return self.picker(picker: picker, selectedImage: nil, filePath: nil)
        }
        var imagePath: URL? = nil
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            imagePath = imgUrl
        }
        self.picker(picker: picker, selectedImage: data.jpegData(compressionQuality: 0.5), filePath: imagePath)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.picker(picker: picker, selectedImage: image.pngData(), filePath: nil)
    }
}
//MARK: ==: NavigationController Delegate :==
extension ImagePickerHelper: UINavigationControllerDelegate {
    //TODO: If required..
}
