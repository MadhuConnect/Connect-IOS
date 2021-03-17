//
//  NotificationCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 22/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var vw_notifyBackView: UIView!
    @IBOutlet weak var vw_topBackView: UIView!
    @IBOutlet weak var vw_middleBackView: UIView!
    @IBOutlet weak var vw_bottomBackView: UIView!
    
    @IBOutlet weak var lbl_personName: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var lbl_connected: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
        
    @IBOutlet weak var lbl_lock: UILabel!
    @IBOutlet weak var lbl_block: UILabel!
    @IBOutlet weak var lbl_addCart: UILabel!
    
    @IBOutlet weak var btn_lock: UIButton!
    @IBOutlet weak var btn_block: UIButton!
    @IBOutlet weak var btn_addCart: UIButton!
    @IBOutlet weak var btn_call: UIButton!
    
    @IBOutlet weak var lbl_addedCartStatus: UILabel!
    
    //Lock view
    @IBOutlet weak var vw_lockBackView: UIView!
    //Block view
    @IBOutlet weak var vw_blockBackView: UIView!
    //Share view
    @IBOutlet weak var vw_addCartBackView: UIView!
    @IBOutlet weak var lbl_connectedTrailingContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateDefaultUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setNotificationsForQRCode(_ notification: NotificationModel?, isAddedCart: Bool) {
        if let notification = notification {
            self.updateCell(notification, isAddedCart: isAddedCart)
        }
    }
    
}

extension NotificationCell {
    private func updateDefaultUI() {
        self.vw_notifyBackView.setBorderForView(width: 1, color: ConstHelper.white, radius: 10)
        self.vw_middleBackView.backgroundColor = ConstHelper.lightGray
        
        self.lbl_personName.font = ConstHelper.h3Normal
        self.lbl_personName.textColor = ConstHelper.black
        
        self.lbl_connected.font = ConstHelper.h6Normal
        self.lbl_connected.textColor = ConstHelper.gray
        
        self.lbl_description.font = ConstHelper.h4Normal
        self.lbl_description.textColor = ConstHelper.black
        
        self.lbl_mobile.font = ConstHelper.h4Normal
        self.lbl_mobile.textColor = ConstHelper.blue
        
        self.lbl_lock.font = ConstHelper.h5Normal
        self.lbl_lock.textColor = ConstHelper.black
        self.lbl_block.font = ConstHelper.h5Normal
        self.lbl_block.textColor = ConstHelper.black
        self.lbl_addCart.font = ConstHelper.h5Normal
        self.lbl_addCart.textColor = ConstHelper.black
        
        self.lbl_connectedTrailingContraint.constant = 0
        self.lbl_addedCartStatus.text = ""
        self.lbl_addedCartStatus.font = ConstHelper.h6Normal
        self.lbl_addedCartStatus.textColor = ConstHelper.white
        self.lbl_addedCartStatus.backgroundColor = ConstHelper.orange
        
        self.vw_lockBackView.addRightBorder(with: ConstHelper.lightGray, andWidth: 1)
        self.vw_blockBackView.addRightBorder(with: ConstHelper.lightGray, andWidth: 1)
                
        btn_call.isUserInteractionEnabled = false
    }
    
    private func updateCell(_ notification: NotificationModel, isAddedCart: Bool) {
        self.lbl_personName.text = notification.name
        
        if let mobile = notification.mobile {
            self.lbl_mobile.text = self.getLast4DigitFromPhoneNumber(mobile)
        }
        
        self.lbl_description.text = notification.description
        
        if isAddedCart {
            self.lbl_addedCartStatus.text = "  Added to cart  "
            self.lbl_connectedTrailingContraint.constant = 100
        } else {
            self.lbl_addedCartStatus.text = ""
            self.lbl_connectedTrailingContraint.constant = 0
        }
        
        let day = self.getDay(notification.date ?? "")
        let mm_yy = self.getMonth_Year(notification.date ?? "")
        self.lbl_connected.text = "Connected on \(day) \(mm_yy) at \(notification.connectedLocation ?? "")"
    }
    
}

//extension NotificationCell {
//
//    func blur(_ blurRadius: Double = 6, label: UILabel) {
//        let blurredImage = getBlurryImage(blurRadius, label: label)
//        let blurredImageView = UIImageView(image: blurredImage)
//        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
//        blurredImageView.tag = 100
//        blurredImageView.contentMode = .center
//        blurredImageView.backgroundColor = .white
//        label.addSubview(blurredImageView)
//        NSLayoutConstraint.activate([
//            blurredImageView.centerXAnchor.constraint(equalTo: label.centerXAnchor),
//            blurredImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
//        ])
//    }
//
//    func unblur(label: UILabel) {
//        label.subviews.forEach { subview in
//            if subview.tag == 100 {
//                subview.removeFromSuperview()
//            }
//        }
//    }
//
//    private func getBlurryImage(_ blurRadius: Double = 2.5, label: UILabel) -> UIImage? {
//        UIGraphicsBeginImageContext(label.bounds.size)
//        
//        if let context = UIGraphicsGetCurrentContext() {
//            label.layer.render(in: context)
//            guard let image = UIGraphicsGetImageFromCurrentImageContext(),
//                let blurFilter = CIFilter(name: "CIGaussianBlur") else {
//                UIGraphicsEndImageContext()
//                return nil
//            }
//            UIGraphicsEndImageContext()
//
//            blurFilter.setDefaults()
//
//            blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
//            blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)
//
//            var convertedImage: UIImage?
//            let context = CIContext(options: nil)
//            if let blurOutputImage = blurFilter.outputImage,
//                let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
//                convertedImage = UIImage(cgImage: cgImage)
//            }
//
//            return convertedImage
//        }
//        
//        return nil
//    }
//}
