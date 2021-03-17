//
//  SummaryCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 05/12/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class SummaryCell: UITableViewCell {
    
    @IBOutlet weak var vw_notifyBackView: UIView!
    @IBOutlet weak var vw_topBackView: UIView!
    @IBOutlet weak var vw_middleBackView: UIView!
    @IBOutlet weak var vw_bottomBackView: UIView!
    
    @IBOutlet weak var lbl_personName: UILabel!
    @IBOutlet weak var lbl_connected: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_remove: UILabel!
    
    @IBOutlet weak var vw_removeBackView: UIView!
    @IBOutlet weak var btn_remove: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateDefaultUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setSummaryCell(_ summaryUser: NotificationModel?) {
        if let summaryUser = summaryUser {
            self.updateCell(summaryUser)
        }
    }
    
}

extension SummaryCell {
    private func updateDefaultUI() {
        self.vw_notifyBackView.setBorderForView(width: 1, color: ConstHelper.white, radius: 10)
        self.vw_middleBackView.backgroundColor = ConstHelper.lightGray
        
        self.lbl_personName.font = ConstHelper.h3Normal
        self.lbl_personName.textColor = ConstHelper.black
        
        self.lbl_connected.font = ConstHelper.h6Normal
        self.lbl_connected.textColor = ConstHelper.gray
        
        self.lbl_description.font = ConstHelper.h4Normal
        self.lbl_description.textColor = ConstHelper.black
        
        self.lbl_remove.font = ConstHelper.h5Normal
        self.lbl_remove.textColor = ConstHelper.black
    }
    
    private func updateCell(_ summaryUser: NotificationModel) {
        self.lbl_personName.text = summaryUser.name
        self.lbl_description.text = summaryUser.description

        let day = self.getDay(summaryUser.date ?? "")
        let mm_yy = self.getMonth_Year(summaryUser.date ?? "")
        self.lbl_connected.text = "Connected on \(day) \(mm_yy) at \(summaryUser.connectedLocation ?? "")"
    }
    
}
