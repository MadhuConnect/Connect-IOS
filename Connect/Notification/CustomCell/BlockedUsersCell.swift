//
//  BlockedUsersCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 23/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class BlockedUsersCell: UITableViewCell {
    
    @IBOutlet weak var vw_notifyBackView: UIView!
    @IBOutlet weak var vw_topBackView: UIView!
    @IBOutlet weak var vw_middleBackView: UIView!
    @IBOutlet weak var vw_bottomBackView: UIView!
    
    @IBOutlet weak var lbl_personName: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    
    @IBOutlet weak var lbl_block: UILabel!
    
    @IBOutlet weak var btn_block: UIButton!
    @IBOutlet weak var btn_call: UIButton!
    
    //Lock view
    @IBOutlet weak var vw_unBlockBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateDefaultUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setBlockedUsersCellForQRCode(_ blockedUser: BlockedUsers?) {
        if let blockedUser = blockedUser {
            self.updateCell(blockedUser)
        }
    }
    
}

extension BlockedUsersCell {
    private func updateDefaultUI() {
        self.vw_notifyBackView.setBorderForView(width: 1, color: ConstHelper.white, radius: 10)
        self.vw_middleBackView.backgroundColor = ConstHelper.lightGray
        
        self.lbl_personName.font = ConstHelper.h3Normal
        self.lbl_personName.textColor = ConstHelper.black
        
        self.lbl_mobile.font = ConstHelper.h3Normal
        self.lbl_mobile.textColor = ConstHelper.black
        
        self.lbl_block.font = ConstHelper.h5Normal
        self.lbl_block.textColor = ConstHelper.black
        
    }
    
    private func updateCell(_ blockedUser: BlockedUsers) {
        self.lbl_personName.text = blockedUser.name
        self.lbl_mobile.text = blockedUser.mobile
    }
    
}
