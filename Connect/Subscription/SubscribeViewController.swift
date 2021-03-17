//
//  SubscribeViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 02/03/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import UIKit

class SubscribeViewController: UIViewController {
    
    @IBOutlet weak var lbl_subcribeNext: UILabel!

    private let client = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbl_subcribeNext.textColor = ConstHelper.gray        
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emergencyReqAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
        if let emergencyRequestVC = storyboard.instantiateViewController(withIdentifier: "EmergencyRequestViewController") as? EmergencyRequestViewController {
            emergencyRequestVC.modalPresentationStyle = .fullScreen
            emergencyRequestVC.isFromNotHome = true
            self.present(emergencyRequestVC, animated: true, completion: nil)
        }
    }

    @IBAction func sendOtpAction(_ sender: UIButton) {
        self.getSubscribeOtp()
    }
    
}

//MAAK: - API Call
extension SubscribeViewController {
    private func getSubscribeOtp() {
        //API
        let api: Apifeed = .kycSendOtp
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)
        
        client.get_KYCSendOtp(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let subscribeUser):
                guard  let user = subscribeUser else { return }

                if user.status {
                    strongSelf.otpSubscribeViewController(user)
                } else {
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(user.message ?? "")", actionTitle: "Ok")
                    return
                }
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                return
            }
        }
    }
    
    private func otpSubscribeViewController(_ subscribeUser: OTPSubscribeResModel) {
        if let otpSubscribeVC = self.storyboard?.instantiateViewController(withIdentifier: "OtpSubscribeViewController") as? OtpSubscribeViewController {
            otpSubscribeVC.modalPresentationStyle = .fullScreen
            self.present(otpSubscribeVC, animated: true, completion: nil)
        }
    }
    
    
}

