//
//  AdPremiumListCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 20/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class AdPremiumListCell: UICollectionViewCell {
    
    @IBOutlet weak var iv_brandLogo: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.setBorderForView(width: 0, color: .clear, radius: 10)
        iv_brandLogo.contentMode = .scaleAspectFill
    }
    
    func setB2bApprovedCell(_ image: String?) {
        if let imgUrl = URL(string: image ?? "") {
            self.downloadImage(url: imgUrl)
        }
    }
    
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: iv_brandLogo.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 10)
        self.iv_brandLogo.kf.indicatorType = .activity
        iv_brandLogo.kf.setImage(
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
