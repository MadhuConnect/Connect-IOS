//
//  CategoryCollectionCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 08/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var vw_productBackView: UIView!
    @IBOutlet weak var lbl_titleLbl: UILabel!
    @IBOutlet weak var iv_productImgView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setSelectedCellAppearance(lbl_titleLbl) : setDeselectedCellAppearance(lbl_titleLbl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbl_titleLbl.font = ConstHelper.h5Normal
        lbl_titleLbl.textColor = ConstHelper.black
    }
    
    func setCategoryCell(_ image: String?, title: String?) {
        if let imgUrl = URL(string: image ?? "") {
            self.downloadImage(url: imgUrl)
        }
        
        self.lbl_titleLbl.text = title
        
        self.vw_productBackView.setBorderForView(width: 1, color: UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 0.5), radius: 10)
       
    }
    
    func setSelectedCellAppearance(_ label: UILabel) {
        lbl_titleLbl.font = ConstHelper.h5Bold
        lbl_titleLbl.textColor = ConstHelper.orange
    }
    
    func setDeselectedCellAppearance(_ label: UILabel) {
        lbl_titleLbl.font = ConstHelper.h5Normal
        lbl_titleLbl.textColor = ConstHelper.black
    }
    
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: iv_productImgView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 10)
        self.iv_productImgView.kf.indicatorType = .activity
        iv_productImgView.kf.setImage(
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
