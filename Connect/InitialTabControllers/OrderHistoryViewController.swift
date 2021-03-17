//
//  OrderHistoryViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 07/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class OrderHistoryViewController: UIViewController {
    
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var vw_orderTableBackView: UIView!
    
    @IBOutlet weak var emergencyTableView: UITableView!
    @IBOutlet weak var vw_emergencyTableBackView: UIView!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    
    //Orders Type
    @IBOutlet weak var vw_odersType: UIView!
    @IBOutlet weak var vw_odersReq: UIView!
    @IBOutlet weak var vw_emergencyReq: UIView!
    @IBOutlet weak var btn_odersReq: UIButton!
    @IBOutlet weak var btn_emergencyReq: UIButton!
    
    // Lottie
    @IBOutlet weak var loadingAlphaBackView: UIView!
    @IBOutlet weak var deleteBackView: UIView!
    @IBOutlet weak var deleteLoadView: UIView!
    @IBOutlet weak var lbl_deleteMessage: UILabel!
    
    let animationView = AnimationView()
    let deleteAnimationView = AnimationView()
    
    private let client = APIClient()
    var qrCodeData: [QrCodeData]?
    var filterQrCodeData: [QrCodeData]?
    
    var emergenctData: [EmergenctData]?
    var filterEmergenctData: [EmergenctData]?
    
    var isSearchEnable: Bool = false
    
    var isOrdersReqsEnable: Bool = false
    var isEmergencyReqsEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.orderTableView.delegate = self
        self.orderTableView.dataSource = self
        self.orderTableView.tableFooterView = UIView(frame: .zero)
        
        self.emergencyTableView.delegate = self
        self.emergencyTableView.dataSource = self
        self.emergencyTableView.tableFooterView = UIView(frame: .zero)
        
        self.updateDefaultUI()
        
         loadingBackView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIWhenViewWillAppear()
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
    
    private func setupDeleteAnimation(withAnimation status: Bool, name: String) {
        deleteAnimationView.animation = Animation.named(name)
        deleteAnimationView.frame = deleteLoadView.bounds
        deleteAnimationView.backgroundColor = ConstHelper.white
        deleteAnimationView.contentMode = .scaleAspectFit
        deleteAnimationView.loopMode = .loop
        if status {
            animationView.play()
            deleteLoadView.addSubview(deleteAnimationView)
            loadingAlphaBackView.isHidden = false
        }
        else {
            animationView.stop()
            loadingAlphaBackView.isHidden = true
        }

    }

    @IBAction func ordersTypeAction(_ sender: UIButton) {
        switch sender.tag {
        case 1001:
            self.isOrdersReqsEnable = true
            self.isEmergencyReqsEnable = false
            self.activeRequests(vw_odersReq, button: btn_odersReq)
            self.inActiveRequests(vw_emergencyReq, button: btn_emergencyReq)
            self.vw_orderTableBackView.isHidden = false
            self.vw_emergencyTableBackView.isHidden = true
            
            self.showNoDataWhenNoDataInResponse(self.qrCodeData?.count ?? 0)
        case 1002:
            self.isEmergencyReqsEnable = true
            self.isOrdersReqsEnable = false
            self.activeRequests(vw_emergencyReq, button: btn_emergencyReq)
            self.inActiveRequests(vw_odersReq, button: btn_odersReq)
            self.vw_orderTableBackView.isHidden = true
            self.vw_emergencyTableBackView.isHidden = false
            
            self.showNoDataWhenNoDataInResponse(self.emergenctData?.count ?? 0)
        default:
            break
        }
    }
    
    private func showNoDataWhenNoDataInResponse(_ count: Int) {
        if count == 0 {
            self.setupAnimation(withAnimation: true, name: ConstHelper.lottie_nodata)
            self.lbl_message.text = "No orders"
        } else {
            self.setupAnimation(withAnimation: false, name: ConstHelper.lottie_nodata)
            self.lbl_message.text = ""
        }
        
        
    }
}

