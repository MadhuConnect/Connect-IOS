//
//  EmergencyInterestTableViewCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 29/10/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class EmergencyInterestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vw_emergencyBackView: UIView!
   
    //Person
    @IBOutlet weak var lbl_interestedName: UILabel!
    @IBOutlet weak var lbl_userLocation: UILabel!

    //Mobile
    @IBOutlet weak var vw_mobileBackView: UIView!
    @IBOutlet weak var iv_mobileImageView: UIImageView!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var btn_makeCall: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateDefaultUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInterestedInformation(_ interest: Interests?) {
        if let interest = interest {
            self.lbl_interestedName.text = interest.name
            self.lbl_userLocation.text = "connected at \(interest.userLocation)"
            self.lbl_mobile.text = interest.mobile
        }
    }

}

extension EmergencyInterestTableViewCell {
    private func updateDefaultUI() {
        self.vw_emergencyBackView.setBorderForView(width: 1, color: ConstHelper.white, radius: 10)

        self.lbl_interestedName.font = ConstHelper.h4Bold
        self.lbl_interestedName.textColor = ConstHelper.cyan
        
        self.lbl_userLocation.font = ConstHelper.h6Normal
        self.lbl_userLocation.textColor = ConstHelper.gray
        
        self.lbl_mobile.font = ConstHelper.h5Bold
        self.lbl_mobile.textColor = ConstHelper.blue
        
    }

}
