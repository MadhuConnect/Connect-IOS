//
//  LoginViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 06/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class LoginViewController: UIViewController {
    
    @IBOutlet weak var vw_mobileBackView: UIView!
    @IBOutlet weak var vw_passwordBackView: UIView!
    @IBOutlet weak var vw_loginBackView: UIView!
    
    @IBOutlet weak var tf_mobileTF: UITextField!
    @IBOutlet weak var tf_passwordTF: UITextField!
    
    @IBOutlet weak var btn_forgotBtn: UIButton!
    @IBOutlet weak var btn_loginBtn: UIButton!
    @IBOutlet weak var btn_signUpBtn: UIButton!

    @IBOutlet weak var lbl_errorMobileLbl: UILabel!
    @IBOutlet weak var lbl_errorPasswordLbl: UILabel!
    @IBOutlet weak var lbl_accountLbl: UILabel!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    let animationView = AnimationView()
    
    private let client = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tf_mobileTF.text = "9121089404"
//        self.tf_passwordTF.text = "123123"

        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.updateUIWhenViewWillAppear()
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        if let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
            otpVC.modalPresentationStyle = .fullScreen
            self.present(otpVC, animated: true, completion: nil)
        }
    }

    @IBAction func loginSubmitUserAction(_ sender: UIButton) {
        guard let mobile = self.tf_mobileTF.text, !mobile.isEmpty, let password = self.tf_passwordTF.text, !password.isEmpty, let token = ConstHelper.deviceToken, !token.isEmpty else {
            return
        }
        vw_loginBackView.isHidden = true
        self.setupAnimation(withAnimation: true)
        self.self.postLoginUser(withMobile: mobile, password: password, andToken: token)
    }
    
    @IBAction func signUpUserAction(_ sender: UIButton) {
        if let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            signupVC.modalPresentationStyle = .fullScreen
            self.present(signupVC, animated: true, completion: nil)
        }
    }
}

extension LoginViewController {
    private func updateDefaultUI() {
        self.tf_mobileTF.delegate = self
        self.tf_passwordTF.delegate = self
        
        self.tf_mobileTF.textColor = ConstHelper.hTextColor
        self.tf_mobileTF.font = ConstHelper.h3Normal
        
        self.tf_passwordTF.textColor = ConstHelper.hTextColor
        self.tf_passwordTF.font = ConstHelper.h3Normal
        
        self.lbl_errorMobileLbl.textColor = ConstHelper.hErrorColor
        self.lbl_errorMobileLbl.font = ConstHelper.h4Normal
        
        self.lbl_errorPasswordLbl.textColor = ConstHelper.hErrorColor
        self.lbl_errorPasswordLbl.font = ConstHelper.h3Normal
        
        self.lbl_accountLbl.textColor = ConstHelper.white
        self.lbl_accountLbl.font = ConstHelper.h3Normal
        
        self.btn_forgotBtn.titleLabel?.font = ConstHelper.h4Normal
        self.btn_signUpBtn.setTitleColor(ConstHelper.blue, for: .normal)
        
        self.vw_mobileBackView.setBorderForView(width: 0, color: .white, radius: 10)
        self.vw_passwordBackView.setBorderForView(width: 0, color: .white, radius: 10)
        self.vw_loginBackView.setBorderForView(width: 0, color: .white, radius: 10)
        
        
        btn_loginBtn.titleLabel?.font = ConstHelper.h4Bold
        vw_loginBackView.backgroundColor = ConstHelper.disableColor
        btn_loginBtn.setTitleColor(.lightGray, for: .normal)
        btn_loginBtn.isUserInteractionEnabled = false
        
        self.tf_mobileTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        self.tf_passwordTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        
    }
    
    private func updateUIWhenViewWillAppear() {
        self.lbl_errorMobileLbl.text = ""
        self.lbl_errorPasswordLbl.text = ""
        self.loadingBackView.isHidden = true
        self.vw_loginBackView.isHidden = false
    }
    
    @objc func validateText(_ textField: UITextField) {
        switch textField {
        case tf_mobileTF:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validateMobile(text) {
                    self.lbl_errorMobileLbl.text = ""
                    break
                } else {
                    self.lbl_errorMobileLbl.text = "Should be valid mobile number"
                    break
                }
            } else {
                self.lbl_errorMobileLbl.text = "Should be valid mobile number"
                break
            }
        case tf_passwordTF:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validatePassword(text)  {
                    self.lbl_errorPasswordLbl.text = ""
                    break
                } else {
                    self.lbl_errorPasswordLbl.text = "Password should be atleast 4 characters"
                    break
                }
            } else {
                self.lbl_errorPasswordLbl.text = "Password should be atleast 4 characters"
                break
            }
        default:
            self.lbl_errorMobileLbl.text = "Should be valid mobile number"
            self.lbl_errorPasswordLbl.text = "Password should be atleast 4 characters"
            break
        }

        guard let err1 = self.lbl_errorMobileLbl.text, err1.isEmpty,
            let err2 = self.lbl_errorPasswordLbl.text, err2.isEmpty,
            let text1 = self.tf_mobileTF.text, !text1.isEmpty,
            let text2 = self.tf_passwordTF.text, !text2.isEmpty else {
                vw_loginBackView.backgroundColor = ConstHelper.disableColor
                btn_loginBtn.setTitleColor(.lightGray, for: .normal)
                btn_loginBtn.isUserInteractionEnabled = false
            return
        }
        
        vw_loginBackView.backgroundColor = ConstHelper.cyan
        btn_loginBtn.setTitleColor(ConstHelper.enableColor, for: .normal)
        btn_loginBtn.isUserInteractionEnabled = true

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
        self.vw_loginBackView.isHidden = false
        self.setupAnimation(withAnimation: false)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case tf_mobileTF:
            tf_mobileTF.resignFirstResponder()
        case tf_passwordTF:
            tf_passwordTF.resignFirstResponder()
        default:
            return false
        }
        return true
    }
}

//MAAK: - API Call
extension LoginViewController {
    private func postLoginUser(withMobile mobile: String, password: String, andToken token: String) {
        //begin..
        let parameters: LoginReqModel = LoginReqModel(mobile: mobile, password: password, token: token)
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        let api: Apifeed = .userLogin
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json")], body: body, timeInterval: 120)
        
        client.post_loginUser(from: endpoint) { [weak self] result in
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
