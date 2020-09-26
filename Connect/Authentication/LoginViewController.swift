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
    
    //Forgot password
    @IBOutlet weak var vw_alertBackView: UIView!
    @IBOutlet weak var vw_alertView: UIView!
    @IBOutlet weak var vw_alertLineView: UIView!
    @IBOutlet weak var tf_alertTF: UITextField!
    @IBOutlet weak var lbl_alertMsg: UILabel!
    @IBOutlet weak var btn_cancelBtn: UIButton!
    @IBOutlet weak var btn_submitBtn: UIButton!
    @IBOutlet weak var lbl_errorForgotMobileLbl: UILabel!
    
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
        self.vw_alertBackView.isHidden = false
        self.vw_alertView.isHidden = false
        self.tf_alertTF.text = ""
        self.tf_alertTF.becomeFirstResponder()
        self.emptyData()
    }
    
    @IBAction func forgotCancelAction(_ sender: UIButton) {
        self.vw_alertBackView.isHidden = true
        self.vw_alertView.isHidden = true
        self.tf_alertTF.text = ""
        self.tf_alertTF.resignFirstResponder()
        self.emptyData()
    }
    
    @IBAction func forgotSubmitAction(_ sender: UIButton) {
        guard let mobile = self.tf_alertTF.text, !mobile.isEmpty else {
            return
        }

        var newMobile: String = ""
        if !mobile.contains("+91") {
            newMobile = "+91" + mobile
        } else {
            newMobile = mobile
        }

        print(newMobile)
        self.forgotUserPassword(withName: newMobile)
    }

    @IBAction func loginSubmitUserAction(_ sender: UIButton) {
        guard let mobile = self.tf_mobileTF.text, !mobile.isEmpty, let password = self.tf_passwordTF.text, !password.isEmpty, let token = ConstHelper.deviceToken, !token.isEmpty else {
            return
        }
        
        var newMobile: String = ""
        if !mobile.contains("+91") {
            newMobile = "+91" + mobile
        } else {
            newMobile = mobile
        }
        
        vw_loginBackView.isHidden = true
        self.setupAnimation(withAnimation: true)
        self.self.postLoginUser(withMobile: newMobile, password: password, andToken: token)
    }
    
    @IBAction func signUpUserAction(_ sender: UIButton) {
        if let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            signupVC.modalPresentationStyle = .fullScreen
            self.present(signupVC, animated: true, completion: nil)
        }
    }
    
    private func emptyData() {
        self.lbl_errorMobileLbl.text = ""
        self.lbl_errorPasswordLbl.text = ""
        self.lbl_errorForgotMobileLbl.text = ""
        
        self.tf_mobileTF.text = ""
        self.tf_passwordTF.text = ""
    }
}

