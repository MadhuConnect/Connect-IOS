//
//  OTPViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 06/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class OTPViewController: UIViewController {
    
    @IBOutlet weak var tf_opt1Tf: UITextField!
    @IBOutlet weak var tf_opt2Tf: UITextField!
    @IBOutlet weak var tf_opt3Tf: UITextField!
    @IBOutlet weak var tf_opt4Tf: UITextField!
    @IBOutlet weak var tf_opt5Tf: UITextField!
    @IBOutlet weak var tf_opt6Tf: UITextField!
    
    @IBOutlet weak var lbl_otpVerficationLbl: UILabel!
    @IBOutlet weak var lbl_otpMessageLbl: UILabel!
    @IBOutlet weak var lbl_receiveOtpLbl: UILabel!
    
    @IBOutlet weak var vw_verifyBackView: UIView!
    @IBOutlet weak var vw_otpBackView: UIView!
    @IBOutlet weak var btn_verifyBtn: UIButton!
    @IBOutlet weak var btn_resendOtpBtn: UIButton!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    let animationView = AnimationView()
    
    private let client = APIClient()
    
    var registrationUserInfo: RegistrationResModel?
    var receivedOTP: String?
    var otpType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.updateUIWhenViewWillAppear()
    }
    
    @IBAction func submitOTPAction(_ sender: UIButton) {
        guard let mobile = self.registrationUserInfo?.mobile, let type = self.otpType, !type.isEmpty, !mobile.isEmpty, let otp = receivedOTP, !otp.isEmpty, let token = ConstHelper.deviceToken, !token.isEmpty else {
            return
        }
        
        vw_verifyBackView.isHidden = true
        self.setupAnimation(withAnimation: true)
        self.postOTPUser(withMobile: mobile, otp: otp, type: type, andToken: token)
        
    }

}

extension OTPViewController {
    private func updateDefaultUI() {
        tf_opt1Tf.delegate = self
        tf_opt2Tf.delegate = self
        tf_opt3Tf.delegate = self
        tf_opt4Tf.delegate = self
        tf_opt5Tf.delegate = self
        tf_opt6Tf.delegate = self
        
        tf_opt1Tf.backgroundColor = .clear
        tf_opt2Tf.backgroundColor = .clear
        tf_opt3Tf.backgroundColor = .clear
        tf_opt4Tf.backgroundColor = .clear
        tf_opt5Tf.backgroundColor = .clear
        tf_opt6Tf.backgroundColor = .clear
        
        addBottomBorderTo(textField: tf_opt1Tf)
        addBottomBorderTo(textField: tf_opt2Tf)
        addBottomBorderTo(textField: tf_opt3Tf)
        addBottomBorderTo(textField: tf_opt4Tf)
        addBottomBorderTo(textField: tf_opt5Tf)
        addBottomBorderTo(textField: tf_opt6Tf)
        
        self.tf_opt1Tf.textColor = ConstHelper.white
        self.tf_opt1Tf.font = ConstHelper.h1Normal
        
        self.tf_opt2Tf.textColor = ConstHelper.white
        self.tf_opt2Tf.font = ConstHelper.h1Normal
        
        self.tf_opt3Tf.textColor = ConstHelper.white
        self.tf_opt3Tf.font = ConstHelper.h1Normal
        
        self.tf_opt4Tf.textColor = ConstHelper.white
        self.tf_opt4Tf.font = ConstHelper.h1Normal
        
        self.tf_opt5Tf.textColor = ConstHelper.white
        self.tf_opt5Tf.font = ConstHelper.h1Normal
        
        self.tf_opt6Tf.textColor = ConstHelper.white
        self.tf_opt6Tf.font = ConstHelper.h1Normal
        
        self.lbl_otpVerficationLbl.textColor = ConstHelper.white
        self.lbl_otpVerficationLbl.font = ConstHelper.h1Bold
        
        self.lbl_otpMessageLbl.textColor = ConstHelper.white
        self.lbl_otpMessageLbl.font = ConstHelper.h4Normal
        
        self.lbl_receiveOtpLbl.textColor = ConstHelper.white
        self.lbl_receiveOtpLbl.font = ConstHelper.h3Normal
        
        self.btn_resendOtpBtn.titleLabel?.font = ConstHelper.h4Normal
        self.btn_resendOtpBtn.setTitleColor(ConstHelper.blue, for: .normal)
        
        self.vw_verifyBackView.setBorderForView(width: 0, color: .white, radius: 10)
        
        btn_verifyBtn.titleLabel?.font = ConstHelper.h4Bold
        self.disableVerifyButtonAction()
    }
    
    private func updateUIWhenViewWillAppear() {
        self.loadingBackView.isHidden = true
        self.vw_verifyBackView.isHidden = false
        self.lbl_otpMessageLbl.text = self.registrationUserInfo?.message
    }
    
