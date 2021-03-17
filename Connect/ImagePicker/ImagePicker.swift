//
//  ImagePicker.swift
//  Connect-iOS
//
//  Created by Venkatesh Botla on 17/07/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation
import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?, imagePath: String?, name: String?)
}

open class ImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, imagePath: String?, name: String?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image, imagePath: imagePath, name: name)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, imagePath: nil, name: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let imgUrl = info[.imageURL] as? URL {
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending("/" + imgName)
            let image = info[.originalImage] as! UIImage
            let data = image.jpegData(compressionQuality: 1)! as NSData
            data.write(toFile: localPath!, atomically: true)
            let photoURL = URL.init(fileURLWithPath: localPath!)
            self.pickerController(picker, didSelect: image, imagePath: photoURL.path, name: photoURL.lastPathComponent)
            
        } else {
            if let image = info[.originalImage] as? UIImage {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                
                if picker.sourceType == .camera {
                    let imgName = UUID().uuidString
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)

                    let data = image.jpegData(compressionQuality: 1)! as NSData
                    data.write(toFile: localPath, atomically: true)
                    let photoURL = URL.init(fileURLWithPath: localPath)
                    self.pickerController(picker, didSelect: image, imagePath: photoURL.path, name: photoURL.lastPathComponent)
                }
            }
        }
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("ERROR: \(error)")
        }
    }
    
}

extension ImagePicker: UINavigationControllerDelegate {

}
