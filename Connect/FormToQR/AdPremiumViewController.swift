//
//  AddPremiumViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 19/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class AdPremiumViewController: UIViewController {
    
    @IBOutlet weak var tv_choosePlanTableView: UITableView!
    
    @IBOutlet weak var lbl_addPremiumTitle: UILabel!
    
    @IBOutlet weak var iv_addPremiumImageView: UIImageView!
    
    @IBOutlet weak var vw_addPremiumNameBackView: UIView!
    @IBOutlet weak var tf_addPremiumNameTF: UITextField!
    @IBOutlet weak var lbl_errorNameLbl: UILabel!
    
    @IBOutlet weak var vw_addPremiumMobileBackView: UIView!
    @IBOutlet weak var tf_addPremiumMobileTF: UITextField!
    @IBOutlet weak var lbl_errorMobileLbl: UILabel!
    
    @IBOutlet weak var vw_addPremiumEmailBackView: UIView!
    @IBOutlet weak var tf_addPremiumEmailTF: UITextField!
    @IBOutlet weak var lbl_errorEmailLbl: UILabel!
    
    @IBOutlet weak var  lbl_addPremiumChoosePlan: UILabel!
    @IBOutlet weak var btn_addPremiumSubmitRequest: UIButton!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lbl_message: UILabel!

    private let client = APIClient()
    var adPremiumPlans: AdPremiumPlanResModel?
    var premiumPlan: PremiumPlan?
    var qrCodeId: Int?
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.updateUIWhenViewWillAppear()
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
    
    @IBAction func submitRequestAction(_ sender: UIButton) {
        guard
            let name = self.tf_addPremiumNameTF.text,
            let mobile = self.tf_addPremiumMobileTF.text else {
            return
        }
        
        if name.isEmpty || name.count == 0 {
            showAlertMini(title: AlertMessage.errTitle.rawValue, message: AlertMessage.emptyName.rawValue, actionTitle: "OK")
            return
        }
        
        if mobile.isEmpty || mobile.count == 0 {
            showAlertMini(title: AlertMessage.errTitle.rawValue, message: AlertMessage.emptyMobileNumber.rawValue, actionTitle: "OK")
            return
        }
        
        if self.premiumPlan != nil {
            let b2bRequest = B2bRequestModel(qrId: self.qrCodeId, requirement: name, mobile: mobile, email: self.tf_addPremiumEmailTF.text, subscriptionId: self.premiumPlan?.subscriptionId)
            self.postB2bRequest(with: b2bRequest)
        } else {
            showAlertMini(title: AlertMessage.errTitle.rawValue, message: "Please choose plan and submit request", actionTitle: "OK")
            return
        }
        

    }
    
    private func qrAlphaViewController() {
        if let qrAlphaVC = self.storyboard?.instantiateViewController(withIdentifier: "QRAlphaViewController") as? QRAlphaViewController {
            self.present(qrAlphaVC, animated: true, completion: nil)
        }
    }
}

extension AdPremiumViewController {
    private func updateDefaultUI() {
        tv_choosePlanTableView.delegate = self
        tv_choosePlanTableView.dataSource = self
        
        tv_choosePlanTableView.tableFooterView = UIView(frame: .zero)
        
        tf_addPremiumNameTF.delegate = self
        tf_addPremiumMobileTF.delegate = self
        tf_addPremiumEmailTF.delegate = self
        
        vw_addPremiumNameBackView.addBottomBorder(with: .gray, andWidth: 1)
        vw_addPremiumMobileBackView.addBottomBorder(with: .gray, andWidth: 1)
        vw_addPremiumEmailBackView.addBottomBorder(with: .gray, andWidth: 1)
        
        self.tf_addPremiumNameTF.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.lightWhiteGray])
        self.tf_addPremiumMobileTF.attributedPlaceholder = NSAttributedString(string: "Mobile No", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.lightWhiteGray])
        self.tf_addPremiumEmailTF.attributedPlaceholder = NSAttributedString(string: "Email ID", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.lightWhiteGray])
        
        self.tf_addPremiumNameTF.textColor = ConstHelper.hTextColor
        self.tf_addPremiumNameTF.font = ConstHelper.h3Normal
        
        self.tf_addPremiumMobileTF.textColor = ConstHelper.hTextColor
        self.tf_addPremiumMobileTF.font = ConstHelper.h3Normal
        
        self.tf_addPremiumEmailTF.textColor = ConstHelper.hTextColor
        self.tf_addPremiumEmailTF.font = ConstHelper.h3Normal
        
        self.tf_addPremiumNameTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        self.tf_addPremiumMobileTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        self.tf_addPremiumEmailTF.addTarget(self, action: #selector(validateText(_:)), for: .editingChanged)
        
        self.lbl_errorNameLbl.textColor = ConstHelper.red
        self.lbl_errorNameLbl.font = ConstHelper.h6Normal
        
        self.lbl_errorMobileLbl.textColor = ConstHelper.red
        self.lbl_errorMobileLbl.font = ConstHelper.h6Normal
        
        self.lbl_errorEmailLbl.textColor = ConstHelper.red
        self.lbl_errorEmailLbl.font = ConstHelper.h6Normal
        
        self.btn_addPremiumSubmitRequest.backgroundColor = ConstHelper.cyan
        self.btn_addPremiumSubmitRequest.setTitleColor(ConstHelper.white, for: .normal)
        self.btn_addPremiumSubmitRequest.titleLabel?.font = ConstHelper.h3Bold
    }
    
    private func updateUIWhenViewWillAppear() {
        self.getPremiumPlans()
    }
    
    @objc func validateText(_ textField: UITextField) {
        switch textField {
        case tf_addPremiumNameTF:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validateName(text) {
                    self.lbl_errorNameLbl.text = ""
                    enableSubmitRequestButton()
                    break
                } else {
                    self.lbl_errorNameLbl.text = "Name should be minimum 4 characters"
                    self.disableSubmitRequestButton()
                    break
                }
            } else {
                self.lbl_errorNameLbl.text = "Name should be minimum 4 characters"
                self.disableSubmitRequestButton()
                break
            }
        case tf_addPremiumMobileTF:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validateMobile(text)  {
                    self.lbl_errorMobileLbl.text = ""
                    enableSubmitRequestButton()
                    break
                } else {
                    self.lbl_errorMobileLbl.text = "Should be valid mobile number"
                    self.disableSubmitRequestButton()
                    break
                }
            } else {
                self.lbl_errorMobileLbl.text = "Should be valid mobile number"
                self.disableSubmitRequestButton()
                break
            }
        case tf_addPremiumEmailTF:
            if let text = textField.text, (!text.isEmpty) {
                if VBValidatiors.validateEmailId(text)  {
                    self.lbl_errorEmailLbl.text = ""
                    enableSubmitRequestButton()
                    break
                } else {
                    self.lbl_errorEmailLbl.text = "Should be valid email id"
                    self.disableSubmitRequestButton()
                    break
                }
            } else {
                self.lbl_errorEmailLbl.text = ""
                enableSubmitRequestButton()
                break
            }
        default:
            self.lbl_errorNameLbl.text = "Name should be minimum 4 characters"
            self.lbl_errorMobileLbl.text = "Should be valid mobile number"
            self.lbl_errorEmailLbl.text = "Should be valid email id"
            self.disableSubmitRequestButton()
            break
        }

    }
    
    private func disableSubmitRequestButton() {
        btn_addPremiumSubmitRequest.backgroundColor = ConstHelper.disableColor
        btn_addPremiumSubmitRequest.setTitleColor(.lightGray, for: .normal)
        btn_addPremiumSubmitRequest.isUserInteractionEnabled = false
    }
    
    private func enableSubmitRequestButton() {
        btn_addPremiumSubmitRequest.backgroundColor = ConstHelper.cyan
        btn_addPremiumSubmitRequest.setTitleColor(.white, for: .normal)
        btn_addPremiumSubmitRequest.isUserInteractionEnabled = true
    }
}

