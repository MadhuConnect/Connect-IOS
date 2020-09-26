//
//  BloodGroupsCollectionViewCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 26/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class BloodGroupsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var vw_bloodBackView: UIView!
    @IBOutlet weak var lbl_type: UILabel!
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setSelectedCellAppearance(lbl_type, view: vw_bloodBackView) : setDeselectedCellAppearance(lbl_type, view: vw_bloodBackView)
        }
    }
    
    func setSelectedCellAppearance(_ label: UILabel, view: UIView) {
        lbl_type.font = ConstHelper.h5Bold
        lbl_type.textColor = ConstHelper.white
        
        view.backgroundColor = ConstHelper.cyan
        view.setBorderForView(width: 1, color: ConstHelper.cyan, radius: 10)
    }
    
    func setDeselectedCellAppearance(_ label: UILabel, view: UIView) {
        lbl_type.font = ConstHelper.h5Bold
        lbl_type.textColor = ConstHelper.black
        
        view.backgroundColor = ConstHelper.white
        view.setBorderForView(width: 1, color: ConstHelper.cyan, radius: 10)
    }
    
    func setBloodGroupsCell(_ type: String?) {
         self.lbl_type.text = type        
     }
}
