//
//  OrdersTableViewCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 12/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    func setQRInformation(_ qrInfo: QRInfoModel?) {
        if let qrInfo = qrInfo {
            if let imgUrl = URL(string: qrInfo.productImage) {
                self.downloadImage(url: imgUrl, imageView: iv_prodImageView)
            }
            
            self.lbl_personType.text = qrInfo.personType
            self.lbl_qrGeneratedDate.text = self.getDateSpecificFormat(qrInfo.qrGeneratedDate)
            self.lbl_bellCount.text = "\(qrInfo.activeCount)"
            self.lbl_lockCount.text = "\(qrInfo.lockCount)"
            self.lbl_chatCount.text = "\(qrInfo.chatCount)"            
            self.lbl_qrExpireDay.text = self.getDay(qrInfo.expireDate)
            self.lbl_qrExpireMonthYear.text = self.getMonthYear(qrInfo.expireDate)
            self.lbl_qrExpireTitle.text = "Expires"            
        }
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
