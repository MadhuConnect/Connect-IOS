//
//  OrderHistoryViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 07/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController {
    
    @IBOutlet weak var orderTableView: UITableView!

    private let client = APIClient()
    var qrInfoModel: [QRInfoModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.orderTableView.delegate = self
        self.orderTableView.dataSource = self
        self.orderTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let userId = UserDefaults.standard.value(forKey: "LoggedUserId") as? Int else {
            return
        }
        
        self.getMyOrders(userId)
    }

}



//MARK: - UITableViewDelegate
extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let qrInfoModel = self.qrInfoModel {
            return qrInfoModel.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ordersCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.ordersCellIdentifier, for: indexPath) as! OrdersTableViewCell
        
        if let qrInfo = self.qrInfoModel?[indexPath.row] {
            ordersCell.setQRInformation(qrInfo)
        }
        
        return ordersCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Form", bundle: nil)
        if let qrVC = storyboard.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
            qrVC.modalPresentationStyle = .fullScreen
            
            if let qrInfo = self.qrInfoModel?[indexPath.row] {
                qrVC.qrInfo = qrInfo
            }
            
            self.present(qrVC, animated: true, completion: nil)
         }
    }
}


//MARK: - API Call
extension OrderHistoryViewController {
    private func getMyOrders(_ userId: Int) {
        let parameters = ["userId": userId]
        
        print("Par: \(parameters)")
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        let api: Apifeed = .myOrders
        
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json")], body: body, timeInterval: 120)
        
        client.post_getMyOrders(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else { return }
                
                if response.status {
                    if let qrInfo = response.data {
                        strongSelf.qrInfoModel = qrInfo
                        DispatchQueue.main.async {
                            strongSelf.orderTableView.reloadData()
                        }
                    }                    
                } else {
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: (response.message ?? ""), actionTitle: "Ok")
                    return
                }
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
            }
        }
    }
    
    
}
