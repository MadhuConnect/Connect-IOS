//
//  SignUpViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 06/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var vw_fullNameBackView: UIView!
    @IBOutlet weak var vw_mobileBackView: UIView!
    @IBOutlet weak var vw_passwordBackView: UIView!
    @IBOutlet weak var vw_signUpBackView: UIView!
    
    @IBOutlet weak var tf_fullNameTF: UITextField!
    @IBOutlet weak var tf_mobileTF: UITextField!
    @IBOutlet weak var tf_passwordTF: UITextField!
        
    @IBOutlet weak var btn_loginBtn: UIButton!
    @IBOutlet weak var btn_signUpBtn: UIButton!
    
    @IBOutlet weak var lbl_errorFullNameLbl: UILabel!
    @IBOutlet weak var lbl_errorMobileLbl: UILabel!
    @IBOutlet weak var lbl_errorPasswordLbl: UILabel!
    @IBOutlet weak var lbl_accountLbl: UILabel!
    
    @IBOutlet weak var btn_termsCheck: UIButton!
    @IBOutlet weak var lbl_termsTitle: UILabel!
    @IBOutlet weak var lbl_termsAnd: UILabel!
    @IBOutlet weak var btn_termsService: UIButton!
    @IBOutlet weak var btn_privacyPolicy: UIButton!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    let animationView = AnimationView()
    
    private let client = APIClient()
    var isCheckTerms: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.updateUIWhenViewWillAppear()
    }
    
    @IBAction func signUpSubmitUserAction(_ sender: UIButton) {
        guard let name = self.tf_fullNameTF.text, !name.isEmpty , let mobile = self.tf_mobileTF.text, !mobile.isEmpty, let password = self.tf_passwordTF.text, !password.isEmpty else {
            return
        }
        
        var newMobile: String = ""
        if !mobile.contains("+91") {
            newMobile = "+91" + mobile
        } else {
            newMobile = mobile
        }
        
        if !isCheckTerms {
            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Please aggree the our Terms of service and Privacy policy", actionTitle: "Ok")
            return
        }
        
        print(newMobile)
        vw_signUpBackView.isHidden = true
        self.setupAnimation(withAnimation: true)
        self.postRegistrationUser(withName: name, mobile: newMobile, andPassword: password)
    }
    
    @IBAction func signInUserAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkboxAction(_ sender: UIButton) {
        if isCheckTerms {
            self.isCheckTerms = false
            self.btn_termsCheck.setImage(UIImage(named: "uncheckbox"), for: .normal)
        } else {
            self.isCheckTerms = true
            self.btn_termsCheck.setImage(UIImage(named: "checkbox"), for: .normal)
        }
    }
    
    @IBAction func showTermsAction(_ sender: UIButton) {
        self.moveToTermsViewControler(ConstHelper.termsAndConditions, title: "Terms of service")
    }
    
    @IBAction func showPrivacyPolicyAction(_ sender: UIButton) {
        self.moveToTermsViewControler(ConstHelper.privacyPolicy, title: "Privacy policy")
    }
    
    private func moveToTermsViewControler(_ url: String, title: String) {
        let storyboard = UIStoryboard(name: "Terms", bundle: nil)
        if let termsVC = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController {
            termsVC.loadUrl = url
            termsVC.headerTitle = title
            termsVC.modalPresentationStyle = .fullScreen
            self.present(termsVC, animated: true, completion: nil)
        }
        
    }
}

