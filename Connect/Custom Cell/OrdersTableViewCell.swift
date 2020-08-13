//
//  OrdersTableViewCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 12/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vw_ordersBackView: UIView!
    @IBOutlet weak var vw_topBackView: UIView!
    @IBOutlet weak var vw_middleBackView: UIView!
    @IBOutlet weak var vw_bottomBackView: UIView!
   
    //Top
    //Top left
    @IBOutlet weak var vw_prodImageBackView: UIView!
    @IBOutlet weak var iv_prodImageView: UIImageView!
    @IBOutlet weak var lbl_personType: UILabel!
    @IBOutlet weak var lbl_qrGeneratedDate: UILabel!
    //Top right
    @IBOutlet weak var vw_expireDateBackView: UIView!
    @IBOutlet weak var lbl_qrExpireDay: UILabel!
    @IBOutlet weak var lbl_qrExpireMonthYear: UILabel!
    @IBOutlet weak var lbl_qrExpireTitle: UILabel!
    //Bottom
    //Bell
    @IBOutlet weak var vw_bellBackView: UIView!
    @IBOutlet weak var iv_bellImageView: UIImageView!
    @IBOutlet weak var lbl_bellCount: UILabel!
    @IBOutlet weak var btn_bell: UIButton!
    //Lock
    @IBOutlet weak var vw_lockBackView: UIView!
    @IBOutlet weak var iv_lockImageView: UIImageView!
    @IBOutlet weak var lbl_lockCount: UILabel!
    @IBOutlet weak var btn_lock: UIButton!
    //Chat
    @IBOutlet weak var vw_chatBackView: UIView!
    @IBOutlet weak var iv_chatImageView: UIImageView!
    @IBOutlet weak var lbl_chatCount: UILabel!
    @IBOutlet weak var btn_chat: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateDefaultUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension OrdersTableViewCell {
    private func updateDefaultUI() {
        self.vw_ordersBackView.setBorderForView(width: 1, color: ConstHelper.white, radius: 10)
        self.vw_prodImageBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        self.vw_middleBackView.backgroundColor = ConstHelper.lightGray
        self.vw_bellBackView.addRightBorder(with: ConstHelper.lightGray, andWidth: 1)
        self.vw_lockBackView.addRightBorder(with: ConstHelper.lightGray, andWidth: 1)
        
    }
}
