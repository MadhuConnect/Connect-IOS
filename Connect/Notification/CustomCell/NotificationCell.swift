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
    
    @IBOutlet weak var lbl_chat: UILabel!
    @IBOutlet weak var lbl_lock: UILabel!
    @IBOutlet weak var lbl_block: UILabel!
    @IBOutlet weak var lbl_share: UILabel!
    
    @IBOutlet weak var btn_chat: UIButton!
    @IBOutlet weak var btn_lock: UIButton!
    @IBOutlet weak var btn_block: UIButton!
    @IBOutlet weak var btn_share: UIButton!
    @IBOutlet weak var btn_call: UIButton!
    
    //Chat view
    @IBOutlet weak var vw_chatBackView: UIView!
    //Lock view
    @IBOutlet weak var vw_lockBackView: UIView!
    //Block view
    @IBOutlet weak var vw_blockBackView: UIView!
    //Share view
    @IBOutlet weak var vw_shareBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateDefaultUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setNotificationsForQRCode(_ notification: NotificationModel?) {
        if let notification = notification {
            self.updateCell(notification)
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
        
        self.lbl_mobile.font = ConstHelper.h3Normal
        self.lbl_mobile.textColor = ConstHelper.black
        
        self.lbl_chat.font = ConstHelper.h5Normal
        self.lbl_chat.textColor = ConstHelper.black
        self.lbl_lock.font = ConstHelper.h5Normal
        self.lbl_lock.textColor = ConstHelper.black
        self.lbl_block.font = ConstHelper.h5Normal
        self.lbl_block.textColor = ConstHelper.black
        self.lbl_share.font = ConstHelper.h5Normal
        self.lbl_share.textColor = ConstHelper.black
        
        self.vw_chatBackView.addRightBorder(with: ConstHelper.lightGray, andWidth: 1)
        self.vw_lockBackView.addRightBorder(with: ConstHelper.lightGray, andWidth: 1)
        self.vw_blockBackView.addRightBorder(with: ConstHelper.lightGray, andWidth: 1)
        
    }
    
    private func updateCell(_ notification: NotificationModel) {
        self.lbl_personName.text = notification.name
        self.lbl_mobile.text = notification.mobile
        self.lbl_description.text = notification.description
        
        let day = self.getDay(notification.date)
        let mm_yy = self.getMonth_Year(notification.date)
        self.lbl_connected.text = "Connected on \(day) \(mm_yy) at \(notification.connectedLocation)"
    }
    
}
