//
//  ProfileViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 07/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    //Profil pic
    @IBOutlet weak var vw_profileBackView: UIView!
    @IBOutlet weak var vw_profilePicBackView: UIView!
    @IBOutlet weak var vw_profilePicLineView: UIView!
    @IBOutlet weak var btn_profilePic: UIButton!
    @IBOutlet weak var btn_profileCirclePic: UIButton!
    
    //Full name
    @IBOutlet weak var vw_fullnameBackView: UIView!
    @IBOutlet weak var iv_fullNameImageView: UIImageView!
    @IBOutlet weak var lbl_fullNameHeading: UILabel!
    @IBOutlet weak var tf_fullNameTF: UITextField!
    @IBOutlet weak var vw_fullNameLineView: UIView!
    
    //Email
    @IBOutlet weak var vw_emailBackView: UIView!
    @IBOutlet weak var iv_emailImageView: UIImageView!
    @IBOutlet weak var lbl_emailHeading: UILabel!
    @IBOutlet weak var tf_emailTF: UITextField!
    @IBOutlet weak var vw_emailLineView: UIView!
    
    //Mobile
    @IBOutlet weak var vw_mobileBackView: UIView!
    @IBOutlet weak var iv_mobileImageView: UIImageView!
    @IBOutlet weak var lbl_mobileHeading: UILabel!
    @IBOutlet weak var tf_mobileTF: UITextField!
    @IBOutlet weak var vw_mobileLineView: UIView!
    
    //Password
    @IBOutlet weak var vw_passwordBackView: UIView!
    @IBOutlet weak var iv_passwordImageView: UIImageView!
    @IBOutlet weak var lbl_passwordHeading: UILabel!
    @IBOutlet weak var tf_passwordTF: UITextField!
    @IBOutlet weak var btn_resetPassword: UIButton!
    @IBOutlet weak var vw_passwordLineView: UIView!
    
    @IBOutlet weak var btn_editNameEmail: UIButton!

    private let client = APIClient()
    var imagePicker: ImagePicker!
    var uploadedImageNames: [String] = []
    var isProfileEditEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.updateUIWhenViewWillAppear()
    }
    
    @IBAction func updateProfileAction(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func resetPasswordAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ResetPassword", bundle: nil)
        if let resetPasswordVC = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController {
            resetPasswordVC.modalPresentationStyle = .fullScreen
            self.present(resetPasswordVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func updateProfileNameEmailAction(_ sender: UIButton) {
        if isProfileEditEnabled {
            isProfileEditEnabled = false
            self.tf_fullNameTF.isUserInteractionEnabled = false
            self.tf_emailTF.isUserInteractionEnabled = false
            self.btn_editNameEmail.setImage(UIImage(named: "edit"), for: .normal)
            
            let fullname = self.tf_fullNameTF.text ?? ""
            let email = self.tf_emailTF.text ?? ""
            
            self.updateProfileNameEmail(fullname, email: email)
            
        } else {
            isProfileEditEnabled = true
            self.tf_fullNameTF.isUserInteractionEnabled = true
            self.tf_emailTF.isUserInteractionEnabled = true
            self.tf_fullNameTF.becomeFirstResponder()
            self.btn_editNameEmail.setImage(UIImage(named: "save"), for: .normal)
        }
    }

}

extension ProfileViewController {
    private func updateDefaultUI() {
        self.vw_profilePicLineView.backgroundColor = ConstHelper.gray
        self.vw_fullNameLineView.backgroundColor = ConstHelper.gray
        self.vw_emailLineView.backgroundColor = ConstHelper.gray
        self.vw_mobileLineView.backgroundColor = ConstHelper.gray
        self.vw_passwordLineView.backgroundColor = ConstHelper.gray
        
        self.vw_profilePicBackView.backgroundColor = ConstHelper.lightGray
        self.vw_profilePicBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: vw_profilePicBackView.frame.size.height / 2)
        self.btn_profileCirclePic.backgroundColor = ConstHelper.lightGray
        self.btn_profileCirclePic.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: vw_profilePicBackView.frame.size.height / 2)
        
        //Fullname
        self.lbl_fullNameHeading.font = ConstHelper.h5Normal
        self.lbl_fullNameHeading.textColor = ConstHelper.black
        self.tf_fullNameTF.font = ConstHelper.h5Normal
        self.tf_fullNameTF.textColor = ConstHelper.gray
        //Email
        self.lbl_emailHeading.font = ConstHelper.h5Normal
        self.lbl_emailHeading.textColor = ConstHelper.black
        self.tf_emailTF.font = ConstHelper.h5Normal
        self.tf_emailTF.textColor = ConstHelper.gray
        //Mobile
        self.lbl_mobileHeading.font = ConstHelper.h5Normal
        self.lbl_mobileHeading.textColor = ConstHelper.black
        self.tf_mobileTF.font = ConstHelper.h5Normal
        self.tf_mobileTF.textColor = ConstHelper.gray
        //Password
        self.lbl_passwordHeading.font = ConstHelper.h5Normal
        self.lbl_passwordHeading.textColor = ConstHelper.black
        self.tf_passwordTF.font = ConstHelper.h5Normal
        self.tf_passwordTF.textColor = ConstHelper.gray
        
        self.iv_fullNameImageView.tintColor = ConstHelper.black
        self.iv_emailImageView.tintColor = ConstHelper.black
        self.iv_mobileImageView.tintColor = ConstHelper.black
        self.iv_passwordImageView.tintColor = ConstHelper.black
        
    }
    
    private func updateUIWhenViewWillAppear() {
        //Update user info
        let username = UserDefaults.standard.value(forKey: "LoggedUserName") as? String ?? "-"
        self.tf_fullNameTF.text = username
        let email = UserDefaults.standard.value(forKey: "LoggedUserEmail") as? String ?? ""
        self.tf_emailTF.text = email
        self.tf_emailTF.placeholder = "-"
        let mobile = UserDefaults.standard.value(forKey: "LoggedUserMobile") as? String ?? "-"
        self.tf_mobileTF.text = mobile
        self.tf_mobileTF.placeholder = ""
        
        //Disable profile input fields
        self.tf_fullNameTF.isUserInteractionEnabled = false
        self.tf_emailTF.isUserInteractionEnabled = false
        self.tf_mobileTF.isUserInteractionEnabled = false
        self.tf_passwordTF.isUserInteractionEnabled = false
        
        isProfileEditEnabled = false
        self.btn_editNameEmail.setImage(UIImage(named: "edit"), for: .normal)
        
        guard let imageUrl = UserDefaults.standard.value(forKey: "LoggedUserProfileImage") as? String, let url = URL(string: imageUrl) else {
            return
        }
        
        self.downloadImage(url: url)
    }
}

