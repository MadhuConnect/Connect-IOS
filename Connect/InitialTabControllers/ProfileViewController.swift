//
//  ProfileViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 07/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

struct UploadProfile {
    let image: Data
    let imageUrl: String
    let imageName: String
}

typealias ComplitionHandler = (_ response: Any, _ error: Error?, _ isSuccess: Bool) -> Void


class ProfileViewController: UIViewController {

    //Profil pic
    @IBOutlet weak var vw_profileBackView: UIView!
    @IBOutlet weak var vw_profilePicBackView: UIView!
    @IBOutlet weak var vw_profilePicLineView: UIView!
    @IBOutlet weak var btn_profilePic: UIButton!
    @IBOutlet weak var btn_profileCirclePic: UIButton!
    @IBOutlet weak var iv_profileImageView: UIImageView!
    
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
    
    @IBOutlet weak var vw_otpAlphaView: UIView!
    @IBOutlet weak var vw_otpBackView: UIView!
    @IBOutlet weak var vw_otpLineView: UIView!
    @IBOutlet weak var lbl_otpMessage: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var tf_otpTF: UITextField!
    
    @IBOutlet weak var iv_accountVerified: UIImageView!
    @IBOutlet weak var lbl_userFullName: UILabel!
    
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
        guard let mobile = UserDefaults.standard.value(forKey: "LoggedUserMobile") as? String, !mobile.isEmpty else {
            return
        }
        
        self.lbl_passwordHeading.font = ConstHelper.h5Bold
        self.lbl_passwordHeading.textColor = ConstHelper.blue
        self.lbl_passwordHeading.addUnderline("Reset Password")
        
