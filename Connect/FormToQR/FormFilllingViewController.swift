//
//  FormFilllingViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

struct UploadImage {
    let image: UIImage
}

class FormFilllingViewController: UIViewController {

    //Product chosen
    @IBOutlet weak var vw_view1BackView: UIView!
    @IBOutlet weak var lbl_prodNameHeading: UILabel!
    @IBOutlet weak var lbl_prodName: UILabel!
    @IBOutlet weak var vw_prodImgBackView: UIView!
    @IBOutlet weak var iv_prodImageView: UIImageView!
    @IBOutlet weak var vw_line1BackView: UIView!
    
    //Product Info
    @IBOutlet weak var vw_view2BackView: UIView!
    //Product Type
    @IBOutlet weak var lbl_personTypeHeading: UILabel!
    @IBOutlet weak var sg_personType: UISegmentedControl!
    @IBOutlet weak var lbl_prodTypeHeading: UILabel!
    @IBOutlet weak var sg_productType: UISegmentedControl!
    //Description
    @IBOutlet weak var lbl_descHeading: UILabel!
    @IBOutlet weak var vw_descBackView: UIView!
    @IBOutlet weak var lbl_descPlaceholder: UILabel!
    @IBOutlet weak var tv_descTV: UITextView!
    
    //Upload image
    @IBOutlet weak var cv_imageCollectionView: UICollectionView!
    @IBOutlet weak var lbl_uploadImgHeading: UILabel!
    @IBOutlet weak var vw_view3BackView: UIView!
    @IBOutlet weak var vw_cameraBackView: UIView!
    @IBOutlet weak var vw_cameraIconBackView: UIView!
    @IBOutlet weak var vw_imageUploadIndicatorBackView: UIView!
    @IBOutlet weak var iv_cameraImageView: UIImageView!
    
    //Price range
    @IBOutlet weak var vw_view4BackView: UIView!
    @IBOutlet weak var lbl_priceRangeHeading: UILabel!
    @IBOutlet weak var lbl_priceToHeading: UILabel!
    @IBOutlet weak var vw_minBackView: UIView!
    @IBOutlet weak var vw_maxBackView: UIView!
    @IBOutlet weak var tf_minimumTF: UITextField!
    @IBOutlet weak var tf_maximumTF: UITextField!
    
    //Connect Partner
    @IBOutlet weak var vw_view5BackView: UIView!
    @IBOutlet weak var lbl_connectPartnerHeading: UILabel!
    @IBOutlet weak var sg_connectPartner: UISegmentedControl!
  
    //Notify Partner
    @IBOutlet weak var vw_view6BackView: UIView!
    @IBOutlet weak var lbl_notifyPartnerHeading: UILabel!
    @IBOutlet weak var sg_notifyPartner: UISegmentedControl!
    
    //Subscription Partner
    @IBOutlet weak var vw_view7BackView: UIView!
    @IBOutlet weak var lbl_subscriptionHeading: UILabel!
    @IBOutlet weak var sg_subscriptionPartner: UISegmentedControl!
    
    //Note: Location
    @IBOutlet weak var lbl_locationNote: UILabel!
    
    //Proceed btn
    @IBOutlet weak var btn_proceed: UIButton!
    
    var imagePicker: ImagePicker!
    
    private let client = APIClient()
    var selctedProduct: ProductModel?
    var uploadedLocalImages: [UploadImage] = []
    var subcriptionResModel: SubcriptionResModel?
    var prices: [Prices]?// = []
    var uploadedImageNames: [String] = []
    var selPersonType: String? = "OFFEROR"
    var selProductType: String? = "New"
    var selectedPrivacy: String? = "All"
    var selectedRange: String? = "2km"
    var selectedSalesTypeId: Int? = 0
    var selectedPriceId: Int? = 0
    let rupee = "\u{20B9}"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.tv_descTV.delegate = self
        
        print(selctedProduct as Any)
        