extension LoginViewController {
    private func updateDefaultUI() {
        self.tf_mobileTF.delegate = self
        self.tf_passwordTF.delegate = self
        self.tf_alertTF.delegate = self
        self.tf_passwordTF.isSecureTextEntry = true
        
        
        self.tf_mobileTF.textColor = ConstHelper.hTextColor
        self.tf_mobileTF.font = ConstHelper.h3Normal
        
        self.tf_passwordTF.textColor = ConstHelper.hTextColor
        self.tf_passwordTF.font = ConstHelper.h3Normal
        
        self.lbl_errorMobileLbl.textColor = ConstHelper.hErrorColor
        self.lbl_errorMobileLbl.font = ConstHelper.h4Normal
        
        self.lbl_errorPasswordLbl.textColor = ConstHelper.hErrorColor
        self.lbl_errorPasswordLbl.font = ConstHelper.h4Normal
        
        self.lbl_accountLbl.textColor = ConstHelper.white
        self.lbl_accountLbl.font = ConstHelper.h3Normal
        
        self.btn_forgotBtn.titleLabel?.font = ConstHelper.h4Normal
        self.btn_signUpBtn.setTitleColor(ConstHelper.blue, for: .normal)
        
        self.vw_mobileBackView.setBorderForView(width: 0, color: .white, radius: 10)
        self.vw_passwordBackView.setBorderForView(width: 0, color: .white, radius: 10)
        self.vw_loginBackView.setBorderForView(width: 0, color: .white, radius: 10)
        
        self.vw_alertView.setBorderForView(width: 0, color: .white, radius: 10)
        self.vw_alertLineView.backgroundColor = ConstHelper.gray
        self.tf_alertTF.textColor = ConstHelper.hTextColor
        self.tf_alertTF.font = ConstHelper.h3Normal
        
        self.btn_cancelBtn.setTitleColor(ConstHelper.orange, for: .normal)
        self.btn_cancelBtn.titleLabel?.font = ConstHelper.h3Normal
        
        self.lbl_alertMsg.textColor = ConstHelper.gray
        self.lbl_alertMsg.font = ConstHelper.h4Normal
        self.lbl_errorForgotMobileLbl.textColor = .red
        self.lbl_errorForgotMobileLbl.font = ConstHelper.h5Normal
        
        btn_loginBtn.titleLabel?.font = ConstHelper.h4Bold
        vw_loginBackView.backgroundColor = ConstHelper.disableColor
        btn_loginBtn.setTitleColor(.lightGray, for: .normal)
        btn_loginBtn.isUserInteractionEnabled = false
        
        self.tf_mobileTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        self.tf_passwordTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        self.tf_alertTF.addTarget(self, action: #selector(validateForgotText(_:)), for: .editingChanged)
        
    }
    
    private func updateUIWhenViewWillAppear() {
        self.lbl_errorMobileLbl.text = ""
        self.lbl_errorPasswordLbl.text = ""
        self.loadingBackView.isHidden = true
        self.vw_loginBackView.isHidden = false
        
        self.vw_alertBackView.isHidden = true
        self.vw_alertView.isHidden = false
        
        self.btn_submitBtn.setTitleColor(ConstHelper.lightGray, for: .normal)
        self.btn_submitBtn.titleLabel?.font = ConstHelper.h3Normal
        self.btn_submitBtn.isUserInteractionEnabled = false
    }
    
    @objc func validateForgotText(_ textField: UITextField) {
        switch textField {
        case tf_alertTF:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validateMobile(text) {
                    self.lbl_errorForgotMobileLbl.text = ""
                    break
                } else {
                    self.lbl_errorForgotMobileLbl.text = "Should be valid mobile number"
                    break
                }
            } else {
                self.lbl_errorForgotMobileLbl.text = "Should be valid mobile number"
                break
            }
        default:
            self.lbl_errorForgotMobileLbl.text = "Should be valid mobile number"
            break
        }

        guard
            let err1 = self.lbl_errorForgotMobileLbl.text, err1.isEmpty,
            let text1 = self.tf_alertTF.text, !text1.isEmpty
            else {
                self.btn_submitBtn.setTitleColor(ConstHelper.lightGray, for: .normal)
                btn_submitBtn.isUserInteractionEnabled = false
            return
        }
        self.btn_submitBtn.setTitleColor(ConstHelper.gray, for: .normal)
        btn_submitBtn.isUserInteractionEnabled = true
        print("executed...")
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
                    self.lbl_errorPasswordLbl.text = "Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character"
                    break
                }
            } else {
                self.lbl_errorPasswordLbl.text = "Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character"
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
    
    private func onboardingViewController() {
        self.handleUIAfterAPIResponse()
        if let onboardVC = self.storyboard?.instantiateViewController(withIdentifier: "OnboardViewController") as? OnboardViewController {
            self.view.window?.rootViewController = onboardVC
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
    
    private func handleUIAfterForgotAPIResponse() {
        self.vw_alertBackView.isHidden = true
        self.vw_alertView.isHidden = true
        self.tf_alertTF.text = ""
        self.tf_alertTF.resignFirstResponder()
        self.emptyData()
        
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
        case tf_alertTF:
            tf_alertTF.resignFirstResponder()
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
                    strongSelf.storeUserDetailsForFurtherUse(user)
                    DispatchQueue.main.async {
                    let isUserVerified = user.verificationStatus ?? false
                    if isUserVerified {
                            strongSelf.initialRootViewController()
                        } else {
                            strongSelf.onboardingViewController()
                        }
                        
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
    
    private func storeUserDetailsForFurtherUse(_ user: LoginResModel) {
        UserDefaults.standard.set(user.verificationStatus, forKey: "UserVerificationStatus")
        UserDefaults.standard.set(user.data?.userId, forKey: "LoggedUserId")
        UserDefaults.standard.set(user.data?.name, forKey: "LoggedUserName")
        UserDefaults.standard.set(user.data?.mobile, forKey: "LoggedUserMobile")
        UserDefaults.standard.set(user.data?.email, forKey: "LoggedUserEmail")
        UserDefaults.standard.set(user.data?.jwToken, forKey: "LoggedUserJWTToken")
        UserDefaults.standard.set(user.data?.profileImage, forKey: "LoggedUserProfileImage")
        UserDefaults.standard.set(true, forKey: "loginStatusKey")
        UserDefaults.standard.synchronize()
    }
    
    static func removeUserDetailsWhenLoggedOut() {
        UserDefaults.standard.set(nil, forKey: "UserVerificationStatus")
        UserDefaults.standard.set(nil, forKey: "LoggedUserId")
        UserDefaults.standard.set(nil, forKey: "LoggedUserName")
        UserDefaults.standard.set(nil, forKey: "LoggedUserMobile")
        UserDefaults.standard.set(nil, forKey: "LoggedUserEmail")
        UserDefaults.standard.set(nil, forKey: "LoggedUserJWTToken")
        UserDefaults.standard.set(nil, forKey: "LoggedUserProfileImage")
        UserDefaults.standard.set(false, forKey: "loginStatusKey")
        UserDefaults.standard.synchronize()
    }
    
    private func forgotUserPassword(withName mobile: String) {
        //begin..
        let parameters = ["mobile": mobile]
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        let api: Apifeed = .forgetPassword
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json")], body: body, timeInterval: 120)
        
        client.post_forgotUserPassword(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                guard  let user = user else { return }

                if user.status {
                    DispatchQueue.main.async {
                        strongSelf.otpViewController(user)
                    }
                    
                } else {
                    strongSelf.handleUIAfterForgotAPIResponse()
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(user.message ?? "")", actionTitle: "Ok")
                    return
                }
            case .failure(let error):
                strongSelf.handleUIAfterForgotAPIResponse()
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                return
            }
        }
        //..end
    }
    
    private func otpViewController(_ registrationUserInfo: RegistrationResModel) {
        self.handleUIAfterAPIResponse()
        if let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
            otpVC.modalPresentationStyle = .fullScreen
            otpVC.otpType = "Forget"
            otpVC.registrationUserInfo = registrationUserInfo
            self.present(otpVC, animated: true, completion: nil)
        }
    }
}