        self.resetUserPassword(mobile)
    }
    
    @IBAction func emergencyReqAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
        if let emergencyRequestVC = storyboard.instantiateViewController(withIdentifier: "EmergencyRequestViewController") as? EmergencyRequestViewController {
            emergencyRequestVC.modalPresentationStyle = .fullScreen
            emergencyRequestVC.isFromNotHome = true
            self.present(emergencyRequestVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func updateProfileNameEmailAction(_ sender: UIButton) {
        if isProfileEditEnabled {
            isProfileEditEnabled = false
            self.tf_fullNameTF.isUserInteractionEnabled = false
            self.tf_emailTF.isUserInteractionEnabled = false
            self.btn_editNameEmail.setBackgroundImage(UIImage(named: "cyn_edit"), for: .normal)
            
            let fullname = self.tf_fullNameTF.text ?? ""
            let email = self.tf_emailTF.text ?? ""
            
            self.updateProfileNameEmail(fullname, email: email)
            
        } else {
            isProfileEditEnabled = true
            self.tf_fullNameTF.isUserInteractionEnabled = true
            self.tf_emailTF.isUserInteractionEnabled = true
            self.tf_fullNameTF.becomeFirstResponder()
            self.btn_editNameEmail.setBackgroundImage(UIImage(named: "cyn_save"), for: .normal)
        }
    }
    
    @IBAction func cancelOtpAction(_ sender: UIButton) {
        self.vw_otpAlphaView.isHidden = true
        self.vw_otpBackView.isHidden = true
        self.tf_otpTF.text = ""
        self.tf_otpTF.resignFirstResponder()
        
        self.lbl_passwordHeading.font = ConstHelper.h5Normal
        self.lbl_passwordHeading.textColor = ConstHelper.blue
        self.lbl_passwordHeading.addUnderline("Reset Password")
    }
    
    @IBAction func submitOtpAction(_ sender: UIButton) {
        guard let mobile = UserDefaults.standard.value(forKey: "LoggedUserMobile") as? String, !mobile.isEmpty, let otp = self.tf_otpTF.text, !otp.isEmpty, let token = ConstHelper.deviceToken, !token.isEmpty else {
            return
        }
        
        self.postOTPUser(withMobile: mobile, otp: otp, type: "Forget", andToken: token)
        
    }
    
    private func moveToResetPasswordViewController() {
        let storyboard = UIStoryboard(name: "ResetPassword", bundle: nil)
        if let resetPasswordVC = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController {
            resetPasswordVC.modalPresentationStyle = .fullScreen
            self.present(resetPasswordVC, animated: true, completion: nil)
        }
        
        self.lbl_passwordHeading.font = ConstHelper.h5Normal
        self.lbl_passwordHeading.textColor = ConstHelper.blue
        self.lbl_passwordHeading.addUnderline("Reset Password")
    }

}

extension ProfileViewController {
    private func updateDefaultUI() {
        self.tf_otpTF.delegate = self
        
        self.vw_profilePicLineView.backgroundColor = ConstHelper.gray
        self.vw_fullNameLineView.backgroundColor = ConstHelper.gray
        self.vw_emailLineView.backgroundColor = ConstHelper.gray
        self.vw_mobileLineView.backgroundColor = ConstHelper.gray
        self.vw_passwordLineView.backgroundColor = ConstHelper.gray
        self.vw_otpLineView.backgroundColor = ConstHelper.gray
                
        self.vw_profilePicBackView.backgroundColor = ConstHelper.lightGray
        self.vw_profilePicBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: vw_profilePicBackView.frame.size.height / 2)
        self.btn_profileCirclePic.backgroundColor = ConstHelper.lightGray
        self.btn_profileCirclePic.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: btn_profileCirclePic.frame.size.height / 2)
        self.vw_otpBackView.setBorderForView(width: 1, color: .white, radius: 10)
        
        self.tf_otpTF.textColor = ConstHelper.hTextColor
        self.tf_otpTF.font = ConstHelper.h3Normal
        
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
        self.lbl_passwordHeading.textColor = ConstHelper.blue
        self.lbl_passwordHeading.addUnderline("Reset Password")
        self.tf_passwordTF.font = ConstHelper.h5Normal
        self.tf_passwordTF.textColor = ConstHelper.gray
        
        self.iv_fullNameImageView.tintColor = ConstHelper.black
        self.iv_emailImageView.tintColor = ConstHelper.black
        self.iv_mobileImageView.tintColor = ConstHelper.black
        self.iv_passwordImageView.tintColor = ConstHelper.black
        
        self.lbl_otpMessage.textColor = ConstHelper.black
        self.lbl_otpMessage.font = ConstHelper.h5Normal
        
        self.lbl_userFullName.font = ConstHelper.h3Normal
        self.lbl_userFullName.textColor = ConstHelper.black
        
        self.tf_otpTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
    }
    
    private func updateUIWhenViewWillAppear() {
        //Update user info
        self.vw_otpAlphaView.isHidden = true
        self.vw_otpBackView.isHidden = true
        
        let username = UserDefaults.standard.value(forKey: "LoggedUserName") as? String ?? "-"
        self.tf_fullNameTF.text = username
        self.lbl_userFullName.text = username
        let email = UserDefaults.standard.value(forKey: "LoggedUserEmail") as? String ?? ""
        self.tf_emailTF.text = email
        self.tf_emailTF.placeholder = "-"
        let mobile = UserDefaults.standard.value(forKey: "LoggedUserMobile") as? String ?? "-"
        
        var newMobile: String = ""
        if !mobile.contains("+91") {
            newMobile = "+91" + mobile
        } else {
            newMobile = mobile
        }
        
        let isAccountVerified = UserDefaults.standard.value(forKey: "LoggedKYC") as? Bool ?? false
        
        if isAccountVerified {
            self.iv_accountVerified.image = UIImage(named: "cyn_greenVerified")
        } else {
            self.iv_accountVerified.image = UIImage(named: "cyn_grayNotVerified")
        }
        
        self.lbl_otpMessage.text = "Please enter OTP sent to your number" + "\n" + "\(newMobile) to change your password"
        
        self.tf_mobileTF.text = newMobile
        self.tf_mobileTF.placeholder = ""
        
        //Disable profile input fields
        self.tf_fullNameTF.isUserInteractionEnabled = false
        self.tf_emailTF.isUserInteractionEnabled = false
        self.tf_mobileTF.isUserInteractionEnabled = false
        self.tf_passwordTF.isUserInteractionEnabled = false
        
        isProfileEditEnabled = false
        self.btn_editNameEmail.setBackgroundImage(UIImage(named: "cyn_edit"), for: .normal)
        
        guard let imageUrl = UserDefaults.standard.value(forKey: "LoggedUserProfileImage") as? String, let url = URL(string: imageUrl) else {
            return
        }
        
        self.downloadImage(url: url)

    }
    
    
    @objc func validateText(_ textField: UITextField) {
        switch textField {
        case tf_otpTF:
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
            let otp = self.tf_otpTF.text, !otp.isEmpty else {
                return
        }
        
    }
}

