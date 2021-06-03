//
//  ChoosePlanCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 20/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import UIKit

class ChoosePlanCell: UITableViewCell {

    @IBOutlet weak var btn_plan: UIButton!
    @IBOutlet weak var lbl_plan: UILabel!
    @IBOutlet weak var lbl_planPrice: UILabel!
    @IBOutlet weak var lbl_planPriceDiscount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.updateDefaultUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setPlan(_ plan: PremiumPlan) {
        self.lbl_plan.text = plan.validity
        self.lbl_planPrice.text = plan.subscriptionPrice
        self.lbl_planPriceDiscount.attributedText = plan.subscriptionDiscount.strikeThorughtext()
    }
}

extension ChoosePlanCell {
    private func updateDefaultUI() {
        self.lbl_plan.font = ConstHelper.h5Normal
        self.lbl_plan.textColor = ConstHelper.black
        
        self.lbl_planPrice.font = ConstHelper.h5Normal
        self.lbl_planPrice.textColor = ConstHelper.black
        
        self.lbl_planPrice.font = ConstHelper.h5Normal
        self.lbl_planPrice.textColor = ConstHelper.white
        
        self.lbl_planPriceDiscount.font = ConstHelper.h5Normal
        self.lbl_planPriceDiscount.textColor = ConstHelper.black
    }
}
