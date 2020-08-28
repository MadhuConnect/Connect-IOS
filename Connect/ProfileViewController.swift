//
//  ProfileViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 07/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class ProfileViewController: UIViewController {

    //Profil pic
    @IBOutlet weak var vw_profileBackView: UIView!
    @IBOutlet weak var vw_profilePicBackView: UIView!
    @IBOutlet weak var iv_profileImageView: UIImageView!
    @IBOutlet weak var vw_profilePicLineView: UIView!
    @IBOutlet weak var btn_profilePic: UIButton!
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
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!

    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setupAnimation(withAnimation: false)
    }
    
    @IBAction func updateProfileAction(_ sender: UIButton) {
        
    }
    
    @IBAction func resetPasswordAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ResetPassword", bundle: nil)
        if let resetPasswordVC = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController {
            resetPasswordVC.modalPresentationStyle = .fullScreen
            self.present(resetPasswordVC, animated: true, completion: nil)
        }
    }
    
    private func setupAnimation(withAnimation status: Bool) {
        animationView.animation = Animation.named("6615-loader-animation")
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

extension ProfileViewController {
    private func updateDefaultUI() {
        self.vw_profilePicLineView.backgroundColor = ConstHelper.gray
        self.vw_fullNameLineView.backgroundColor = ConstHelper.gray
        self.vw_emailLineView.backgroundColor = ConstHelper.gray
        self.vw_mobileLineView.backgroundColor = ConstHelper.gray
        self.vw_passwordLineView.backgroundColor = ConstHelper.gray
        
        self.vw_profilePicBackView.backgroundColor = ConstHelper.lightGray
        self.vw_profilePicBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: vw_profilePicBackView.frame.size.height / 2)
        self.iv_profileImageView.image = UIImage(named: "profileUser")
        
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
        
        self.iv_profileImageView.tintColor = ConstHelper.lightGray
        self.iv_fullNameImageView.tintColor = ConstHelper.black
        self.iv_emailImageView.tintColor = ConstHelper.black
        self.iv_mobileImageView.tintColor = ConstHelper.black
        self.iv_passwordImageView.tintColor = ConstHelper.black
        
        //Disable profile input fields
        self.tf_fullNameTF.isUserInteractionEnabled = false
        self.tf_emailTF.isUserInteractionEnabled = false
        self.tf_mobileTF.isUserInteractionEnabled = false
        self.tf_passwordTF.isUserInteractionEnabled = false
        
        //Update user info
        let username = UserDefaults.standard.value(forKey: "LoggedUserName") as? String ?? "-"
        self.tf_fullNameTF.text = username
        let email = UserDefaults.standard.value(forKey: "LoggedUserEmail") as? String ?? "-"
        self.tf_emailTF.text = email
        let mobile = UserDefaults.standard.value(forKey: "LoggedUserMobile") as? String ?? "-"
        self.tf_mobileTF.text = mobile
    }
    
}