    func addBottomBorderTo(textField: UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 2.0, width: textField.frame.size.width, height: 4.0)
        textField.layer.addSublayer(layer)
    }
    
    private func enableVerifyButtonAction() {
        vw_verifyBackView.backgroundColor = ConstHelper.cyan
        btn_verifyBtn.setTitleColor(ConstHelper.white, for: .normal)
        btn_verifyBtn.isUserInteractionEnabled = true
    }
    
    private func disableVerifyButtonAction() {
        vw_verifyBackView.backgroundColor = ConstHelper.disableColor
        btn_verifyBtn.setTitleColor(.lightGray, for: .normal)
        btn_verifyBtn.isUserInteractionEnabled = false
    }
    
    @objc func validateText(_ textField: UITextField) {
        switch textField {
        case tf_opt1Tf, tf_opt2Tf, tf_opt3Tf, tf_opt4Tf, tf_opt5Tf, tf_opt6Tf:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validateOTP(text) {
                    break
                } else {
                    break
                }
            } else {
                break
            }
        default:
            break
        }
        
        guard
            let otp1 = self.tf_opt1Tf.text, !otp1.isEmpty,
            let otp2 = self.tf_opt2Tf.text, !otp2.isEmpty,
            let otp3 = self.tf_opt3Tf.text, !otp3.isEmpty,
            let otp4 = self.tf_opt4Tf.text, !otp4.isEmpty,
            let otp5 = self.tf_opt5Tf.text, !otp5.isEmpty,
            let otp6 = self.tf_opt6Tf.text, !otp6.isEmpty else {
                self.disableVerifyButtonAction()
                return
        }
        
        self.enableVerifyButtonAction()
        self.receivedOTP = otp1 + otp2 + otp3 + otp4 + otp5 + otp6
        print("executed...")
    }
    
    private func initialRootViewController() {
        self.handleUIAfterAPIResponse()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let rootVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
            self.view.window?.rootViewController = rootVC
        }
    }
    
    private func setupAnimation(withAnimation status: Bool) {
        animationView.animation = Animation.named("29577-dot-loader-5")
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
    
    private func handleUIAfterAPIResponse() {
        self.vw_verifyBackView.isHidden = false
        self.setupAnimation(withAnimation: false)
    }
}

extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1) && (string.count > 0) {
            if textField == tf_opt1Tf {
                tf_opt2Tf.becomeFirstResponder()
            }
            if textField == tf_opt2Tf {
                tf_opt3Tf.becomeFirstResponder()
            }
            if textField == tf_opt3Tf {
                tf_opt4Tf.becomeFirstResponder()
            }
            if textField == tf_opt4Tf {
                tf_opt5Tf.becomeFirstResponder()
            }
            if textField == tf_opt5Tf {
                tf_opt6Tf.becomeFirstResponder()
            }
            if textField == tf_opt6Tf {
                tf_opt6Tf.resignFirstResponder()
            }
            
            textField.text = string
            self.validateText(textField)
            return false
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == tf_opt6Tf {
                tf_opt5Tf.becomeFirstResponder()
            }
            if textField == tf_opt5Tf {
                tf_opt4Tf.becomeFirstResponder()
            }
            if textField == tf_opt4Tf {
                tf_opt3Tf.becomeFirstResponder()
            }
            if textField == tf_opt3Tf {
                tf_opt2Tf.becomeFirstResponder()
            }
            if textField == tf_opt2Tf {
                tf_opt1Tf.becomeFirstResponder()
            }
            if textField == tf_opt1Tf {
                tf_opt1Tf.resignFirstResponder()
            }
            
            textField.text = ""
            self.validateText(textField)
            return false
        } else if (textField.text?.count)! >= 1 {
            textField.text = string
            self.validateText(textField)
            return false
        }
        
        return true
    }
}


//MAAK: - API Call
extension OTPViewController {
    private func postOTPUser(withMobile mobile: String, otp: String, type: String, andToken token: String) {
        //begin..
        let parameters: OTPReqModel = OTPReqModel(mobile: mobile, otp: otp, token: token, type: type)
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        let api: Apifeed = .checkOtp
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.staticToken)], body: body, timeInterval: 120)
        
        client.post_checkReceivedOTP(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                guard  let user = user else { return }

                if user.status {
                    UserDefaults.standard.set(user.data?.userId, forKey: "LoggedUserId")
                    UserDefaults.standard.set(user.data?.name, forKey: "LoggedUserName")
                    UserDefaults.standard.set(user.data?.mobile, forKey: "LoggedUserMobile")
                    UserDefaults.standard.set(true, forKey: "loginStatusKey")
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async {
                        strongSelf.initialRootViewController()
                    }
                    
                } else {
                    strongSelf.handleUIAfterAPIResponse()
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(user.message ?? "")", actionTitle: "Ok")
                    return
                }
            case .failure(let error):
                strongSelf.handleUIAfterAPIResponse()
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                return
            }
        }
        //..end
    }
    
    
}
