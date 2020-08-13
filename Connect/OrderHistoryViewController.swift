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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.orderTableView.delegate = self
        self.orderTableView.dataSource = self
    }

}



//MARK: - UITableViewDelegate
extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ordersCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.ordersCellIdentifier, for: indexPath) as! OrdersTableViewCell
        
        return ordersCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Form", bundle: nil)
        if let qrVC = storyboard.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
            qrVC.modalPresentationStyle = .fullScreen
            self.present(qrVC, animated: true, completion: nil)
         }
    }
}
