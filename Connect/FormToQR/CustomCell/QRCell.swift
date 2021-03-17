//
//  QRCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class QRCell: UITableViewCell {
    
    @IBOutlet weak var cv_sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    @IBOutlet weak var vw_qrCodeBackView: UIView!
    @IBOutlet weak var vw_qrLineView: UIView!
    @IBOutlet weak var vw_nameLineView: UIView!
    @IBOutlet weak var vw_productTypeView: UIView!
    @IBOutlet weak var vw_typeLineView: UIView!
    @IBOutlet weak var vw_descriptionLineView: UIView!
    @IBOutlet weak var vw_priceLineView: UIView!
    @IBOutlet weak var vw_titleLineView: UIView!
    @IBOutlet weak var vw_rangeLineView: UIView!
    
    //QR Code
    @IBOutlet weak var lbl_qrCodeHeading: UILabel!
    @IBOutlet weak var iv_qrCode: UIImageView!
    //Person type
    @IBOutlet weak var lbl_personTypeHeading: UILabel!
    @IBOutlet weak var lbl_personTypeValue: UILabel!
    //Product name
    @IBOutlet weak var lbl_productNameHeading: UILabel!
    @IBOutlet weak var lbl_productNameValue: UILabel!
    //Product type
    @IBOutlet weak var lbl_productTypeHeading: UILabel!
    @IBOutlet weak var lbl_productTypeValue: UILabel!
    //Description
    @IBOutlet weak var lbl_descHeading: UILabel!
    @IBOutlet weak var lbl_descValue: UILabel!
    //Price range
    @IBOutlet weak var lbl_priceRangeHeading: UILabel!
    @IBOutlet weak var lbl_priceRangeValue: UILabel!
    //Expires on
    @IBOutlet weak var lbl_titleHeading: UILabel!
    @IBOutlet weak var lbl_titleValue: UILabel!
    //Person type
    @IBOutlet weak var lbl_connectRangeHeading: UILabel!
    @IBOutlet weak var lbl_connectRangeValue: UILabel!
    
    @IBOutlet weak var slideImageHeight: NSLayoutConstraint!
    @IBOutlet weak var descripitonTopContraint: NSLayoutConstraint!
    
    //slide images
    var qrImages: [QRCodeImageModel]?
    
    var timer = Timer()
    var counter = 0
    let rupee = "\u{20B9}"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = ConstHelper.white
        self.updateDefaultUI()
        
        self.cv_sliderCollectionView.delegate = self
        self.cv_sliderCollectionView.dataSource = self
        
        self.loadPageView()
    }
    
    func loadPageView() {
        if let qrImages = self.qrImages {
            pageView.numberOfPages = qrImages.count
            pageView.currentPage = 0
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func changeImage() {
        if let qrImages = self.qrImages {
            if counter < qrImages.count {
                let index = IndexPath.init(item: counter, section: 0)
                self.cv_sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                pageView.currentPage = counter
                counter += 1
            } else {
                counter = 0
                let index = IndexPath.init(item: counter, section: 0)
                self.cv_sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                pageView.currentPage = counter
                counter = 1
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setQRInformation(_ qrInfo: QrCodeData?) {
        if let qrInfo = qrInfo {
            self.iv_qrCode.image = generateQRCode(from: qrInfo.qrCode ?? "")
            lbl_personTypeValue.text = qrInfo.personType
            lbl_productNameValue.text = qrInfo.productName
            lbl_productTypeValue.text = qrInfo.productType
            lbl_descValue.text = qrInfo.description
            lbl_priceRangeValue.text = "\(rupee)\(qrInfo.minAmount ?? 0)" + " - " + "\(rupee)\(qrInfo.maxAmount ?? 0)"
            lbl_titleValue.text = qrInfo.title
            lbl_connectRangeValue.text = qrInfo.connectRange
            self.qrImages = qrInfo.images
            
            if let images = self.qrImages, (images.count != 0) {
                self.slideImageHeight.constant = 220
            } else {
                self.slideImageHeight.constant = 0
            }
            
            if let productType = qrInfo.productType, (productType.lowercased().elementsEqual("New".lowercased()) || productType.lowercased().elementsEqual("Used".lowercased())) {
                self.descripitonTopContraint.constant = 12
                self.vw_productTypeView.isHidden = false
                self.vw_typeLineView.isHidden = false
            } else {
                self.descripitonTopContraint.constant = -60
                self.vw_productTypeView.isHidden = true
                self.vw_typeLineView.isHidden = true
            }
            
            DispatchQueue.main.async {
                self.loadPageView()
                self.cv_sliderCollectionView.reloadData()
            }
        }
    }
    
}

extension QRCell {
    private func updateDefaultUI() {
        self.vw_qrCodeBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        self.vw_qrLineView.backgroundColor = ConstHelper.gray
        self.vw_nameLineView.backgroundColor = ConstHelper.gray
        self.vw_typeLineView.backgroundColor = ConstHelper.gray
        self.vw_descriptionLineView.backgroundColor = ConstHelper.gray
        self.vw_rangeLineView.backgroundColor = ConstHelper.gray
        self.vw_titleLineView.backgroundColor = ConstHelper.gray
        self.vw_rangeLineView.backgroundColor = ConstHelper.gray
        
        self.lbl_titleValue.font = ConstHelper.h3Normal
        self.lbl_titleValue.textColor = ConstHelper.black
        
        self.lbl_personTypeValue.font = ConstHelper.h3Normal
        self.lbl_personTypeValue.textColor = ConstHelper.black
        
        self.lbl_productNameValue.font = ConstHelper.h3Normal
        self.lbl_productNameValue.textColor = ConstHelper.black
        
        self.lbl_productTypeValue.font = ConstHelper.h3Normal
        self.lbl_productTypeValue.textColor = ConstHelper.black
        
        self.lbl_descValue.font = ConstHelper.h3Normal
        self.lbl_descValue.textColor = ConstHelper.black
        
        self.lbl_priceRangeValue.font = ConstHelper.h3Normal
        self.lbl_priceRangeValue.textColor = ConstHelper.black
        
        self.lbl_connectRangeValue.font = ConstHelper.h3Normal
        self.lbl_connectRangeValue.textColor = ConstHelper.black
        
        self.lbl_qrCodeHeading.font = ConstHelper.h6Normal
        self.lbl_qrCodeHeading.textColor = ConstHelper.black
        
        self.lbl_personTypeHeading.font = ConstHelper.h6Normal
        self.lbl_personTypeHeading.textColor = ConstHelper.black
        
        self.lbl_productNameHeading.font = ConstHelper.h6Normal
        self.lbl_productNameHeading.textColor = ConstHelper.black
        
        self.lbl_productTypeHeading.font = ConstHelper.h6Normal
        self.lbl_productTypeHeading.textColor = ConstHelper.black
        
        self.lbl_descHeading.font = ConstHelper.h6Normal
        self.lbl_descHeading.textColor = ConstHelper.black
        
        self.lbl_priceRangeHeading.font = ConstHelper.h6Normal
        self.lbl_priceRangeHeading.textColor = ConstHelper.black
        
        self.lbl_titleHeading.font = ConstHelper.h6Normal
        self.lbl_titleHeading.textColor = ConstHelper.black
        
        self.lbl_connectRangeHeading.font = ConstHelper.h6Normal
        self.lbl_connectRangeHeading.textColor = ConstHelper.black
        
    }
}

extension QRCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let qrImages = self.qrImages {
            return qrImages.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sliderCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.sliderCellIdentifier, for: indexPath) as! SlideCollectionViewCell
        
        if let qrImage = self.qrImages?[indexPath.row] {
            sliderCell.setQRSlider(qrImage)
        }

        return sliderCell
    }
}

extension QRCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = cv_sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
