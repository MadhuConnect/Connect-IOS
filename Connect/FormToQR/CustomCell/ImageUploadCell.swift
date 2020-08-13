//
//  ImageUploadCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class ImageUploadCell: UICollectionViewCell {
    
    @IBOutlet weak var vw_uploadBackView: UIView!
    @IBOutlet weak var iv_uploadImageView: UIImageView!
    
    
    func setPhotoCellData(_ image: UIImage?) {
        self.vw_uploadBackView.setBorderForView(width: 1, color: .white, radius: 10)
        self.iv_uploadImageView.setBorderForView(width: 1, color: .white, radius: 10)
        self.iv_uploadImageView.image = image
    }
    
    
}
