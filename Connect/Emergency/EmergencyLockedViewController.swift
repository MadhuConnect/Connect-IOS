//
//  EmergencyLockedViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 25/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class EmergencyLockedViewController: UIViewController {
    
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
        self.postToGetEmergencyRequestLocked()
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

extension EmergencyLockedViewController {
    private func updateDefaultUI() {
        navigationController?.navigationBar.isHidden = true
        self.lbl_title.text = "Locked Emergencies"
        
        self.nearByEmegencyTableView.delegate = self
        self.nearByEmegencyTableView.dataSource = self
        
        self.lbl_message.font = ConstHelper.h6Normal
        self.lbl_message.textColor = ConstHelper.gray
    }
}


extension EmergencyLockedViewController: UITableViewDelegate, UITableViewDataSource {
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
            self.postToUnLocktEmergencyRequestNotifications(lock: EmergencyLockStatusReqModel(connectedUserId: emergencyNotification.connectedUserId, emergencyTypeId: emergencyNotification.emergencyTypeId, status: "Remove"))
        }
    }
    
    @objc private func makeCallAction(_ sender: UIButton) {
        self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Make call", actionTitle: "Ok")
        return
    }
    

}

extension EmergencyLockedViewController {
    //POST emergency request
    private func postToGetEmergencyRequestLocked() {
        let parameters = ["status": "Lock"]

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
                    strongSelf.lbl_message.text = "No Locked Emergencies"
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.lottie_nodata)
                    return
                }
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                return
            }
        }
        
    }
    
    private func postToUnLocktEmergencyRequestNotifications(lock emergencyLockStatus: EmergencyLockStatusReqModel) {
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
                        strongSelf.postToGetEmergencyRequestLocked()
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
