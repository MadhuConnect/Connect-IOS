//
//  ResetPasswordViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 28/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_emergency: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var vw_resetBackView: UIView!
    @IBOutlet weak var vw_resetLineView: UIView!
    @IBOutlet weak var lbl_heading: UILabel!
    @IBOutlet weak var tf_resetPassword: UITextField!
    @IBOutlet weak var btn_showPassword: UIButton!
    @IBOutlet weak var btn_changePassword: UIButton!
    @IBOutlet weak var lbl_error: UILabel!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    let animationView = AnimationView()
    
    private let client = APIClient()
        
    var showPassword: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateDefaultUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showPassword = false
        btn_showPassword.setImage(UIImage(named: "invisible"), for: .normal)
        self.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
     }
    
    @IBAction func showPassword(_ sender: UIButton) {
        if showPassword {
            self.showPassword = false
            self.btn_showPassword.setImage(UIImage(named: "invisible"), for: .normal)
            self.tf_resetPassword.isSecureTextEntry = true
        } else {
            self.showPassword = true
            self.btn_showPassword.setImage(UIImage(named: "visibility"), for: .normal)
            self.tf_resetPassword.isSecureTextEntry = false
        }
    }
    
    @IBAction func updatePassword(_ sender: UIButton) {
        guard let userId = UserDefaults.standard.value(forKey: "LoggedUserId") as? Int, let newPassword = self.tf_resetPassword.text, !newPassword.isEmpty else { return }
        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        self.resetPassword(userId, withNewPassword: newPassword)
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
    
    private func disableLoaderView() {
        self.loadingBackView.backgroundColor = ConstHelper.lightGray
        self.loadingView.backgroundColor = .clear
    }

}

extension ResetPasswordViewController {
    private func updateDefaultUI() {
        self.view.backgroundColor = ConstHelper.lightGray
        self.vw_resetBackView.backgroundColor = ConstHelper.lightGray
        self.vw_resetLineView.backgroundColor = ConstHelper.gray
        self.lbl_heading.font = ConstHelper.h5Normal
        self.lbl_heading.textColor = ConstHelper.black
        
        //Change Password button
        self.btn_changePassword.backgroundColor = ConstHelper.cyan
        self.btn_changePassword.setTitleColor(ConstHelper.white, for: .normal)
        self.btn_changePassword.titleLabel?.font = ConstHelper.h3Normal
        
        self.tf_resetPassword.textColor = ConstHelper.hTextColor
        self.tf_resetPassword.font = ConstHelper.h3Normal
        self.tf_resetPassword.isSecureTextEntry = true
        
        self.lbl_error.textColor = ConstHelper.hErrorColor
        self.lbl_error.font = ConstHelper.h4Normal
        
        self.tf_resetPassword.delegate = self
        self.tf_resetPassword.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)

        btn_changePassword.backgroundColor = UIColor(red: 42/255, green: 50/255, blue: 77/255, alpha: 0.5)
        btn_changePassword.setTitleColor(.lightGray, for: .normal)
        btn_changePassword.isUserInteractionEnabled = false
        
        self.disableLoaderView()
    }
    
    private func updateUIWhenViewWillAppear() {
        self.lbl_error.text = ""

    }
    
    @objc func validateText(_ textField: UITextField) {
        switch textField {
        case tf_resetPassword:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validatePassword(text)  {
                    self.lbl_error.text = ""
                    break
                } else {
                    self.lbl_error.text = "Password should be atleast 4 characters"
                    break
                }
            } else {
                self.lbl_error.text = "Password should be atleast 4 characters"
                break
            }
        default:
            self.lbl_error.text = "Should be valid mobile number"
            self.lbl_error.text = "Password should be atleast 4 characters"
            break
        }
        
        guard let err = self.lbl_error.text, err.isEmpty
            else {
                btn_changePassword.backgroundColor = UIColor(red: 42/255, green: 50/255, blue: 77/255, alpha: 0.5)
                btn_changePassword.setTitleColor(.lightGray, for: .normal)
                btn_changePassword.isUserInteractionEnabled = false
                return
        }
        
        btn_changePassword.backgroundColor = ConstHelper.cyan
        btn_changePassword.setTitleColor(ConstHelper.enableColor, for: .normal)
        btn_changePassword.isUserInteractionEnabled = true
        
        print("executed...")
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case tf_resetPassword:
            tf_resetPassword.resignFirstResponder()
        default:
            return false
        }
        return true
    }
}

extension ResetPasswordViewController {
    private func resetPassword(_ userId: Int, withNewPassword password: String) {
        //begin..
        let parameters: ResetReqModel = ResetReqModel(userId: userId, password: password)
        
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
                    strongSelf.tf_resetPassword.text = ""
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
}
