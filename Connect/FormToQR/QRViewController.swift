//
//  QRViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 07/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {
    
    @IBOutlet weak var tv_qrTableView: UITableView!
    @IBOutlet weak var vw_qrEditShareBackView: UIView!
    @IBOutlet weak var vw_qrEditBackView: UIView!
    @IBOutlet weak var iv_qrEditImageView: UIImageView!
    @IBOutlet weak var vw_qrShareBackView: UIView!
    @IBOutlet weak var iv_qrShareImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.tv_qrTableView.delegate = self
        self.tv_qrTableView.dataSource = self
                
        self.updateDefaultUI()
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension QRViewController {
    private func updateDefaultUI() {
        self.vw_qrEditBackView.setBorderForView(width: 0, color: ConstHelper.white, radius: vw_qrEditBackView.frame.size.height / 2)
//        self.vw_qrEditBackView.addShadow(shadowColor: ConstHelper.black, offSet: CGSize(width: 2.6, height: 2.6), opacity: 0.8, shadowRadius: 5.0, cornerRadius: vw_qrEditBackView.frame.size.height / 2, corners: [.allCorners], fillColor: .white)
        self.vw_qrEditBackView.addShadow(offset: CGSize(width:0, height: 1), color: ConstHelper.gray, radius: vw_qrEditBackView.frame.height / 2, opacity: 0.50)
        
        self.vw_qrShareBackView.setBorderForView(width: 0, color: ConstHelper.white, radius: vw_qrShareBackView.frame.size.height / 2)
//        self.vw_qrShareBackView.addShadow(shadowColor: ConstHelper.black, offSet: CGSize(width: 2.6, height: 2.6), opacity: 0.8, shadowRadius: 5.0, cornerRadius: vw_qrShareBackView.frame.size.height / 2, corners: [.allCorners], fillColor: .white)
        self.vw_qrShareBackView.addShadow(offset: CGSize(width: 0, height: 1), color: ConstHelper.gray, radius: vw_qrShareBackView.frame.height / 2, opacity: 0.50)
    }
}

extension QRViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.qRCellIdentifier, for: indexPath)
    
        return formCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 870
    }
}