extension AdPremiumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let premiumPlans = self.adPremiumPlans?.data {
            return premiumPlans.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cpCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.choosePlanCellTableViewCell, for: indexPath) as! ChoosePlanCell
        
        if let plan = self.adPremiumPlans?.data?[indexPath.row] {
            
            let isExist = (plan.subscriptionId == self.premiumPlan?.subscriptionId ?? 0) ? true : false
            cpCell.btn_plan.setImage(isExist ? UIImage(named: "ellipseChecked") : UIImage(named: "ellipse"), for: .normal)
            cpCell.setPlan(plan)
        }
        
        cpCell.btn_plan.tag = indexPath.row
        cpCell.btn_plan.addTarget(self, action: #selector(chooseAddPremiumPlanAction(_:)), for: .touchUpInside)
        return cpCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}

extension AdPremiumViewController {
    private func getPremiumPlans() {
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .getPremiumPlans
        
        let endPoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get, headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)
        
        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        client.get_premiumPlans(from: endPoint) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
            strongSelf.adPremiumPlans = nil
            
            switch result {
            case .success(let res):
                guard let res = res else { return }
                if res.status {
                    strongSelf.adPremiumPlans = res
                    DispatchQueue.main.async {
                        guard let imgUrl = URL(string: res.b2bImg ?? "") else { return }
                        strongSelf.downloadImage(url: imgUrl )
                        strongSelf.tv_choosePlanTableView.reloadData()
                    }
                } else {
                    strongSelf.adPremiumPlans = nil
                    debugPrint("No data found!!")
                }
                                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func postB2bRequest(with parameters: B2bRequestModel) {
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .b2bRequest

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        client.post_b2bRequest(from: endpoint) { [weak self] result in
             guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
             switch result {
             case .success(let res):
                 guard let res = res else { return }
                if res.status {
                    debugPrint("B2b request placed successfully.")
                    DispatchQueue.main.async {
                        strongSelf.qrAlphaViewController()
                    }
                } else {
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(res.message ?? "")", actionTitle: "Ok")
                }
             case .failure(let error):
                debugPrint(error.localizedDescription)
             }
         }
    }
    
    @objc func chooseAddPremiumPlanAction(_ sender: UIButton) {
        let premium = self.adPremiumPlans?.data?[sender.tag]
        self.premiumPlan = premium
        self.tv_choosePlanTableView.reloadData()
    }
}

extension AdPremiumViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case tf_addPremiumNameTF:
            tf_addPremiumNameTF.resignFirstResponder()
        case tf_addPremiumMobileTF:
            tf_addPremiumMobileTF.resignFirstResponder()
        case tf_addPremiumEmailTF:
            tf_addPremiumEmailTF.resignFirstResponder()
        default:
            return false
        }
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentString = (textField.text ?? "") as NSString
//        let newString =
//            currentString.replacingCharacters(in: range, with: string)
//        return (newString.count > 0) ? true : false
//    }
}


extension AdPremiumViewController {
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: iv_addPremiumImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        self.iv_addPremiumImageView.kf.indicatorType = .activity
        iv_addPremiumImageView.kf.setImage(
            with: url,
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
}