        guard let userId = UserDefaults.standard.value(forKey: "LoggedUserId") as? Int else {
            return
        }
        #warning("Uncomment api")
//        self.getAllSubscriptionPlans(withUserId: userId)
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func qrAction(_ sender: UIButton) {
        if let qrVC = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
            self.navigationController?.pushViewController(qrVC, animated: true)
        }
    }
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func formSubmitAction(_ sender: UIButton) {
        self.checkFormFillsBeforeSendingToApi()
    }
    
    private func checkFormFillsBeforeSendingToApi() {
        guard
            let userId = UserDefaults.standard.value(forKey: "LoggedUserId") as? Int,
            let selProductId = self.selctedProduct?.productId,
            let minAmount = Int(self.tf_minimumTF.text ?? "0"),
            let maxAmount = Int(self.tf_maximumTF.text ?? "0"),
            let selPrivacyStatus = self.selectedPrivacy,
            let selConnectRange = self.selectedRange,
            let salesTypeId = self.selectedSalesTypeId,
            let selPriceId = self.selectedPriceId
            else {
            return
        }
        let description = self.tv_descTV.text ?? ""
        let selPersonType = (self.sg_personType.selectedSegmentIndex == 0) ? "OFFEROR" : "SEEKER"
        let selProductType = (self.sg_productType.selectedSegmentIndex == 0) ? "New" : "Used"
        let uploadImages = self.uploadedImageNames.joined(separator: ",")

        self.postFormFillingData(userId, productId: selProductId, personType: selPersonType, productType: selProductType, uploadImages: uploadImages, description: description, minAmount: minAmount, maxAmount: maxAmount, privacyStatus: selPrivacyStatus, connectRange: selConnectRange, salesTypeId: 1, priceId: selPriceId)
    }

}

extension FormFilllingViewController {
    private func updateDefaultUI() {
        //Hide keyboard tapped anywhere
        self.hideKeyboardWhenTappedAround()
        //Product chosen
        self.vw_prodImgBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        self.vw_line1BackView.backgroundColor = ConstHelper.gray
        
        self.lbl_prodNameHeading.font = ConstHelper.h5Bold
        self.lbl_prodNameHeading.textColor = ConstHelper.gray
        
        self.lbl_prodName.font = ConstHelper.titleNormal
        self.lbl_prodName.textColor = ConstHelper.black
        
        //Person type
        self.lbl_personTypeHeading.font = ConstHelper.h5Bold
        self.lbl_personTypeHeading.textColor = ConstHelper.gray
        
        //Prduct type
        self.lbl_prodTypeHeading.font = ConstHelper.h5Bold
        self.lbl_prodTypeHeading.textColor = ConstHelper.gray
        
        //Prduct description
        self.lbl_descHeading.font = ConstHelper.h5Bold
        self.lbl_descHeading.textColor = ConstHelper.gray
        self.lbl_descPlaceholder.font = ConstHelper.h5Normal
        self.lbl_descPlaceholder.textColor = ConstHelper.gray
        self.vw_descBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        
        //Prduct upload image
        self.lbl_uploadImgHeading.font = ConstHelper.h5Bold
        self.lbl_uploadImgHeading.textColor = ConstHelper.gray
        self.vw_cameraIconBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        
        //Price range
        self.lbl_priceRangeHeading.font = ConstHelper.h5Bold
        self.lbl_priceRangeHeading.textColor = ConstHelper.gray
        self.lbl_priceToHeading.font = ConstHelper.h4Bold
        self.lbl_priceToHeading.textColor = ConstHelper.gray
        self.vw_minBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        self.vw_maxBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        
        //Connect Partner
        self.lbl_connectPartnerHeading.font = ConstHelper.h5Bold
        self.lbl_connectPartnerHeading.textColor = ConstHelper.gray
        
        //Notify Partner
        self.lbl_notifyPartnerHeading.font = ConstHelper.h5Bold
        self.lbl_notifyPartnerHeading.textColor = ConstHelper.gray
        
        //Subscription Partner
        self.lbl_subscriptionHeading.font = ConstHelper.h5Bold
        self.lbl_subscriptionHeading.textColor = ConstHelper.gray
        
        //Note: Location
        self.lbl_locationNote.font = ConstHelper.h5Normal
        self.lbl_locationNote.textColor = ConstHelper.red
        
        //Proceed button
        self.btn_proceed.backgroundColor = ConstHelper.cyan
        self.btn_proceed.setTitleColor(ConstHelper.white, for: .normal)
        self.btn_proceed.titleLabel?.font = ConstHelper.h3Bold
        
        sg_personType.backgroundColor = ConstHelper.lightGray
        sg_personType.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ConstHelper.white], for: .selected)
        
        sg_productType.backgroundColor = ConstHelper.lightGray
        sg_productType.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ConstHelper.white], for: .selected)

        sg_connectPartner.backgroundColor = ConstHelper.lightGray
        sg_connectPartner.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ConstHelper.white], for: .selected)
        
        sg_notifyPartner.backgroundColor = ConstHelper.lightGray
        sg_notifyPartner.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ConstHelper.white], for: .selected)
        
        sg_subscriptionPartner.backgroundColor = ConstHelper.lightGray
        sg_subscriptionPartner.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ConstHelper.white], for: .selected)
        
        self.showSelectedProductOnUI()
        
        self.sg_personType.addTarget(self, action: #selector(personTypeChanged(_:)), for: .valueChanged)
        self.sg_personType.addTarget(self, action: #selector(productTypeChanged(_:)), for: .valueChanged)
        self.sg_connectPartner.addTarget(self, action: #selector(connectPartnerTypeChanged(_:)), for: .valueChanged)
        self.sg_notifyPartner.addTarget(self, action: #selector(notifyNearByTypeChanged(_:)), for: .valueChanged)
        self.sg_subscriptionPartner.addTarget(self, action: #selector(subscriptionPlanTypeChanged(_:)), for: .valueChanged)
    }
    
    private func showSelectedProductOnUI() {
        if let product = self.selctedProduct {
            self.lbl_prodName.text = product.name
            
            if let imgUrl = URL(string: product.image) {
                self.downloadImage(url: imgUrl)
            }
        }
    }
    
    @objc
    func personTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selPersonType = "OFFEROR"
        case 1:
            self.selPersonType = "SEEKER"
        default:
            break
        }
    }
    
    @objc
    func productTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selProductType = "New"
        case 1:
            self.selProductType = "Used"
        default:
            break
        }
    }
    
    
    @objc
    func connectPartnerTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectedPrivacy = "All"
        case 1:
            self.selectedPrivacy = "Men"
        case 2:
            self.selectedPrivacy = "Women"
        case 3:
            self.selectedPrivacy = "T-Gender"
        default:
            break
        }
    }
    
    @objc
    func notifyNearByTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectedRange = "2km"
        case 1:
            self.selectedRange = "6km"
        case 2:
            self.selectedRange = "8km"
        default:
            break
        }
    }
    
    @objc
    func subscriptionPlanTypeChanged(_ sender: UISegmentedControl) {
        self.selectedSalesTypeId = self.subcriptionResModel?.data?.first?.salesTypeId
        switch sender.selectedSegmentIndex {
        case 0:
            if let pid = self.prices?[0].priceId {
                self.selectedPriceId = pid
            }
        case 1:
            if let pid = self.prices?[1].priceId {
                self.selectedPriceId = pid
            }
        case 2:
            if let pid = self.prices?[2].priceId {
                self.selectedPriceId = pid
            }
        default:
            break
        }
    }
    
}