extension SignUpViewController {
    private func updateDefaultUI() {
        self.tf_mobileTF.delegate = self
        self.tf_passwordTF.delegate = self
        self.tf_fullNameTF.delegate = self
        self.tf_passwordTF.isSecureTextEntry = true
        
        self.tf_mobileTF.textColor = ConstHelper.hTextColor
        self.tf_mobileTF.font = ConstHelper.h3Normal
        
        self.tf_passwordTF.textColor = ConstHelper.hTextColor
        self.tf_passwordTF.font = ConstHelper.h3Normal
        
        self.tf_fullNameTF.textColor = ConstHelper.hTextColor
        self.tf_fullNameTF.font = ConstHelper.h3Normal
        
        self.lbl_errorMobileLbl.textColor = ConstHelper.hErrorColor
        self.lbl_errorMobileLbl.font = ConstHelper.h4Normal
        
        self.lbl_errorPasswordLbl.textColor = ConstHelper.hErrorColor
        self.lbl_errorPasswordLbl.font = ConstHelper.h3Normal
        
        self.lbl_errorFullNameLbl.textColor = ConstHelper.hErrorColor
        self.lbl_errorFullNameLbl.font = ConstHelper.h3Normal
        
        self.vw_fullNameBackView.setBorderForView(width: 0, color: .white, radius: 10)
        self.vw_mobileBackView.setBorderForView(width: 0, color: .white, radius: 10)
        self.vw_passwordBackView.setBorderForView(width: 0, color: .white, radius: 10)
        self.vw_signUpBackView.setBorderForView(width: 0, color: .white, radius: 10)
        
        self.lbl_accountLbl.textColor = ConstHelper.white
        self.lbl_accountLbl.font = ConstHelper.h3Normal
        
        self.btn_signUpBtn.titleLabel?.font = ConstHelper.h4Normal
        self.btn_signUpBtn.setTitleColor(ConstHelper.blue, for: .normal)
        
        btn_signUpBtn.titleLabel?.font = ConstHelper.h4Bold
        vw_signUpBackView.backgroundColor = ConstHelper.disableColor
        btn_signUpBtn.setTitleColor(.lightGray, for: .normal)
        btn_signUpBtn.isUserInteractionEnabled = false
        
        self.tf_mobileTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        self.tf_passwordTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        self.tf_fullNameTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
    }
    
    private func updateUIWhenViewWillAppear() {
        self.lbl_errorMobileLbl.text = ""
        self.lbl_errorPasswordLbl.text = ""
        self.lbl_errorFullNameLbl.text = ""
        self.loadingBackView.isHidden = true
        self.vw_signUpBackView.isHidden = false
        
        self.isCheckTerms = false
        btn_termsCheck.setImage(UIImage(named: "uncheckbox"), for: .normal)
        btn_termsCheck.isUserInteractionEnabled = false
        btn_signUpBtn.isUserInteractionEnabled = false
    }
    
    @objc func validateText(_ textField: UITextField) {
        switch textField {
        case tf_fullNameTF:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validateName(text) {
                    self.lbl_errorFullNameLbl.text = ""
                    break
                } else {
                    self.lbl_errorFullNameLbl.text = "Name should be minimum 3 characters"
                    break
                }
            } else {
                self.lbl_errorFullNameLbl.text = "Name should be minimum 3 characters"
                break
            }
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
            let err3 = self.lbl_errorFullNameLbl.text, err3.isEmpty,
            let text1 = self.tf_mobileTF.text, !text1.isEmpty,
            let text2 = self.tf_passwordTF.text, !text2.isEmpty,
            let text3 = self.tf_fullNameTF.text, !text3.isEmpty else {
                vw_signUpBackView.backgroundColor = ConstHelper.disableColor
                btn_signUpBtn.setTitleColor(.lightGray, for: .normal)
                btn_signUpBtn.isUserInteractionEnabled = false
                btn_termsCheck.isUserInteractionEnabled = false
                return
        }
        
        vw_signUpBackView.backgroundColor = ConstHelper.cyan
        btn_signUpBtn.setTitleColor(ConstHelper.enableColor, for: .normal)
        btn_signUpBtn.isUserInteractionEnabled = true
        btn_termsCheck.isUserInteractionEnabled = true
        
        print("executed...")
    }
    
    private func otpViewController(_ registrationUserInfo: RegistrationResModel) {
        self.handleUIAfterAPIResponse()
        if let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
            otpVC.modalPresentationStyle = .fullScreen
            otpVC.otpType = "Registration"
            otpVC.registrationUserInfo = registrationUserInfo
            self.present(otpVC, animated: true, completion: nil)
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
        self.vw_signUpBackView.isHidden = false
        self.setupAnimation(withAnimation: false)
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
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
extension SignUpViewController {
    private func postRegistrationUser(withName name: String, mobile: String, andPassword password: String) {
        //begin..
        let parameters: RegistrationReqModel = RegistrationReqModel(name: name, mobile: mobile, password: password)
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        let api: Apifeed = .userRegistration
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json")], body: body, timeInterval: 120)
        
        client.post_registerUser(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                guard  let user = user else { return }

                if user.status {
                    DispatchQueue.main.async {
                        strongSelf.otpViewController(user)
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
