//
//  EmergencyRequestViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 25/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class EmergencyRequestViewController: UIViewController {

    @IBOutlet weak var cv_emergencyTypesCollectionView: UICollectionView!
    @IBOutlet weak var cv_bloodGroupsCollectionView: UICollectionView!
    
    @IBOutlet weak var vw_view1BackView: UIView!
    @IBOutlet weak var vw_view2BackView: UIView!
    @IBOutlet weak var vw_view3BackView: UIView!

    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_emrgencyHeading: UILabel!
    @IBOutlet weak var lbl_emrgencyHeadingTip: UILabel!
    @IBOutlet weak var lbl_bloodHeading: UILabel!
    
    @IBOutlet weak var lbl_requestDescHeading: UILabel!
    @IBOutlet weak var vw_requestDescBackView: UIView!
    @IBOutlet weak var lbl_requestDescPlaceholder: UILabel!
    @IBOutlet weak var tv_requestDescTV: UITextView!
    @IBOutlet weak var btn_post: UIButton!
    
    @IBOutlet weak var vw_postResultAlphaBackView: UIView!
    @IBOutlet weak var vw_postResultBackView: UIView!
    @IBOutlet weak var lbl_postedSuccess: UILabel!
    @IBOutlet weak var vw_postedSuccessLineView: UIView!
    @IBOutlet weak var lbl_emergencyReason: UILabel!
    @IBOutlet weak var vw_emergencyReasoLineView: UIView!
    @IBOutlet weak var vw_emergencyLogoView: UIView!
    @IBOutlet weak var lbl_emergencyType: UILabel!
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var btn_home: UIButton!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    
    //Lottie
    @IBOutlet weak var loaderWaitBackView: UIView!
    @IBOutlet weak var waitBackView: UIView!
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var lbl_waitMessage: UILabel!
    
    private let client = APIClient()
    let animationView = AnimationView()
    let animationWaitView = AnimationView()
    let animationEmergencyLogoView = AnimationView()
    
    var emergencyTypes: [EmergencyModel]?
    var bloodGroups: [EmergencyTypes]?
    let booldTypesLottie = [ConstHelper.lottie_bloodBag, ConstHelper.lottie_plasma]
    
    var eTypeId: Int?
    var eType: String?
    var isFromNotHome: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUIWhenViewWillAppear()
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAction(_ sender: UIButton) {
        guard let additionalInfo = self.tv_requestDescTV.text, !additionalInfo.isEmpty else {
            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Please enter information", actionTitle: "Ok")
            return
        }
        
        self.setupWaitAnimation(withAnimation: true, name: ConstHelper.lottie_emerequest)
        self.postEmergencyRequest(eTypeId ?? 0, bloodType: eType, additionalInformation: additionalInfo)
        
    }
    
    @IBAction func homeAction(_ sender: UIButton) {
        if self.isFromNotHome {
            Switcher.updateRootViewController(setTabIndex: 0)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.tv_requestDescTV.text = ""
        self.vw_postResultAlphaBackView.isHidden = true
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

    private func setupWaitAnimation(withAnimation status: Bool, name: String) {
        animationWaitView.animation = Animation.named(name)
        animationWaitView.frame = waitView.bounds
        animationWaitView.backgroundColor = ConstHelper.white
        animationWaitView.contentMode = .scaleAspectFit
        animationWaitView.loopMode = .loop
        if status {
            animationWaitView.play()
            waitView.addSubview(animationWaitView)
            loaderWaitBackView.isHidden = false
        }
        else {
            animationWaitView.stop()
            loaderWaitBackView.isHidden = true
        }

    }
    
    private func setupEmergencyLogoAnimation(withAnimation status: Bool, name: String) {
        animationEmergencyLogoView.animation = Animation.named(name)
        animationEmergencyLogoView.frame = vw_emergencyLogoView.bounds
        animationEmergencyLogoView.backgroundColor = ConstHelper.white
        animationEmergencyLogoView.contentMode = .scaleAspectFit
        animationEmergencyLogoView.loopMode = .loop
        animationEmergencyLogoView.play()
        vw_emergencyLogoView.addSubview(animationEmergencyLogoView)
    }
}

extension EmergencyRequestViewController {
    private func updateDefaultUI() {
        navigationController?.navigationBar.isHidden = true
        self.lbl_title.text = "Emergency Request"
        
        self.cv_emergencyTypesCollectionView.delegate = self
        self.cv_emergencyTypesCollectionView.dataSource = self
        
        self.vw_view1BackView.backgroundColor = ConstHelper.lightGray
        self.vw_view2BackView.backgroundColor = ConstHelper.lightGray
        self.vw_view3BackView.backgroundColor = ConstHelper.lightGray

        self.cv_bloodGroupsCollectionView.delegate = self
        self.cv_bloodGroupsCollectionView.dataSource = self
        
        self.lbl_emrgencyHeading.font = ConstHelper.h4Bold
        self.lbl_emrgencyHeading.textColor = ConstHelper.cyan
        self.lbl_emrgencyHeadingTip.font = ConstHelper.h5Normal
        self.lbl_emrgencyHeadingTip.textColor = ConstHelper.gray
        self.lbl_bloodHeading.font = ConstHelper.h4Bold
        self.lbl_bloodHeading.textColor = ConstHelper.cyan
        
        self.cv_bloodGroupsCollectionView.backgroundColor = .clear
        self.tv_requestDescTV.delegate = self
        self.lbl_requestDescHeading.font = ConstHelper.h4Bold
        self.lbl_requestDescHeading.textColor = ConstHelper.cyan
        self.lbl_requestDescPlaceholder.font = ConstHelper.h5Normal
        self.lbl_requestDescPlaceholder.textColor = ConstHelper.lightGray
        self.vw_requestDescBackView.setBorderForView(width: 1, color: ConstHelper.cyan, radius: 10)
        
        self.vw_postResultBackView.setBorderForView(width: 1, color: .clear, radius: 10)
        self.lbl_postedSuccess.font = ConstHelper.h4Bold
        self.lbl_postedSuccess.textColor = ConstHelper.orange
        self.lbl_emergencyReason.font = ConstHelper.h4Bold
        self.lbl_emergencyReason.textColor = ConstHelper.black
        self.lbl_emergencyType.font = ConstHelper.h4Bold
        self.lbl_emergencyType.textColor = ConstHelper.black
        self.lbl_emergencyReason.text = "Reason: Blood"
        self.lbl_emergencyType.text = "Type: O+"
        
        self.btn_home.backgroundColor = ConstHelper.orange
        self.btn_home.setTitleColor(ConstHelper.white, for: .normal)
        self.btn_home.titleLabel?.font = ConstHelper.h4Bold
        
        self.lbl_message.font = ConstHelper.h6Normal
        self.lbl_message.textColor = ConstHelper.gray
        
        self.lbl_waitMessage.font = ConstHelper.h6Normal
        self.lbl_waitMessage.textColor = ConstHelper.gray
        
        self.lbl_waitMessage.text = "Emergency Request"
        
        self.loaderWaitBackView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        self.waitBackView.setBorderForView(width: 0, color: ConstHelper.white, radius: 10)
        
        self.tv_requestDescTV.backgroundColor = .white
        self.tv_requestDescTV.textColor = ConstHelper.black
    }
    
    private func updateUIWhenViewWillAppear() {        
        self.setupWaitAnimation(withAnimation: false, name: ConstHelper.lottie_emerequest)
        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        self.getEmergencyRequestInfo()
        self.vw_postResultAlphaBackView.isHidden = true
    }

}

//MARK: - API Call
extension EmergencyRequestViewController {
    private func getEmergencyRequestInfo() {
        //API
//        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseEmergencyTypes.rawValue
        let api: Apifeed = .emergencyTypes
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)
        
        client.get_EmergencyTypes(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
            switch result {
            case .success(let result):
                guard  let result = result else { return }
                strongSelf.emergencyTypes?.removeAll()
                strongSelf.bloodGroups?.removeAll()
                
                if result.status {
                    strongSelf.emergencyTypes = result.data
                    strongSelf.bloodGroups = result.data?.first?.types
                    strongSelf.eTypeId = result.data?.first?.emergecnyTypeId
                    strongSelf.eType = result.data?.first?.types?.first?.type
                    
                    strongSelf.cv_emergencyTypesCollectionView.reloadData()
                    strongSelf.cv_bloodGroupsCollectionView.reloadData()
                    
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(item: 0, section: 0)
                        strongSelf.cv_emergencyTypesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                        strongSelf.cv_bloodGroupsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                    }
                } else {
                    strongSelf.lbl_message.text = result.message ?? ""
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.error_animation)
                    return
                }
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                return
            }
        }
        
    }
    
    //POST emergency request
    private func postEmergencyRequest(_ emergecnyTypeId: Int, bloodType type: String?, additionalInformation message: String) {
        let parameters: EmergencyReqModel = EmergencyReqModel(emergecnyTypeId: emergecnyTypeId, type: type, message: message)
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
//        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseEmergencyNotifications.rawValue
        let api: Apifeed = .emergencyRequest
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)
        
        client.post_EmergencyRequest(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupWaitAnimation(withAnimation: false, name: ConstHelper.lottie_emerequest)
            switch result {
            case .success(let result):
                guard  let result = result else { return }

                if result.status {
                    DispatchQueue.main.async {
                        strongSelf.vw_postResultAlphaBackView.isHidden = false
                        strongSelf.lbl_postedSuccess.text = result.message
                        
                        if let emergencyType = result.data?.emergencyType {
                            strongSelf.lbl_emergencyReason.text = "Reason: \(emergencyType)"
                        }
                        if let type = result.data?.type {
                            strongSelf.lbl_emergencyType.text = "Type: \(type)"
                        }
                        
                        strongSelf.setupEmergencyLogoAnimation(withAnimation: true, name: ConstHelper.lottie_health)
                    }
                } else {
                    strongSelf.lbl_message.text = result.message ?? ""
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.error_animation)
                    return
                }
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                return
            }
        }
        
    }
}

