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
    
    private let client = APIClient()
    let animationView = AnimationView()
    
    var emergencyTypes: [EmergencyModel]?
    var bloodGroups: [EmergencyTypes]?
    
    var eTypeId: Int?
    var eType: String?
    
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
        print("Post emergemcy request")
        guard let additionalInfo = self.tv_requestDescTV.text, !additionalInfo.isEmpty else {
            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Please enter information", actionTitle: "Ok")
            return
        }
        
        self.postEmergencyRequest(eTypeId ?? 0, bloodType: eType, additionalInformation: additionalInfo)
        
    }
    
    @IBAction func homeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.tv_requestDescTV.text = ""
        self.vw_postResultAlphaBackView.isHidden = true
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
        
        self.setupAnimation(withAnimation: true, name: ConstHelper.heartbeat_animation)
    }
    
    private func updateUIWhenViewWillAppear() {
        self.getEmergencyRequestInfo()
        self.vw_postResultAlphaBackView.isHidden = true
    }
    
    private func setupAnimation(withAnimation status: Bool, name: String) {
        animationView.animation = Animation.named(name)
        animationView.frame = vw_emergencyLogoView.bounds
        animationView.backgroundColor = ConstHelper.white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        vw_emergencyLogoView.addSubview(animationView)
    }
}

//MARK: - API Call
extension EmergencyRequestViewController {
    private func getEmergencyRequestInfo() {
        //API
        let api: Apifeed = .emergencyTypes
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)
        
        client.get_EmergencyTypes(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
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
                    DispatchQueue.main.async {
                        strongSelf.cv_emergencyTypesCollectionView.reloadData()
                        strongSelf.cv_bloodGroupsCollectionView.reloadData()
                        let indexPath = IndexPath(item: 0, section: 0)
                        strongSelf.cv_emergencyTypesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                        strongSelf.cv_bloodGroupsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                    }
                } else {
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(result.message ?? "")", actionTitle: "Ok")
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
        print(parameters)
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        let api: Apifeed = .emergencyRequest
        
        //Req headers & body
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)
        
        client.post_EmergencyRequest(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
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
                        
                    }
                } else {
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(result.message ?? "")", actionTitle: "Ok")
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
                emergencyTypesCollectionViewCell.setEmergencyTypeCell(emergencyType.image, title: emergencyType.emergencyType)
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
            return CGSize(width: 60, height: 40)
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
