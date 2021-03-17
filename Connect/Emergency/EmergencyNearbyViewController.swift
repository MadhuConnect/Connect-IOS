//
//  EmergencyNearbyViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 25/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class EmergencyNearbyViewController: UIViewController {
    
    @IBOutlet weak var nearByEmegencyTableView: UITableView!
    
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    
    let animationView = AnimationView()
    
    private let client = APIClient()
    var emergencyNotifications: [EmergencyNotifications]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateDefaultUI()
        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        self.postToGetEmergencyRequestNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.nearByEmegencyTableView.tableFooterView = UIView(frame: .zero)
        self.nearByEmegencyTableView.reloadData()
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupAnimation(withAnimation status: Bool, name: String) {
        animationView.animation = Animation.named(name)
        animationView.frame = loadingView.bounds
        animationView.backgroundColor = ConstHelper.white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        if status {
            animationView.play()
            loadingView.addSubview(animationView)
            loadingBackView.isHidden = false
        }
        else {
            animationView.stop()
            loadingBackView.isHidden = true
        }

    }
    
}

extension EmergencyNearbyViewController {
    private func updateDefaultUI() {
        navigationController?.navigationBar.isHidden = true
        self.lbl_title.text = "Nearby Emergencies"
        
        self.nearByEmegencyTableView.delegate = self
        self.nearByEmegencyTableView.dataSource = self
        
        self.lbl_message.font = ConstHelper.h6Normal
        self.lbl_message.textColor = ConstHelper.gray
    }
}


extension EmergencyNearbyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let emergencyNotifications = self.emergencyNotifications {
            return emergencyNotifications.count
        }
            
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emergencyNearByCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.emergencyNearByTableViewCell, for: indexPath) as! EmergencyNearByTableViewCell
        
        if let emergencyNotification = self.emergencyNotifications?[indexPath.row] {
            emergencyNearByCell.setEmergencyNearbyInformation(emergencyNotification)
        }
        
        //Button actions
        emergencyNearByCell.btn_lock.tag = indexPath.row
        emergencyNearByCell.btn_lock.addTarget(self, action: #selector(emergencyLockAction(_:)), for: .touchUpInside)
        emergencyNearByCell.btn_makeCall.tag = indexPath.row
        emergencyNearByCell.btn_makeCall.addTarget(self, action: #selector(makeCallAction(_:)), for: .touchUpInside)
        
        return emergencyNearByCell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    @objc private func emergencyLockAction(_ sender: UIButton) {
        if let emergencyNotification = self.emergencyNotifications?[sender.tag] {
            self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
            self.postToLocktEmergencyRequestNotifications(lock: EmergencyLockStatusReqModel(connectedUserId: emergencyNotification.connectedUserId, emergencyTypeId: emergencyNotification.emergencyTypeId, status: "Lock"))
        }
    }
    
    @objc private func makeCallAction(_ sender: UIButton) {
        if let emergencyNotification = self.emergencyNotifications?[sender.tag] {
            if emergencyNotification.mobile.count > 0 {
                if let url = URL(string: "tel://\(emergencyNotification.mobile)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                } else {
                        self.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "Something went wrong", actionTitle: "Ok")
                        return
                }
            } else {
                self.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "Something went wrong", actionTitle: "Ok")
                return
            }
        } else {
            self.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "Something went wrong", actionTitle: "Ok")
            return
        }
    }
    

}

extension EmergencyNearbyViewController {
    //POST emergency request
    private func postToGetEmergencyRequestNotifications() {
        let parameters = ["status": "Connected"]

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .emergencyNotifications
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)
        
        client.post_EmergencyNotifications(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
            switch result {
            case .success(let result):
                guard  let result = result else { return }

                if result.status {
                    strongSelf.emergencyNotifications = result.data
                    DispatchQueue.main.async {
                        strongSelf.nearByEmegencyTableView.reloadData()
                    }
                } else {
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.lottie_nodata)
                    strongSelf.lbl_message.text = "No Nearby Emergencies"
                }
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                return
            }
        }
        
    }
    
    private func postToLocktEmergencyRequestNotifications(lock emergencyLockStatus: EmergencyLockStatusReqModel) {
        let parameters: EmergencyLockStatusReqModel = EmergencyLockStatusReqModel(connectedUserId: emergencyLockStatus.connectedUserId, emergencyTypeId: emergencyLockStatus.emergencyTypeId, status: emergencyLockStatus.status)
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .emergencyLockStatus
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)
        
        client.post_EmergencyNotifications(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
            switch result {
            case .success(let result):
                guard  let result = result else { return }

                if result.status {
                    DispatchQueue.main.async {
                        strongSelf.postToGetEmergencyRequestNotifications()
                    }
                } else {
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(result.message ?? "")", actionTitle: "Ok")
                    return
                }
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                return
            }
        }
    }
    
}
