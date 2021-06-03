//
//  SubscriptionCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 25/02/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class SubscriptionCell: UICollectionViewCell {
    
    @IBOutlet weak var iv_subcribeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        iv_subcribeImageView.contentMode = .scaleAspectFit
//        iv_subcribeImageView.image = UIImage(named: "dummyBanner")
    }
    
    func setB2bApprovedCell(_ image: String?) {
        if let imgUrl = URL(string: image ?? "") {
            self.downloadImage(url: imgUrl)
        }
    }
    
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: iv_subcribeImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 10)
        self.iv_subcribeImageView.kf.indicatorType = .activity
        iv_subcribeImageView.kf.setImage(
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
