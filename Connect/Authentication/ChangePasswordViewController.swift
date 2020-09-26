//
//  ChangePasswordViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 18/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_emergency: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var vw_pwdBackView: UIView!
    @IBOutlet weak var lbl_pwdHeading: UILabel!
    @IBOutlet weak var tf_pwdTF: UITextField!
    @IBOutlet weak var vw_pwdLineView: UIView!
    @IBOutlet weak var lbl_errPwdLbl: UILabel!
    
    @IBOutlet weak var vw_cPwdBackView: UIView!
    @IBOutlet weak var lbl_cPwdHeading: UILabel!
    @IBOutlet weak var tf_cPwdTF: UITextField!
    @IBOutlet weak var vw_cPwdLineView: UIView!
    @IBOutlet weak var lbl_errCPwdLbl: UILabel!
    
    @IBOutlet weak var btn_showPassword: UIButton!
    @IBOutlet weak var btn_showConfirmPassword: UIButton!
    @IBOutlet weak var btn_updatePassword: UIButton!
    
    private let client = APIClient()
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    let animationView = AnimationView()
    
    var loadUrl: String = ""
    var headerTitle: String = "Change Password"
    var showPassword: Bool = false
    var showConfirmPassword: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        if showPassword {
            self.showPassword = false
            self.btn_showPassword.setImage(UIImage(named: "invisible"), for: .normal)
            self.tf_pwdTF.isSecureTextEntry = true
        } else {
            self.showPassword = true
            self.btn_showPassword.setImage(UIImage(named: "visibility"), for: .normal)
            self.tf_pwdTF.isSecureTextEntry = false
        }
    }
    
    @IBAction func showConfirmPassword(_ sender: UIButton) {
        if showConfirmPassword {
            self.showConfirmPassword = false
            self.btn_showConfirmPassword.setImage(UIImage(named: "invisible"), for: .normal)
            self.tf_cPwdTF.isSecureTextEntry = true
        } else {
            self.showConfirmPassword = true
            self.btn_showConfirmPassword.setImage(UIImage(named: "visibility"), for: .normal)
            self.tf_cPwdTF.isSecureTextEntry = false
        }
    }
    
    @IBAction func updatePasswordAction(_ sender: UIButton) {
        guard
            let password = self.tf_pwdTF.text, !password.isEmpty,
            let confirmPassword = self.tf_cPwdTF.text, !confirmPassword.isEmpty
            else { return }
        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        self.resetPassword(withNewPassword: password)
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

extension ChangePasswordViewController {
    private func updateDefaultUI() {
        lbl_title.text = headerTitle
        
        self.tf_pwdTF.delegate = self
        self.tf_cPwdTF.delegate = self
        
        self.lbl_pwdHeading.font = ConstHelper.h5Normal
        self.lbl_pwdHeading.textColor = ConstHelper.black
        self.tf_pwdTF.font = ConstHelper.h5Normal
        self.tf_pwdTF.textColor = ConstHelper.gray
        self.vw_pwdLineView.backgroundColor = ConstHelper.gray
        self.tf_pwdTF.isSecureTextEntry = true
        self.lbl_errPwdLbl.textColor = ConstHelper.red
        self.lbl_errPwdLbl.font = ConstHelper.h5Normal
        
        self.lbl_cPwdHeading.font = ConstHelper.h5Normal
        self.lbl_cPwdHeading.textColor = ConstHelper.black
        self.tf_cPwdTF.font = ConstHelper.h5Normal
        self.tf_cPwdTF.textColor = ConstHelper.gray
        self.vw_cPwdLineView.backgroundColor = ConstHelper.gray
        self.tf_cPwdTF.isSecureTextEntry = true
        self.lbl_errCPwdLbl.textColor = ConstHelper.red
        self.lbl_errCPwdLbl.font = ConstHelper.h5Normal
        
        self.tf_pwdTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        self.tf_cPwdTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        
        self.btn_back.isHidden = true
        self.btn_back.isUserInteractionEnabled = false
    }
    
    private func updateUIWhenViewWillAppear() {
        self.showPassword = false
        btn_showPassword.setImage(UIImage(named: "invisible"), for: .normal)

        self.showConfirmPassword = false
        btn_showConfirmPassword.setImage(UIImage(named: "invisible"), for: .normal)
    }

    
    @objc func validateText(_ textField: UITextField) {
        switch textField {
        case tf_pwdTF:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validatePassword(text)  {
                    self.lbl_errPwdLbl.text = ""
                    tf_cPwdTF.text = ""
                    break
                } else {
                    self.lbl_errPwdLbl.text = "Password should be atleast 4 characters"
                    break
                }
            } else {
                self.lbl_errPwdLbl.text = "Password should be atleast 4 characters"
                break
            }
        case tf_cPwdTF:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validatePassword(text)  {
                    if let password = self.tf_pwdTF.text, !password.isEmpty {
                        if password.elementsEqual(text) {
                            self.lbl_errCPwdLbl.text = ""
                        } else {
                            self.lbl_errCPwdLbl.text = "Password is not matching"
                        }
                    } else {
                        self.lbl_errCPwdLbl.text = "Password is not matching"
                    }
                    
                    break
                } else {
                    self.lbl_errCPwdLbl.text = "Password should be atleast 4 characters"
                    break
                }
            } else {
                self.lbl_errCPwdLbl.text = "Password should be atleast 4 characters"
                break
            }
        default:
            self.lbl_errPwdLbl.text = "Should be valid mobile number"
            self.lbl_errCPwdLbl.text = "Password should be atleast 4 characters"
            break
        }
        
        guard
            let err1 = self.lbl_errPwdLbl.text, err1.isEmpty,
            let text1 = self.tf_pwdTF.text, !text1.isEmpty,
            let err2 = self.lbl_errCPwdLbl.text, err2.isEmpty,
            let text2 = self.tf_cPwdTF.text, !text2.isEmpty
            else {
                btn_updatePassword.backgroundColor = UIColor(red: 42/255, green: 50/255, blue: 77/255, alpha: 0.5)
                btn_updatePassword.setTitleColor(.lightGray, for: .normal)
                btn_updatePassword.isUserInteractionEnabled = false
                return
        }
        
        btn_updatePassword.backgroundColor = ConstHelper.cyan
        btn_updatePassword.setTitleColor(ConstHelper.enableColor, for: .normal)
        btn_updatePassword.isUserInteractionEnabled = true
        
        print("executed...")
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case tf_pwdTF:
            tf_pwdTF.resignFirstResponder()
        case tf_cPwdTF:
            tf_cPwdTF.resignFirstResponder()
        default:
            return false
        }
        return true
    }
}

//MARK: API CAll
extension ChangePasswordViewController {
    private func resetPassword(withNewPassword password: String) {
        //begin..
        let parameters = ["password": password]
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        let api: Apifeed = .resetPassword
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)
        
        client.post_resetPassword(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
            switch result {
            case .success(let user):
                guard  let user = user else { return }
                
                if user.status {
                    print(user.message as Any)
                    strongSelf.tf_pwdTF.text = ""
                    strongSelf.tf_cPwdTF.text = ""
                    
                    DispatchQueue.main.async {
                        strongSelf.initialRootViewController()
                    }
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
    
    private func initialRootViewController() {        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let rootVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
            self.view.window?.rootViewController = rootVC
        }
    }
}