//MARK: - API Call
extension ProfileViewController {
    //MARK: - Image upload (multipart/form-data)
    private func uploadProductImages(_ image: UIImage?, imagePath: String) {
        let parameters = [
            [
                "key": "profilePic",
                "src": "\(imagePath)",
                "type": "file"
            ],
            [
                "key": "status",
                "value": "image",
                "type": "text"
            ]] as [[String : Any]]
        
        do {
            let boundary = "Boundary-\(UUID().uuidString)"
            var body = ""
            //            var error: Error? = nil
            for param in parameters {
                if param["disabled"] == nil {
                    let paramName = param["key"]!
                    body += "--\(boundary)\r\n"
                    body += "Content-Disposition:form-data; name=\"\(paramName)\""
                    let paramType = param["type"] as! String
                    if paramType == "text" {
                        let paramValue = param["value"] as! String
                        body += "\r\n\r\n\(paramValue)\r\n"
                    } else {
                        let paramSrc = param["src"] as! String
                        let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
                        let fileContent = String(data: fileData, encoding: .utf8) ?? ""
                        body += "; filename=\"\(paramSrc)\"\r\n"
                            + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                    }
                }
            }
            body += "--\(boundary)--\r\n";
            let postData = body.data(using: .utf8)
            
            //API
            let api: Apifeed = .updateProfilePic
            
            let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("multipart/form-data; boundary=\(boundary)"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: postData, timeInterval: Double.infinity)
            
            client.post_ProfilePicture(from: endpoint) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let response):
                    guard let response = response else { return }
                    
                    if response.status {
                        strongSelf.storeUserDetailsForFurtherUse(response)
                        DispatchQueue.main.async {
                            guard let url = URL(string: response.data?.profileImage ?? "") else {
                                return
                            }
                            
                            strongSelf.downloadImage(url: url)
                        }
                    } else {
                        strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(response.message ?? "")", actionTitle: "Ok")
                        return
                    }
                    
                case .failure(let error):
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
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
    
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: btn_profileCirclePic.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 10)
        self.btn_profileCirclePic.kf.setBackgroundImage(
            with: url,
            for: .normal,
            placeholder: UIImage(named: "noimage"),
            options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    //Psot Form Filling Data
    private func updateProfileNameEmail(_ fullname: String, email: String) {
        let parameters = ["name": fullname, "email": email]
        
        print("Par: \(parameters)")

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        let api: Apifeed = .updateProfileData

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        client.post_ProfileNameEmail(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else { return }

                if response.status {
                    strongSelf.storeUserDetailsForFurtherUse(response)
                    DispatchQueue.main.async {
                        guard let url = URL(string: response.data?.profileImage ?? "") else {
                            return
                        }
                        
                        strongSelf.downloadImage(url: url)
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

extension ProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, imagePath: String?) {
        if let image = image {
            DispatchQueue.main.async {
                self.btn_profileCirclePic.setBackgroundImage(image, for: .normal)
                self.uploadProductImages(image, imagePath: (imagePath ?? ""))
            }
        }
    }
    
    

}