extension OrderHistoryViewController {
    private func updateDefaultUI() {
        self.vw_orderTableBackView.isHidden = true
        self.vw_emergencyTableBackView.isHidden = true
        
        self.lbl_message.font = ConstHelper.h6Normal
        self.lbl_message.textColor = ConstHelper.gray
        
        self.loadingAlphaBackView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
    }
    
    private func updateUIWhenViewWillAppear() {
        self.isOrdersReqsEnable = true
        self.isEmergencyReqsEnable = false
        self.loadingAlphaBackView.isHidden = true
        
        self.activeRequests(vw_odersReq, button: btn_odersReq)
        self.inActiveRequests(vw_emergencyReq, button: btn_emergencyReq)
        
        self.setupDeleteAnimation(withAnimation: false, name: ConstHelper.lottie_delete)
        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        self.lbl_message.text = "Loading your orders..."
        self.getMyOrders()
    }
    
    private func activeRequests(_ view: UIView, button: UIButton) {
        view.backgroundColor = ConstHelper.red
        button.backgroundColor = ConstHelper.cyan
        button.setTitleColor(ConstHelper.red, for: .normal)
        button.titleLabel?.font = ConstHelper.h5Bold
    }
    
    private func inActiveRequests(_ view: UIView, button: UIButton) {
        view.backgroundColor = ConstHelper.cyan
        button.backgroundColor = ConstHelper.cyan
        button.setTitleColor(ConstHelper.white, for: .normal)
        button.titleLabel?.font = ConstHelper.h5Bold
    }
}


