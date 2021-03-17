//
//  SlideCollectionViewCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 13/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class SlideCollectionViewCell: UICollectionViewCell {
    
     @IBOutlet weak var iv_slideImageView: UIImageView!
    
    func setQRSlider(_ qrImage: QRCodeImageModel?) {
        if let imgUrl = URL(string: qrImage?.productImage ?? "") {
            self.downloadImage(url: imgUrl, imageView: iv_slideImageView)
        }
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
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                })
    }
}
