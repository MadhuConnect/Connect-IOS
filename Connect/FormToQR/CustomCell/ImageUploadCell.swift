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
    @IBOutlet weak var vw_deleteView: UIView!
    @IBOutlet weak var btn_delete: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateDefaultUI()
        
    }
    
    func setPhotoCellData(_ image: UIImage?) {
        
        self.iv_uploadImageView.image = image
    }
    
    
}

extension ImageUploadCell {
    private func updateDefaultUI() {
        self.vw_uploadBackView.setBorderForView(width: 1, color: .white, radius: 10)
        self.iv_uploadImageView.setBorderForView(width: 1, color: .white, radius: 10)
      
        self.vw_deleteView.backgroundColor = ConstHelper.red
        self.vw_deleteView.addLeftBorder(with: .white, andWidth: 1)
        self.vw_deleteView.addRightBorder(with: .white, andWidth: 1)
        
        self.vw_deleteView.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        
        //Delete button
        self.btn_delete.setTitleColor(ConstHelper.white, for: .normal)
        self.btn_delete.titleLabel?.font = ConstHelper.h4Bold
        
    }
}
