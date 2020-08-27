//
//  TermsViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 27/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController {

    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_emergency: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var web: WKWebView!
    
    var loadUrl: String = ""
    var headerTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadTermsOnWeb(loadUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadTermsOnWeb(_ url: String) {
        self.lbl_title.text = headerTitle
        guard let url = URL(string: url) else { return }
        web.load(URLRequest(url: url))
    }

}