extension FormFilllingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.uploadedLocalImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.qrImageUploadCellIdentifier, for: indexPath) as! ImageUploadCell

        let photo = self.uploadedLocalImages[indexPath.row]
        photoCell.setPhotoCellData(photo.image)
        
        return photoCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 80)
    }
    

}

extension FormFilllingViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, imagePath: String?) {
        guard let userId = UserDefaults.standard.value(forKey: "LoggedUserId") as? Int else {
            return
        }
        
        if let image = image {
            DispatchQueue.main.async {
                self.uploadProductImages(withUserId: "\(userId)", image: image, imagePath: (imagePath ?? ""))
            }
            
            let uploadImage = UploadImage(image: image)
            self.uploadedLocalImages.append(uploadImage)
        }
        
        if self.uploadedLocalImages.count > 0 {
//            self.addPhotosViewHeight.constant = 148
        } else {
//            self.addPhotosViewHeight.constant = 40
            self.uploadedLocalImages.removeAll()
        }
        
        self.cv_imageCollectionView.reloadData()
        
    }
    
}

//MARK: - API Call
extension FormFilllingViewController {
    //Get All Subscription Plans
    private func getAllSubscriptionPlans(withUserId userId: Int) {
        let parameters = ["userId": userId]
        print("Par: \(parameters)")

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        let api: Apifeed = .subscriptionCharges

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [], body: body, timeInterval: 120)

