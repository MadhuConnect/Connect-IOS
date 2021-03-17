//
//  EmergencyNearByTableViewCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 03/11/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class EmergencyNearByTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vw_emergencyBackView: UIView!
    @IBOutlet weak var vw_topBackView: UIView!
    @IBOutlet weak var vw_middleBackView: UIView!
    @IBOutlet weak var vw_bottomBackView: UIView!
    
    //Top
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_emergencyGeneratedDateTime: UILabel!
    @IBOutlet weak var lbl_bloodTypeLookingFor: UILabel!
    @IBOutlet weak var lbl_bloodDescription: UILabel!

    //Bottom
    //Bell
    @IBOutlet weak var vw_lockBackView: UIView!
    @IBOutlet weak var iv_lockImageView: UIImageView!
    @IBOutlet weak var lbl_lock: UILabel!
    @IBOutlet weak var btn_lock: UIButton!
    
    //Mobile
    @IBOutlet weak var vw_mobileBackView: UIView!
    @IBOutlet weak var iv_mobileImageView: UIImageView!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var btn_makeCall: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.updateDefaultUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEmergencyNearbyInformation(_ emergencyNotification: EmergencyNotifications?) {
        if let emergencyNotification = emergencyNotification {
            self.lbl_title.text = emergencyNotification.name
            self.lbl_emergencyGeneratedDateTime.text = "created on \(getDateSpecificFormat(emergencyNotification.requestGeneratedDate)) at \(emergencyNotification.connectedLocation)"
            self.lbl_bloodTypeLookingFor.text = "Looking for \(emergencyNotification.emergencyType) in \(emergencyNotification.type)"
            self.lbl_bloodDescription.text = "\(emergencyNotification.message)"
            self.lbl_mobile.text = emergencyNotification.mobile
        }
    }

}


extension EmergencyNearByTableViewCell {
    private func updateDefaultUI() {
        self.vw_emergencyBackView.setBorderForView(width: 1, color: ConstHelper.white, radius: 10)
        self.vw_middleBackView.backgroundColor = ConstHelper.lightGray
        
        self.lbl_title.font = ConstHelper.h4Bold
        self.lbl_title.textColor = ConstHelper.cyan
        
        self.lbl_emergencyGeneratedDateTime.font = ConstHelper.h6Normal
        self.lbl_emergencyGeneratedDateTime.textColor = ConstHelper.gray
        
        self.lbl_bloodTypeLookingFor.font = ConstHelper.h5Normal
        self.lbl_bloodTypeLookingFor.textColor = ConstHelper.black
        
        self.lbl_bloodDescription.font = ConstHelper.h5Normal
        self.lbl_bloodDescription.textColor = ConstHelper.black
        
        self.lbl_lock.font = ConstHelper.h5Normal
        self.lbl_lock.textColor = ConstHelper.black
        self.lbl_lock.text = "Lock"

        self.lbl_mobile.font = ConstHelper.h5Bold
        self.lbl_mobile.textColor = ConstHelper.blue
        
        
    }
    
}
