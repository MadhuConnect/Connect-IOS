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
    
    @IBOutlet weak var vw_qrNotifyBackView: UIView!
    @IBOutlet weak var iv_qrNotifyImageView: UIImageView!
    
    @IBOutlet weak var vw_qrEditBackView: UIView!
    @IBOutlet weak var iv_qrEditImageView: UIImageView!
 
    @IBOutlet weak var vw_qrBuyBackView: UIView!
    @IBOutlet weak var iv_qrBuyImageView: UIImageView!
    
    @IBOutlet weak var btn_notifyQR: UIButton!
    @IBOutlet weak var btn_editQR: UIButton!
    @IBOutlet weak var btn_buyQR: UIButton!

    private let client = APIClient()
    
    var qrInfo: QrCodeData?
    var isNotificationTurnOn: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.tv_qrTableView.delegate = self
        self.tv_qrTableView.dataSource = self
                
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUIWhenViewWillAppear()
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func notificationOnOffQRAction(_ sender: UIButton) {
        guard let qrId = self.qrInfo?.qrId else {
            return
        }
        
        let notificationTurnOn = self.isNotificationTurnOn ?? false
        
        if notificationTurnOn {
            self.notificationOnOff(qrId, notificationStatus: false)
        } else {
            self.notificationOnOff(qrId, notificationStatus: true)
        }
        
    }
    
    @IBAction func editQRAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Form", bundle: nil)
        if let formFilllingVC = storyboard.instantiateViewController(withIdentifier: "FormFilllingViewController") as? FormFilllingViewController {
            formFilllingVC.modalPresentationStyle = .fullScreen
            formFilllingVC.editQRInfo = qrInfo
            formFilllingVC.isFromEditQRInfo = true
            self.present(formFilllingVC, animated: true, completion: nil)
         }
    }
    
    @IBAction func buyQRAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Notification", bundle: nil)
        if let paidUsersVC = storyboard.instantiateViewController(withIdentifier: "PaidUsersViewController") as? PaidUsersViewController {
            paidUsersVC.modalPresentationStyle = .fullScreen
            paidUsersVC.qrInfo = qrInfo
            self.present(paidUsersVC, animated: true, completion: nil)
         }
    }
    
    @IBAction func emergencyReqAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
        if let emergencyRequestVC = storyboard.instantiateViewController(withIdentifier: "EmergencyRequestViewController") as? EmergencyRequestViewController {
            emergencyRequestVC.modalPresentationStyle = .fullScreen
            self.present(emergencyRequestVC, animated: true, completion: nil)
        }
    }
    
}

extension QRViewController {
    private func updateDefaultUI() {
        self.vw_qrEditBackView.setBorderForView(width: 0, color: ConstHelper.white, radius: vw_qrEditBackView.frame.size.height / 2)
        self.vw_qrEditBackView.addShadow(offset: CGSize(width:0, height: 1), color: ConstHelper.gray, radius: vw_qrEditBackView.frame.height / 2, opacity: 0.50)
        
        self.vw_qrNotifyBackView.setBorderForView(width: 0, color: ConstHelper.white, radius: vw_qrNotifyBackView.frame.size.height / 2)
        self.vw_qrNotifyBackView.addShadow(offset: CGSize(width: 0, height: 1), color: ConstHelper.gray, radius: vw_qrNotifyBackView.frame.height / 2, opacity: 0.50)
        
        self.vw_qrBuyBackView.setBorderForView(width: 0, color: ConstHelper.white, radius: vw_qrBuyBackView.frame.size.height / 2)
        self.vw_qrBuyBackView.addShadow(offset: CGSize(width: 0, height: 1), color: ConstHelper.gray, radius: vw_qrBuyBackView.frame.height / 2, opacity: 0.50)
        
        
        self.tv_qrTableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func updateUIWhenViewWillAppear() {
        let notificationTurnOn = self.qrInfo?.turnOn ?? false
        
        if notificationTurnOn {
            self.isNotificationTurnOn = true
            self.iv_qrNotifyImageView.image = UIImage(named: "cyn_bell")
        } else {
            self.isNotificationTurnOn = false
            self.iv_qrNotifyImageView.image = UIImage(named: "cyn_mutedbell")
        }
        
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


extension QRViewController {
    //Post to lock users
    private func notificationOnOff(_ qrId: Int, notificationStatus: Bool) {
        let parameters: NotificationStatusReqModel = NotificationStatusReqModel(qrId: qrId, status: notificationStatus)

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .notificationsStatus

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        client.post_NotificationsOnOff(from: endpoint) { [weak self] result in
             guard let strongSelf = self else { return }
//            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
             switch result {
             case .success(let response):
                 guard let response = response else { return }
                 
                 if response.status {
                    if response.turnOn {
                        strongSelf.isNotificationTurnOn = true
                        strongSelf.iv_qrNotifyImageView.image = UIImage(named: "cyn_bell")
                    } else {
                        strongSelf.isNotificationTurnOn = false
                        strongSelf.iv_qrNotifyImageView.image = UIImage(named: "cyn_mutedbell")
                    }
                    
                 } else {
//                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.error_animation)
                 }
             case .failure(let error):
                 strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
             }
         }
    }
}
