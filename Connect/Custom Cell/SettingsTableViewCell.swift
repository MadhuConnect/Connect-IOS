//
//  SettingsTableViewCell.swift
//  Connect
//
//  Created by Venkatesh Botla on 27/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iv_settingImgView: UIImageView!
    @IBOutlet weak var lbl_settingName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSettingsCell(_ image: UIImage?, name: String) {
        self.iv_settingImgView.image = image
        self.lbl_settingName.text = name
    }

}
