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
    @IBOutlet weak var btn_qrInfo: UIButton!
    //Top left
    @IBOutlet weak var vw_prodImageBackView: UIView!
    @IBOutlet weak var iv_prodImageView: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_qrGeneratedDate: UILabel!
    @IBOutlet weak var lbl_personType: UILabel!

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
    //Buy
    @IBOutlet weak var vw_buyBackView: UIView!
    @IBOutlet weak var iv_buyImageView: UIImageView!
    @IBOutlet weak var lbl_buyCount: UILabel!
    @IBOutlet weak var btn_buy: UIButton!
    //Delete
    @IBOutlet weak var vw_deleteBackView: UIView!
    @IBOutlet weak var iv_deleteImageView: UIImageView!
    @IBOutlet weak var lbl_deleteCount: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateDefaultUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setQRInformation(_ qrInfo: QrCodeData?) {
        if let qrInfo = qrInfo {
            if let imgUrl = URL(string: qrInfo.productImage ?? "") {
                self.downloadImage(url: imgUrl, imageView: iv_prodImageView)
            }
            
            self.lbl_title.text = qrInfo.title
            self.lbl_personType.text = "As \(qrInfo.personType ?? "")"
            self.lbl_qrGeneratedDate.text = "Generated on \(self.getDateSpecificFormat(qrInfo.qrGeneratedDate ?? ""))"
            self.lbl_bellCount.text = "\(qrInfo.activeCount ?? 0)"
            self.lbl_lockCount.text = "\(qrInfo.lockCount ?? 0)"
            self.lbl_buyCount.text = "\(qrInfo.paidConnections?.count ?? 0)"
            self.lbl_deleteCount.text = "Delete"
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
        self.vw_buyBackView.addRightBorder(with: ConstHelper.lightGray, andWidth: 1)
        
        self.lbl_title.font = ConstHelper.h4Bold
        self.lbl_title.textColor = ConstHelper.cyan
        
        self.lbl_qrGeneratedDate.font = ConstHelper.h6Normal
        self.lbl_qrGeneratedDate.textColor = ConstHelper.gray
        
        self.lbl_personType.font = ConstHelper.h5Normal
        self.lbl_personType.textColor = ConstHelper.gray
        
        self.lbl_deleteCount.font = ConstHelper.h5Normal
        self.lbl_deleteCount.textColor = ConstHelper.red
        
        self.lbl_bellCount.textColor = .black
        self.lbl_lockCount.textColor = .black
        self.lbl_buyCount.textColor = .black
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
