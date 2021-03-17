//
//  EmergencyTypesCollectionViewCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 26/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class EmergencyTypesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var vw_emergencyBackView: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var iv_typeImgView: UIImageView!
    
    let animationView = AnimationView()
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setSelectedCellAppearance(lbl_title) : setDeselectedCellAppearance(lbl_title)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbl_title.font = ConstHelper.h5Normal
        lbl_title.textColor = ConstHelper.black
    }
    
    func setSelectedCellAppearance(_ label: UILabel) {
        lbl_title.font = ConstHelper.h5Bold
        lbl_title.textColor = ConstHelper.orange
    }
    
    func setDeselectedCellAppearance(_ label: UILabel) {
        lbl_title.font = ConstHelper.h5Normal
        lbl_title.textColor = ConstHelper.black
    }
    
    func setEmergencyTypeCell(_ image: String?, title: String?, lottie: String) {
        self.vw_emergencyBackView.setBorderForView(width: 1, color: ConstHelper.white, radius: 10)
        
        self.setupAnimation(withAnimation: true, name: lottie)
         
         self.lbl_title.text = title
        
     }
    
    private func setupAnimation(withAnimation status: Bool, name: String) {
        animationView.animation = Animation.named(name)
        animationView.frame = vw_emergencyBackView.bounds
        animationView.backgroundColor = ConstHelper.white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        vw_emergencyBackView.addSubview(animationView)
    }
    
}