//MARK: - API Call
extension ProfileViewController {
    private func storeUserDetailsForFurtherUse(_ user: LoginResModel) {
        UserDefaults.standard.set(user.verificationStatus, forKey: "UserVerificationStatus")
        UserDefaults.standard.set(user.data?.userId, forKey: "LoggedUserId")
        UserDefaults.standard.set(user.data?.name, forKey: "LoggedUserName")
        UserDefaults.standard.set(user.data?.mobile, forKey: "LoggedUserMobile")
        UserDefaults.standard.set(user.data?.email, forKey: "LoggedUserEmail")
        UserDefaults.standard.set(user.data?.jwToken, forKey: "LoggedUserJWTToken")
        UserDefaults.standard.set(user.data?.profileImage, forKey: "LoggedUserProfileImage")
        UserDefaults.standard.set(user.data?.kyc, forKey: "LoggedKYC")
        UserDefaults.standard.set(true, forKey: "loginStatusKey")
        UserDefaults.standard.synchronize()
    }
    
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: btn_profileCirclePic.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 60)
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
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
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
    
    private func postOTPUser(withMobile mobile: String, otp: String, type: String, andToken token: String) {
        //begin..
        let parameters: OTPReqModel = OTPReqModel(mobile: mobile, otp: otp, token: token, type: type)

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .checkOtp

        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json")], body: body, timeInterval: 120)

        client.post_checkReceivedOTP(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                guard  let user = user else { return }

                if user.status {
                    strongSelf.storeUserDetailsForFurtherUse(user)
                    DispatchQueue.main.async {
                        strongSelf.moveToResetPasswordViewController()
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
        //..end
    }
    
    private func resetUserPassword(_ mobile: String) {
        //begin..
        let parameters = ["mobile": mobile]
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
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
                        strongSelf.vw_otpAlphaView.isHidden = false
                        strongSelf.vw_otpBackView.isHidden = false
                        strongSelf.tf_otpTF.text = ""
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
        //..end
    }
    
    private func storeUserDetailsForFurtherUse(_ user: OTPResModel) {
        UserDefaults.standard.set(user.verificationStatus, forKey: "UserVerificationStatus")
        UserDefaults.standard.set(user.data?.userId, forKey: "LoggedUserId")
        UserDefaults.standard.set(user.data?.name, forKey: "LoggedUserName")
        UserDefaults.standard.set(user.data?.mobile, forKey: "LoggedUserMobile")
        UserDefaults.standard.set(user.data?.email, forKey: "LoggedUserEmail")
        ConstHelper.DYNAMIC_TOKEN = user.data?.jwToken ?? ""
        UserDefaults.standard.set(user.data?.jwToken, forKey: "LoggedUserJWTToken")
        UserDefaults.standard.set(user.data?.profileImage, forKey: "LoggedUserProfileImage")
        UserDefaults.standard.set(user.data?.kyc, forKey: "LoggedKYC")
        UserDefaults.standard.set(true, forKey: "loginStatusKey")
        UserDefaults.standard.synchronize()
    }
}

extension ProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, imagePath: String?, name: String?) {
        if let image = image {
            DispatchQueue.main.async {
                self.btn_profileCirclePic.setBackgroundImage(image, for: .normal)
                guard let imgData = image.jpegData(compressionQuality: 0.6), let url = imagePath, let name = name else { return }
                self.uploadProfilePictureWith([UploadProfile(image: imgData, imageUrl: url, imageName: name)])
            }
        }
    }

    
    

}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case tf_otpTF:
            tf_otpTF.resignFirstResponder()
        default:
            return false
        }
        return true
    }
}


// MARK: Multipart Service call ---
extension ProfileViewController {
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private func uploadProfilePictureWith(_ profile: [UploadProfile]) {
        let parameter = ["status": "image"]
        self.uploadMultipartDataForProfileWith(profile, parameters: parameter)
    }
    
    private func uploadMultipartDataForProfileWith(_ profile: [UploadProfile], parameters: [String: String]) {
//        let url = NSURL(string: "http://ios.connectyourneed.in/api/QuickNeeds/updateProfilePic")
        let endPoint = "/api/QuickNeeds/updateProfilePic"
        let url = NSURL(string: DynamicBaseUrl.baseUrl.rawValue + endPoint)
        
        let boundary = generateBoundaryString()
        
        //Request
        let request = NSMutableURLRequest(url:url! as URL);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ConstHelper.DYNAMIC_TOKEN, forHTTPHeaderField:"Authorization" )
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = self.createData(withBoundary: boundary, parameters: parameters, profiles: profile)
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [weak self]
            data, response, error in
            guard let strongSelf = self else { return }
            
            if error != nil {
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(LoginResModel.self, from: data)
                
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
            } catch {
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
            }
            
            dispatchGroup.leave()
        }
        
        task.resume()
        
        
    }
    
    private func createData(withBoundary boundary: String, parameters: [String: String], profiles: [UploadProfile]) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        let mimetype = "image/jpg"
        let fieldName = "profilePic"
        
        for profile in profiles {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(profile.imageName)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(profile.image)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        
        return body
    }
}


extension Data {

    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