//MARK: - CollectionViewDelegate 
extension EmergencyRequestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.cv_emergencyTypesCollectionView:
            if let emergencyTypes = self.emergencyTypes {
                return emergencyTypes.count
            }
            return 0
        case self.cv_bloodGroupsCollectionView:
            if let bloodGroups = self.bloodGroups {
                return bloodGroups.count
            }
            return 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.cv_emergencyTypesCollectionView:
            let emergencyTypesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.emergencyTypesCollectionViewCell, for: indexPath) as! EmergencyTypesCollectionViewCell
            
            if let emergencyType = self.emergencyTypes?[indexPath.row] {
                let lottie = self.booldTypesLottie[indexPath.row]
                emergencyTypesCollectionViewCell.setEmergencyTypeCell(emergencyType.image, title: emergencyType.emergencyType, lottie: lottie)
            }
            
            return emergencyTypesCollectionViewCell
        case self.cv_bloodGroupsCollectionView:
            let bloodGroupsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.bloodGroupsCollectionViewCell, for: indexPath) as! BloodGroupsCollectionViewCell
            
            if let bloodGroup = self.bloodGroups?[indexPath.row] {
                bloodGroupsCollectionViewCell.setBloodGroupsCell(bloodGroup.type)
            }
            
            return bloodGroupsCollectionViewCell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.cv_emergencyTypesCollectionView:
            return CGSize(width: 110, height: 140)
        case self.cv_bloodGroupsCollectionView:
            
            if let bloodGroup = self.bloodGroups?[indexPath.row] {
                let label = UILabel(frame: CGRect.zero)
                label.text = bloodGroup.type
                label.sizeToFit()
                return CGSize(width: label.frame.width + 20, height: 40)
            }
            return CGSize(width: 0, height: 0)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.cv_emergencyTypesCollectionView:
            if let emergencyType = self.emergencyTypes?[indexPath.row] {
                self.bloodGroups = emergencyType.types
                
                self.eTypeId = emergencyType.emergecnyTypeId
                self.eType = emergencyType.types?.first?.type
                
                self.cv_bloodGroupsCollectionView.reloadData()
                self.updateDefaultSelectionForEmergency()
            }
        case self.cv_bloodGroupsCollectionView:
            if let bloodGroup = self.bloodGroups?[indexPath.row] {
                self.eType = bloodGroup.type
            }
        default:
            break
        }
    }
    
    private func updateDefaultSelectionForEmergency() {
        let indexPath = IndexPath(item: 0, section: 0)
        self.cv_bloodGroupsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
}

//MARK: - UITextViewDelegate
extension EmergencyRequestViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == self.tv_requestDescTV {
            self.lbl_requestDescPlaceholder.isHidden = true
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.tv_requestDescTV {
            if self.tv_requestDescTV.text.isEmpty {
                self.lbl_requestDescPlaceholder.isHidden = false
            } else {
                self.lbl_requestDescPlaceholder.isHidden = true
            }
        }
    }
}
