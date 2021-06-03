//
//  QRAlphaViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 24/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import UIKit

class QRAlphaViewController: UIViewController {

    @IBOutlet weak var vw_backView: UIView!
    @IBOutlet weak var btn_home: UIButton!
    
    var b2bRequest: B2bRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vw_backView.layer.borderWidth = 6
        vw_backView.layer.cornerRadius = 11
        vw_backView.layer.borderColor = UIColor(hex: "#BFC5F4")?.cgColor
        btn_home.layer.cornerRadius = 2
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        Switcher.updateRootViewController(setTabIndex: 0)
    }
    
}
