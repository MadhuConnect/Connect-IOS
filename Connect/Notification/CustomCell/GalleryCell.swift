//
//  GalleryCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 04/03/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var iv_galleryImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .clear
        iv_galleryImgView.contentMode = .scaleAspectFit
    }
    
    func setGalleryCell(_ imageUrl: String?) {
        if let imgUrl = URL(string: imageUrl ?? "") {
            self.downloadImage(url: imgUrl)
        }
    }
    
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: iv_galleryImgView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        self.iv_galleryImgView.kf.indicatorType = .activity
        iv_galleryImgView.kf.setImage(
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

