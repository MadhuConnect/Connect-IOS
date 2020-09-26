//
//  EmergencyTypesCollectionViewCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 26/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class EmergencyTypesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var vw_emergencyBackView: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var iv_typeImgView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setSelectedCellAppearance(lbl_title) : setDeselectedCellAppearance(lbl_title)
        }
    }
    
    func setSelectedCellAppearance(_ label: UILabel) {
        lbl_title.font = ConstHelper.h5Bold
        lbl_title.textColor = ConstHelper.orange
    }
    
    func setDeselectedCellAppearance(_ label: UILabel) {
        lbl_title.font = ConstHelper.h5Normal
        lbl_title.textColor = ConstHelper.black
    }
    
    func setEmergencyTypeCell(_ image: String?, title: String?) {
        self.vw_emergencyBackView.setBorderForView(width: 1, color: ConstHelper.white, radius: 10)
        
         if let imgUrl = URL(string: image ?? "") {
             self.downloadImage(url: imgUrl)
         }
         
         self.lbl_title.text = title
        
     }
    
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: iv_typeImgView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 10)
        self.iv_typeImgView.kf.indicatorType = .activity
        iv_typeImgView.kf.setImage(
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

