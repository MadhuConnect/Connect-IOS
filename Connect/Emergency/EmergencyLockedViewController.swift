//
//  EmergencyLockedViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 25/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class EmergencyLockedViewController: UIViewController {
    
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateDefaultUI()
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension EmergencyLockedViewController {
    private func updateDefaultUI() {
        navigationController?.navigationBar.isHidden = true
        self.lbl_title.text = "Locked Emergencies"
    }
}
