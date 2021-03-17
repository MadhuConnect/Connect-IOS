//
//  MultipleImagePicker.swift
//  Connect
//
//  Created by Venkatesh Botla on 29/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

public struct ImageAsset {
    let image: UIImage?
    let name: String
}

public protocol MultipleImagePickerDelegate: class {
    func didSelectMultiple(_ imageAsset: [ImageAsset]?)
}

open class MultipleImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: MultipleImagePickerDelegate?
    
    var myImages = [ImageAsset]()
    var imageAssets = [ImageAsset]()
    var iterateOnce: Int = 1
    
    public init(presentationController: UIViewController, delegate: MultipleImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String, vc: UIViewController) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if type == .photoLibrary {
                self.presentImagePicker(vc)
            } else {
                self.pickerController.sourceType = type
                self.presentationController?.present(self.pickerController, animated: true)
            }

        }
    }
    
    //MARK: - Alert for selecting image selection option
    public func present(from sourceView: UIView, viewController: UIViewController) {
        let alertController = UIAlertController(title: "Upload", message: "Take Photo/Chose photos from Photo Library", preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo", vc: viewController) {
            alertController.addAction(action)
        }
        #warning("Not Needed. Remove this option while deploy for test/prod")
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll", vc: viewController) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library", vc: viewController) {
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
    
    //MARK: - Single/Multiple images selection from photo library
    public func presentImagePicker(_ viewController: UIViewController) {
        self.iterateOnce = 1
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.unselectOnReachingMax = true
        
        viewController.presentImagePicker(imagePicker,
        select: { (asset) in
            //print("selected asset")
        }, deselect: { (asset) in
            //print("Deselected asset")
        }, cancel: { (assets) in
            //print("Canceld assets")
        }, finish: { (assets) in
            //print("finished asset selection")
            self.myImages.removeAll()
            
            //Creating images
            for asset in assets {
                self.myImages.append(ImageAsset(image: self.getImageAsset(asset: asset), name: (UUID().uuidString + ".jpeg")))
            }
            
            //Save images
            for myimage in self.myImages {
                let imageData = myimage.image?.jpegData(compressionQuality: 1.0)
                self.save(data: imageData! as NSData, toDirectory: self.documentDirectory(), withFilename: myimage.name)
            }
            
            //Retrive images
            self.imageAssets.removeAll()
            for myimage in self.myImages {
                let path = self.read(fromDocumentsWithFileName: myimage.name)
                if let path = path {
                    self.imageAssets.append(ImageAsset(image: myimage.image, name: path))
                }
            }
            
            self.delegate?.didSelectMultiple(self.imageAssets)
            
        }, completion: nil)
    }
    
    
    
    func getImageAsset( asset: PHAsset ) -> UIImage? {
        let manager    = PHImageManager.default( )
        let option       = PHImageRequestOptions( )
        let targetSize = CGSize( width: asset.pixelWidth, height: asset.pixelHeight )
        
        option.resizeMode      = .none
        option.isSynchronous = true
        
        var image: UIImage? = nil
        
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: option, resultHandler: { ( result, info ) in
            image = result!
        })
        
        return image
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect images: [ImageAsset]?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelectMultiple(images)
    }
    
}

extension MultipleImagePicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imgUrl = info[.imageURL] as? URL {
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending("/" + imgName)
            let image = info[.originalImage] as! UIImage
            let data = image.jpegData(compressionQuality: 1)! as NSData
            data.write(toFile: localPath!, atomically: true)
            let photoURL = URL.init(fileURLWithPath: localPath!)
            self.pickerController(picker, didSelect: [ImageAsset(image: image, name: photoURL.path)])
        } else {
            if let image = info[.originalImage] as? UIImage {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                
                if picker.sourceType == .camera{
                    let imgName = UUID().uuidString
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)

                    let data = image.jpegData(compressionQuality: 1)! as NSData
                    data.write(toFile: localPath, atomically: true)
                    let photoURL = URL.init(fileURLWithPath: localPath)
                    self.pickerController(picker, didSelect: [ImageAsset(image: image, name: photoURL.path)])
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

extension MultipleImagePicker {
    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return documentDirectory[0]
    }
    
    private func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            return pathURL.absoluteString
        }
        return nil
    }
    
    private func save(data: NSData, toDirectory direcotry: String, withFilename filename: String) {
        guard let filePath = self.append(toPath: direcotry, withPathComponent: filename) else {
            return
        }
                
        do {
            try data.write(toFile: filePath, options: .atomic)
        } catch {
//            print("Error", error)
            return
        }
        
    }
    
    private func read(fromDocumentsWithFileName fileName: String) -> String? {
        guard let filePath = self.append(toPath: self.documentDirectory(), withPathComponent: fileName) else {
            return nil
        }
        
        return filePath
    }
    
    
}