//MARK: - UITableViewDelegate
extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderTableView {
            if isSearchEnable {
                if let filterQrCodeData = self.filterQrCodeData {
                    return filterQrCodeData.count
                }
            } else {
                if let qrCodeData = self.qrCodeData {
                    return qrCodeData.count
                }
            }
            
        } else {
            if isSearchEnable {
                if let filterEmergenctData = self.filterEmergenctData {
                    return filterEmergenctData.count
                }
            } else {
                if let emergenctData = self.emergenctData {
                    return emergenctData.count
                }
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == orderTableView {
            let ordersCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.ordersCellIdentifier, for: indexPath) as! OrdersTableViewCell

            if isSearchEnable {
                if let qrInfo = self.filterQrCodeData?[indexPath.row] {
                    ordersCell.setQRInformation(qrInfo)
                }
            } else {
                if let qrInfo = self.qrCodeData?[indexPath.row] {
                    ordersCell.setQRInformation(qrInfo)
                }
            }

            //Button actions
            ordersCell.btn_qrInfo.tag = indexPath.row
            ordersCell.btn_qrInfo.addTarget(self, action: #selector(qrInfoAction(_:)), for: .touchUpInside)

            ordersCell.btn_bell.tag = indexPath.row
            ordersCell.btn_bell.addTarget(self, action: #selector(notifyBellAction(_:)), for: .touchUpInside)

            ordersCell.btn_lock.tag = indexPath.row
            ordersCell.btn_lock.addTarget(self, action: #selector(lockUserAction(_:)), for: .touchUpInside)

            ordersCell.btn_buy.tag = indexPath.row
            ordersCell.btn_buy.addTarget(self, action: #selector(buyUserAction(_:)), for: .touchUpInside)

            ordersCell.btn_delete.tag = indexPath.row
            ordersCell.btn_delete.addTarget(self, action: #selector(deleteUserAction(_:)), for: .touchUpInside)
            
            return ordersCell
        } else {
            let emergencyCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.emergencyOrdersTableViewCell, for: indexPath) as! EmergencyOrdersTableViewCell
            
            if isSearchEnable {
                if let emergencyInfo = self.filterEmergenctData?[indexPath.row] {
                    emergencyCell.setEmergencyInformation(emergencyInfo)
                }
            } else {
                if let emergencyInfo = self.emergenctData?[indexPath.row] {
                    emergencyCell.setEmergencyInformation(emergencyInfo)
                }
            }
            
            //Button actions
            emergencyCell.btn_interests.tag = indexPath.row
            emergencyCell.btn_interests.addTarget(self, action: #selector(emergencyInterestsAction(_:)), for: .touchUpInside)

            emergencyCell.btn_delete.tag = indexPath.row
            emergencyCell.btn_delete.addTarget(self, action: #selector(emergencyDeleteAction(_:)), for: .touchUpInside)


            return emergencyCell
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == orderTableView {
            return 140.0
        } else {
            return 160.0
        }
        
    }

    //MARK: - QRCodeData Cell Actions
    @objc private func qrInfoAction(_ sender: UIButton) {
        if let qrInfo = self.qrCodeData?[sender.tag] {
            let storyboard = UIStoryboard(name: "Form", bundle: nil)
            if let qrVC = storyboard.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
                qrVC.modalPresentationStyle = .fullScreen
                qrVC.qrInfo = qrInfo
                self.present(qrVC, animated: true, completion: nil)
             }
        }

    }

    @objc private func notifyBellAction(_ sender: UIButton) {
        if let qrInfo = self.qrCodeData?[sender.tag] {
            if (qrInfo.qrStatus ?? "").lowercased() == "Active".lowercased() {
                let storyboard = UIStoryboard(name: "Notification", bundle: nil)
                if let notificationVC = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController {
                    notificationVC.qrInfo = qrInfo
                    self.navigationController?.pushViewController(notificationVC, animated: true)
                 }
            } else {
                self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "No Data Found", actionTitle: "Ok")
                return
            }
        }

    }

    @objc private func lockUserAction(_ sender: UIButton) {
        if let qrInfo = self.qrCodeData?[sender.tag] {
            if (qrInfo.qrStatus ?? "").lowercased() == "Active".lowercased() {
                let storyboard = UIStoryboard(name: "Notification", bundle: nil)
                if let lockedUsersVC = storyboard.instantiateViewController(withIdentifier: "LockedUsersViewController") as? LockedUsersViewController {
                    lockedUsersVC.modalPresentationStyle = .fullScreen
                    lockedUsersVC.qrInfo = qrInfo
                    self.present(lockedUsersVC, animated: true, completion: nil)
                 }
            } else {
                self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "No Data Found", actionTitle: "Ok")
                return
            }
        }

    }
    
    @objc private func buyUserAction(_ sender: UIButton) {
        if let qrInfo = self.qrCodeData?[sender.tag] {
            if (qrInfo.qrStatus ?? "").lowercased() == "Active".lowercased() {
                let storyboard = UIStoryboard(name: "Notification", bundle: nil)
                if let paidUsersVC = storyboard.instantiateViewController(withIdentifier: "PaidUsersViewController") as? PaidUsersViewController {
                    paidUsersVC.modalPresentationStyle = .fullScreen
                    paidUsersVC.qrInfo = qrInfo
                    self.present(paidUsersVC, animated: true, completion: nil)
                 }
            } else {
                self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "No Data Found", actionTitle: "Ok")
                return
            }
        }
    }
    
    @objc private func deleteUserAction(_ sender: UIButton) {
        if isSearchEnable {
            if let qrInfo = self.filterQrCodeData?[sender.tag] {
                if isOrdersReqsEnable {
                    if let qrCodeId = qrInfo.qrId {
                     self.postDeleteOrders(order: DeleteOrderReqModel(requestId: qrCodeId, status: "Quickneeds"))
                    }
                }
            }
        } else {
            if let qrInfo = self.qrCodeData?[sender.tag] {
                if isOrdersReqsEnable {
                    if let qrCodeId = qrInfo.qrId {
                     self.postDeleteOrders(order: DeleteOrderReqModel(requestId: qrCodeId, status: "Quickneeds"))
                    }
                }
            }
        }
    }

    //MARK: - EmergencyData Cell Actions
    @objc private func emergencyInterestsAction(_ sender: UIButton) {
        if let emergenctData = self.emergenctData?[sender.tag] {
            let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
            if let emergencyInterestVC = storyboard.instantiateViewController(withIdentifier: "EmergencyInterestViewController") as? EmergencyInterestViewController {
                emergencyInterestVC.modalPresentationStyle = .fullScreen
                emergencyInterestVC.interestedPersons = emergenctData.interests
                self.present(emergencyInterestVC, animated: true, completion: nil)
            }
        } else {
            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "No Data Found", actionTitle: "Ok")
            return
        }
    }
    
    @objc private func emergencyDeleteAction(_ sender: UIButton) {
        if isSearchEnable {
            if let emergencyInfo = self.filterEmergenctData?[sender.tag] {
                if isEmergencyReqsEnable {
                    if let emergencyRequestId = emergencyInfo.emergencyRequestId {
                        self.postDeleteOrders(order: DeleteOrderReqModel(requestId: emergencyRequestId, status: "Emergency"))
                    }
                }
            }
        } else {
            if let emergencyInfo = self.emergenctData?[sender.tag] {
                if isEmergencyReqsEnable {
                    if let emergencyRequestId = emergencyInfo.emergencyRequestId {
                     self.postDeleteOrders(order: DeleteOrderReqModel(requestId: emergencyRequestId, status: "Emergency"))
                    }
                }
            }
        }
    }
    
}


//MARK: - API Call
extension OrderHistoryViewController {
    private func getMyOrders() {
        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .myOrders
        
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)
        
        client.post_getMyOrders(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
            switch result {
            case .success(let response):
                guard let response = response else { return }
                
                if response.status {
                    strongSelf.qrCodeData = response.qrCodeData
                    strongSelf.emergenctData = response.emergenctData
                    strongSelf.showNoDataWhenNoDataInResponse(strongSelf.qrCodeData?.count ?? 0)
                    
                    if strongSelf.isOrdersReqsEnable {
                        strongSelf.activeRequests(strongSelf.vw_odersReq, button: strongSelf.btn_odersReq)
                        strongSelf.inActiveRequests(strongSelf.vw_emergencyReq, button: strongSelf.btn_emergencyReq)
                        strongSelf.vw_orderTableBackView.isHidden = false
                        strongSelf.vw_emergencyTableBackView.isHidden = true
                        
                        if let qrCodeData = response.qrCodeData {
                            strongSelf.vw_orderTableBackView.isHidden = qrCodeData.count == 0 ? true : false
                            strongSelf.vw_emergencyTableBackView.isHidden = true
                        }
                        
                        strongSelf.showNoDataWhenNoDataInResponse(strongSelf.qrCodeData?.count ?? 0)
                    } else {
                        strongSelf.activeRequests(strongSelf.vw_emergencyReq, button: strongSelf.btn_emergencyReq)
                        strongSelf.inActiveRequests(strongSelf.vw_odersReq, button: strongSelf.btn_odersReq)
                        strongSelf.vw_orderTableBackView.isHidden = true
                        strongSelf.vw_emergencyTableBackView.isHidden = false
                        
                        if let emergenctData = response.emergenctData {
                            strongSelf.vw_emergencyTableBackView.isHidden = emergenctData.count == 0 ? true : false
                            strongSelf.vw_orderTableBackView.isHidden = true
                        }
                        
                        strongSelf.showNoDataWhenNoDataInResponse(strongSelf.emergenctData?.count ?? 0)

                    }
                    
                    DispatchQueue.main.async {
                        strongSelf.orderTableView.reloadData()
                        strongSelf.emergencyTableView.reloadData()
                    }
                    
                } else {
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.empty_animation)
                }
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
            }
        }
    }
    
    private func postDeleteOrders(order deleteOrder: DeleteOrderReqModel) {
        let parameters: DeleteOrderReqModel = DeleteOrderReqModel(requestId: deleteOrder.requestId, status: deleteOrder.status)
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .deleteOrder
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        self.setupAnimation(withAnimation: true, name: ConstHelper.lottie_delete)
        self.lbl_message.text = "Deleting your order..."
        client.post_deleteOrder(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let result):
                guard  let result = result else { return }

                if result.status {
                    DispatchQueue.main.async {
                        strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
                        strongSelf.lbl_message.text = "Loading your orders..."
                        strongSelf.getMyOrders()
                    }
                } else {
                    strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.lottie_delete)
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(result.message ?? "")", actionTitle: "Ok")
                    return
                }
            case .failure(let error):
                strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.lottie_delete)
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                return
            }
        }
    }
    
    
}
