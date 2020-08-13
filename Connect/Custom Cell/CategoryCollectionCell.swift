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
    
    func setCategoryCell(_ image: String?, title: String?) {
        if let imgUrl = URL(string: image ?? "") {
            self.downloadImage(url: imgUrl)
        }
        
        self.lbl_titleLbl.text = title
        
        self.vw_productBackView.setBorderForView(width: 1, color: .lightGray, radius: 10)
       
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
