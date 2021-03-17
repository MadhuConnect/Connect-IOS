//
//  EmergencyOrdersTableViewCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 29/10/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class EmergencyOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vw_emergencyBackView: UIView!
    @IBOutlet weak var vw_topBackView: UIView!
    @IBOutlet weak var vw_middleBackView: UIView!
    @IBOutlet weak var vw_bottomBackView: UIView!
   
    //Top
    @IBOutlet weak var btn_emergencyInfo: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_emergencyGeneratedDateTime: UILabel!
    @IBOutlet weak var lbl_bloodType: UILabel!
    @IBOutlet weak var lbl_bloodDescription: UILabel!

    //Bottom
    //Bell
    @IBOutlet weak var vw_interestsBackView: UIView!
    @IBOutlet weak var iv_interestImageView: UIImageView!
    @IBOutlet weak var lbl_interests: UILabel!
    @IBOutlet weak var btn_interests: UIButton!

    //Delete
    @IBOutlet weak var vw_deleteBackView: UIView!
    @IBOutlet weak var iv_deleteImageView: UIImageView!
    @IBOutlet weak var lbl_delete: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateDefaultUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEmergencyInformation(_ emergencyInfo: EmergenctData?) {
        if let emergencyInfo = emergencyInfo {
            self.lbl_title.text = emergencyInfo.emergency
            self.lbl_emergencyGeneratedDateTime.text = "Created on \(self.getDateSpecificFormatForEmergency(emergencyInfo.requestGeneratedDate ?? "")) at \(emergencyInfo.requestGeneratedTime ?? "")"
            self.lbl_bloodType.text = "Looking for \(emergencyInfo.type ?? "")"
            self.lbl_bloodDescription.text = emergencyInfo.message
            self.lbl_interests.text = "Interests (\(emergencyInfo.interests?.count ?? 0))"
            self.lbl_delete.text = "Delete"
        }
    }

}

extension EmergencyOrdersTableViewCell {
    private func updateDefaultUI() {
        self.vw_emergencyBackView.setBorderForView(width: 1, color: ConstHelper.white, radius: 10)
        self.vw_middleBackView.backgroundColor = ConstHelper.lightGray
        self.vw_interestsBackView.addRightBorder(with: ConstHelper.lightGray, andWidth: 1)

        self.lbl_title.font = ConstHelper.h4Bold
        self.lbl_title.textColor = ConstHelper.cyan
        
        self.lbl_emergencyGeneratedDateTime.font = ConstHelper.h6Normal
        self.lbl_emergencyGeneratedDateTime.textColor = ConstHelper.gray
        
        self.lbl_bloodType.font = ConstHelper.h5Bold
        self.lbl_bloodType.textColor = ConstHelper.cyan
        
        self.lbl_bloodDescription.font = ConstHelper.h5Normal
        self.lbl_bloodDescription.textColor = ConstHelper.black
        
        self.lbl_interests.font = ConstHelper.h5Normal
        self.lbl_interests.textColor = ConstHelper.black
        
        self.lbl_delete.font = ConstHelper.h5Normal
        self.lbl_delete.textColor = ConstHelper.red
    }
    
    func downloadImage(url: URL, imageView: UIImageView) {
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 10)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "noimage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }

}
