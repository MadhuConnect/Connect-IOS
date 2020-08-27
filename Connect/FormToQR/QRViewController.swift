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

    var qrInfo: QRInfoModel?
    
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
        self.vw_qrEditBackView.addShadow(offset: CGSize(width:0, height: 1), color: ConstHelper.gray, radius: vw_qrEditBackView.frame.height / 2, opacity: 0.50)
        
        self.vw_qrShareBackView.setBorderForView(width: 0, color: ConstHelper.white, radius: vw_qrShareBackView.frame.size.height / 2)
        self.vw_qrShareBackView.addShadow(offset: CGSize(width: 0, height: 1), color: ConstHelper.gray, radius: vw_qrShareBackView.frame.height / 2, opacity: 0.50)
    }
}

extension QRViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.qrInfo {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let qrCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.qRCellIdentifier, for: indexPath) as! QRCell
        
        if let _ = self.qrInfo {
            qrCell.setQRInformation(qrInfo)
        }
        
        return qrCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 870
    }
}