        client.post_getSubscriptionCharges(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else { return }
                
                if response.status {
                    strongSelf.subcriptionResModel = response
                    
                    let freeOfCost = strongSelf.subcriptionResModel?.FreeOfCost ?? false
                    if freeOfCost {
                        print("Hide subcription plan")
                        strongSelf.selectedSalesTypeId = 0
                        strongSelf.selectedPriceId = 0
                    } else {
                        if let prices = strongSelf.subcriptionResModel?.data?.first?.prices {
                            strongSelf.prices = prices
                            
                            DispatchQueue.main.async {
                                strongSelf.sg_subscriptionPartner.setTitle("\(strongSelf.rupee) \(prices[0].price) Valid for \(prices[0].days) Days", forSegmentAt: 0)
                                strongSelf.sg_subscriptionPartner.setTitle("\(strongSelf.rupee) \(prices[1].price) Valid for \(prices[1].days) Days", forSegmentAt: 1)
                                strongSelf.sg_subscriptionPartner.setTitle("\(strongSelf.rupee) \(prices[2].price) Valid for \(prices[2].days) Days", forSegmentAt: 2)
                                
                                strongSelf.sg_subscriptionPartner.layoutSubviews()
                            }

                        }
                        
                    }
                    
                } else {
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(response.message ?? "")", actionTitle: "Ok")
                    return
                }
                
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
            }
        }
    }
    
    //MARK: - Image upload (multipart/form-data)
    private func uploadProductImages(withUserId userId: String, image: UIImage?, imagePath: String) {
        let parameters = [
            [
                "key": "userId",
                "value": "\(userId)",
                "type": "text"
            ],
            [
                "key": "image",
                "src": "\(imagePath)",
                "type": "file"
            ],
            [
                "key": "status",
                "value": "Qrcode",
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
            let api: Apifeed = .uploadImage
            
            let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("multipart/form-data; boundary=\(boundary)")], body: postData, timeInterval: Double.infinity)
            
            client.post_uploadImage(from: endpoint) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let imageResModel):
                    guard let imageResModel = imageResModel else { return }
                    
                    if imageResModel.status {
                        strongSelf.uploadedImageNames.append(imageResModel.name ?? "")
                    } else {
                         strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(imageResModel.message ?? "")", actionTitle: "Ok")
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
    
    //Psot Form Filling Data
    private func postFormFillingData(_ userId: Int, productId: Int, personType: String, productType: String, uploadImages: String, description: String, minAmount: Int, maxAmount: Int, privacyStatus: String, connectRange: String, salesTypeId: Int, priceId: Int) {
        let parameters: FormReqModel = FormReqModel(userId: userId, productId: productId, personType: personType, productType: productType, uploadImages: uploadImages, description: description, minAmount: minAmount, maxAmount: maxAmount, privacyStatus: privacyStatus, connectRange: connectRange, salesTypeId: salesTypeId, priceId: priceId)
        
        print("Par: \(parameters)")

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        let api: Apifeed = .generateQrcode

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [], body: body, timeInterval: 120)

        client.post_getFormFillingData(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else { return }

                if response.status {
                    print(response)
//                    strongSelf.moveToQRGenerateViewController(withQRInfo: response)
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

@IBDesignable class VBSegmentedControl: UISegmentedControl {

    @IBInspectable var height: CGFloat = 29 {
        didSet {
            let centerSave = center
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: height)
            center = centerSave
        }
    }

    @IBInspectable var multilinesMode: Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()
        for segment in self.subviews {
            for subview in segment.subviews {
                if let segmentLabel = subview as? UILabel {
                    segmentLabel.frame = CGRect(x: 0, y: 0, width: segmentLabel.frame.size.width, height: segmentLabel.frame.size.height * 1.6)
                    if (multilinesMode == true)
                    {
                        segmentLabel.numberOfLines = 0
                    }
                    else
                    {
                        segmentLabel.numberOfLines = 1
                    }
                }
            }
        }
    }

}

extension FormFilllingViewController {
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: iv_prodImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 10)
        self.iv_prodImageView.kf.indicatorType = .activity
        iv_prodImageView.kf.setImage(
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

extension FormFilllingViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.lbl_descPlaceholder.isHidden = true
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.tv_descTV {
            if self.tv_descTV.text.isEmpty {
                self.lbl_descPlaceholder.isHidden = false
            } else {
                self.lbl_descPlaceholder.isHidden = true
            }
        }
    }
}
