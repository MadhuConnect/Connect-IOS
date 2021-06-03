//
//  FormFilllingViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

struct UploadImage {
    let image: UIImage
    let imageUrl: String
}


struct UploadProductImage {
    let image: UIImage
    let data: Data
    let imageUrl: String
    let imageName: String
    let imageId: Int?
    let originUrl: String?
}

class FormFilllingViewController: UIViewController {

    //Product chosen
    @IBOutlet weak var vw_view1BackView: UIView!
    @IBOutlet weak var lbl_prodNameHeading: UILabel!
    @IBOutlet weak var lbl_prodName: UILabel!
    @IBOutlet weak var vw_prodImgBackView: UIView!
    @IBOutlet weak var iv_prodImageView: UIImageView!
    @IBOutlet weak var vw_line1BackView: UIView!
    @IBOutlet weak var personTypeHeightContraint: NSLayoutConstraint!
    
    //Product Info
    @IBOutlet weak var vw_view2BackView: UIView!
    //Product Type
    @IBOutlet weak var vw_productOffererSeekerBackView: UIView!
    @IBOutlet weak var vw_productTypeBackView: UIView!
    @IBOutlet weak var lbl_personTypeHeading: UILabel!
    @IBOutlet weak var sg_personType: UISegmentedControl!
    @IBOutlet weak var lbl_prodTypeHeading: UILabel!
    @IBOutlet weak var sg_productType: UISegmentedControl!
    @IBOutlet weak var view2HeightContraint: NSLayoutConstraint!
    @IBOutlet weak var productTypeHeightContraint: NSLayoutConstraint!
    //Title
    @IBOutlet weak var vw_productTitleBackView: UIView!
    @IBOutlet weak var lbl_titleHeading: UILabel!
    @IBOutlet weak var vw_titleBackView: UIView!
    @IBOutlet weak var tf_titleTF: UITextField!
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
    
    //Note: Location
    @IBOutlet weak var lbl_locationNote: UILabel!
    
    @IBOutlet weak var lbl_editedPersonType: UILabel!
    @IBOutlet weak var lbl_editedProductType: UILabel!
    
    //Proceed btn
    @IBOutlet weak var btn_proceed: UIButton!
    
    // Lottie
    @IBOutlet weak var loadingAlphaBackView: UIView!
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    
    let animationView = AnimationView()
    
    var multipleImagePicker: MultipleImagePicker!
    
    private let client = APIClient()
    var selctedProduct: ProductModel?
//    var uploadedLocalImages: [UploadImage] = []
    var uploadedLocalImages: [UploadProductImage] = []
    var uploadedLocalImagePaths: [String] = []
    var subcriptionResModel: SubcriptionResModel?
    var prices: [Prices]?// = []
    var uploadedImageNames: [String] = []
    var selPersonType: String?
    var selProductType: String?
    var selectedPrivacy: String?
    var selectedRange: String?
    let rupee = "\u{20B9}"
    var editQRInfo: QrCodeData?
    var isFromEditQRInfo: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        self.multipleImagePicker = MultipleImagePicker(presentationController: self, delegate: self)
        
        self.tv_descTV.delegate = self
                
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadingBackView.backgroundColor = .white
        self.setupAnimation(withAnimation: false, name: ConstHelper.lottie_loader)
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emergencyReqAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
        if let emergencyRequestVC = storyboard.instantiateViewController(withIdentifier: "EmergencyRequestViewController") as? EmergencyRequestViewController {
            emergencyRequestVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(emergencyRequestVC, animated: true)
        }
    }
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        self.multipleImagePicker.present(from: sender, viewController: self)
    }
    
    @IBAction func formSubmitAction(_ sender: UIButton) {
        if isFromEditQRInfo {
            self.updateFormFillsBeforeSendingToApi()
        } else {
            self.checkFormFillsBeforeSendingToApi()
        }
        
    }
    
    private func checkFormFillsBeforeSendingToApi() {
        guard
            let selProductId = self.selctedProduct?.productId,
            let selPrivacyStatus = self.selectedPrivacy,
            let selConnectRange = self.selectedRange
            else {
            return
        }

        let title = self.tf_titleTF.text ?? ""
        if title.count == 0 {
            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Please enter product title", actionTitle: "Ok")
            return
        }
        
        let description = self.tv_descTV.text ?? ""
        if description.count == 0 {
            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Please enter product description", actionTitle: "Ok")
            return
        }
        
        self.selPersonType = (self.sg_personType.selectedSegmentIndex == 0) ? "OFFEROR" : "SEEKER"
        
        if ConstHelper.productCategory.lowercased().elementsEqual("Quick needs".lowercased()) {
            self.selProductType = (self.sg_productType.selectedSegmentIndex == 0) ? "New" : "Used"
        } else {
            self.selProductType = ""
        }

        let minAmountStr = self.tf_minimumTF.text ?? "0"
        let maxAmountStr = self.tf_maximumTF.text ?? "0"
        
        let minAmount = Int(minAmountStr) ?? 0
        let maxAmount = Int(maxAmountStr) ?? 0
        
//        if maxAmount <= 0 {
//            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Please enter price range", actionTitle: "Ok")
//            return
//        }
        
        self.lbl_message.text = "Generating Order..."
        self.setupAnimation(withAnimation: true, name: ConstHelper.lottie_generate)
        self.uploadProductImagesWith(selProductId, personType: self.selPersonType ?? "", productType: self.selProductType ?? "", title: title, description: description, minAmount: minAmount, maxAmount: maxAmount, privacyStatus: selPrivacyStatus, connectRange: selConnectRange, productImages: self.uploadedLocalImages)
    }
    
    private func updateFormFillsBeforeSendingToApi() {
        guard
            let editedQrId = self.editQRInfo?.qrId,
            let editedPrivacyStatus = self.selectedPrivacy,
            let editedConnectRange = self.selectedRange
            else {
            return
        }

        let editedTitle = self.tf_titleTF.text ?? ""
        if editedTitle.count == 0 {
            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Please enter product title", actionTitle: "Ok")
            return
        }
        
        let editedDescription = self.tv_descTV.text ?? ""
        if editedDescription.count == 0 {
            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Please enter product description", actionTitle: "Ok")
            return
        }

        let minAmountStr = self.tf_minimumTF.text ?? "0"
        let maxAmountStr = self.tf_maximumTF.text ?? "0"
        
        let minAmount = Int(minAmountStr) ?? 0
        let maxAmount = Int(maxAmountStr) ?? 0
        
//        if maxAmount <= 0 {
//            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Please enter price range", actionTitle: "Ok")
//            return
//        }
        
        self.lbl_message.text = "Generating Order..."
        self.setupAnimation(withAnimation: true, name: ConstHelper.lottie_generate)
        self.uploadModifiedProductImagesWith(editedQrId, title: editedTitle, description: editedDescription, minAmount: minAmount, maxAmount: maxAmount, privacyStatus: editedPrivacyStatus, connectRange: editedConnectRange, productImages: self.uploadedLocalImages)

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
            loadingAlphaBackView.isHidden = false
        }
        else {
            animationView.stop()
            loadingAlphaBackView.isHidden = true
        }

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
        
        self.lbl_editedPersonType.font = ConstHelper.h5Bold
        self.lbl_editedPersonType.textColor = ConstHelper.black
        
        //Prduct type
        self.lbl_prodTypeHeading.font = ConstHelper.h5Bold
        self.lbl_prodTypeHeading.textColor = ConstHelper.gray
        
        self.lbl_editedProductType.font = ConstHelper.h5Bold
        self.lbl_editedProductType.textColor = ConstHelper.black
        
        //Title
        self.lbl_titleHeading.font = ConstHelper.h5Bold
        self.lbl_titleHeading.textColor = ConstHelper.gray
        self.vw_titleBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        
        //Prduct description
        self.lbl_descHeading.font = ConstHelper.h5Bold
        self.lbl_descHeading.textColor = ConstHelper.gray
        self.lbl_descPlaceholder.font = ConstHelper.h5Normal
        self.lbl_descPlaceholder.textColor = ConstHelper.lightGray
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
        self.tf_minimumTF.text = "0"
        self.tf_maximumTF.text = "0"
        
        //Connect Partner
        self.lbl_connectPartnerHeading.font = ConstHelper.h5Bold
        self.lbl_connectPartnerHeading.textColor = ConstHelper.gray
        
        //Notify Partner
        self.lbl_notifyPartnerHeading.font = ConstHelper.h5Bold
        self.lbl_notifyPartnerHeading.textColor = ConstHelper.gray
        
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
        
        self.showSelectedProductOnUI()
        
        self.sg_personType.addTarget(self, action: #selector(personTypeChanged(_:)), for: .valueChanged)
        self.sg_productType.addTarget(self, action: #selector(productTypeChanged(_:)), for: .valueChanged)
        self.sg_connectPartner.addTarget(self, action: #selector(connectPartnerTypeChanged(_:)), for: .valueChanged)
        self.sg_notifyPartner.addTarget(self, action: #selector(notifyNearByTypeChanged(_:)), for: .valueChanged)
        
        self.tf_titleTF.attributedPlaceholder = NSAttributedString(string: "Title of the product", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.lightGray])
        self.tf_minimumTF.attributedPlaceholder = NSAttributedString(string: "Minimum Price", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.lightGray])
        self.tf_maximumTF.attributedPlaceholder = NSAttributedString(string: "Maximum Price", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.lightGray])
        
        self.lbl_message.font = ConstHelper.h6Normal
        self.lbl_message.textColor = ConstHelper.gray
        
        self.loadingAlphaBackView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        self.loadingBackView.setBorderForView(width: 0, color: ConstHelper.white, radius: 10)
        
        self.lbl_prodNameHeading.halfTextColorChange(fullText: "*Product chosen", changeText: "*")
        self.lbl_personTypeHeading.halfTextColorChange(fullText: "*I am", changeText: "*")
        self.lbl_prodTypeHeading.halfTextColorChange(fullText: "*Product is", changeText: "*")
        self.lbl_titleHeading.halfTextColorChange(fullText: "*Title", changeText: "*")
        self.lbl_descHeading.halfTextColorChange(fullText: "*Description", changeText: "*")
        self.lbl_connectPartnerHeading.halfTextColorChange(fullText: "*Connect partner", changeText: "*")
        self.lbl_notifyPartnerHeading.halfTextColorChange(fullText: "*Notify when the seeker is nearby", changeText: "*")
        
        self.tv_descTV.backgroundColor = .white
        self.tv_descTV.textColor = ConstHelper.black
        
        self.tf_titleTF.textColor = ConstHelper.black
        self.tf_minimumTF.textColor = ConstHelper.black
        self.tf_maximumTF.textColor = ConstHelper.black
        
        self.cv_imageCollectionView.backgroundColor = .white
    }
    
    private func showSelectedProductOnUI() {
        if isFromEditQRInfo {
            if let product = self.editQRInfo {
                self.lbl_prodName.text = product.productName
                
                if let imgUrl = URL(string: product.productImage ?? "") {
                    self.downloadImage(url: imgUrl)
                }
                
                if let personType = self.editQRInfo?.personType {
                    self.lbl_editedPersonType.text = personType.uppercased()
                }
                
                self.personTypeHeightContraint.constant = 25
                self.sg_personType.isHidden = true
                
                if let productType = self.editQRInfo?.productType {
                    self.lbl_editedProductType.text = productType
                }
                
                self.productTypeHeightContraint.constant = 25
                self.sg_productType.isHidden = true
                
                if let title = self.editQRInfo?.title {
                    self.tf_titleTF.text = title
                }
                
                if let desc = self.editQRInfo?.description {
                    self.tv_descTV.text = desc
                    self.lbl_descPlaceholder.isHidden = true
                }
                
                self.tf_minimumTF.text = "\(self.editQRInfo?.minAmount ?? 0)"
                self.tf_maximumTF.text = "\(self.editQRInfo?.maxAmount ?? 0)"

                let genderStatus = self.editQRInfo?.privacyStatus ?? ""
                if genderStatus.lowercased().elementsEqual("Men".lowercased()) {
                    sg_connectPartner.selectedSegmentIndex = 0
                    self.selectedPrivacy = "Men"
                } else if genderStatus.lowercased().elementsEqual("Women".lowercased()) {
                    sg_connectPartner.selectedSegmentIndex = 1
                    self.selectedPrivacy = "Women"
                } else if genderStatus.lowercased().elementsEqual("Trans".lowercased()) {
                    sg_connectPartner.selectedSegmentIndex = 2
                    self.selectedPrivacy = "Trans"
                } else {
                    sg_connectPartner.selectedSegmentIndex = 3
                    self.selectedPrivacy = "Any"
                }
                
                let connectRange = self.editQRInfo?.connectRange ?? ""
                if connectRange.lowercased().elementsEqual("10km".lowercased()) || connectRange.lowercased().elementsEqual("10 km".lowercased()) {
                    sg_notifyPartner.selectedSegmentIndex = 0
                    self.selectedRange = "10km"
                } else if connectRange.lowercased().elementsEqual("25 km".lowercased()) || connectRange.lowercased().elementsEqual("25 km".lowercased()) {
                    sg_notifyPartner.selectedSegmentIndex = 1
                    self.selectedRange = "25km"
                } else if connectRange.lowercased().elementsEqual("50km".lowercased()) || connectRange.lowercased().elementsEqual("50 km".lowercased()) {
                    sg_notifyPartner.selectedSegmentIndex = 2
                    self.selectedRange = "50km"
                } else {
                    sg_notifyPartner.selectedSegmentIndex = 3
                    self.selectedRange = "100km"
                }
            }
            
            if let editedImages = editQRInfo?.images {
                editedImages.forEach { (image) in
                    let imgUrl = image.productImage ?? ""
                    guard let url = URL(string: imgUrl) else { return }
                    let imgName = url.lastPathComponent
                    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                    let localPath = documentDirectory?.appending("/" + imgName)
                    
                    
                    if let data = try? Data(contentsOf: url) {
                        if let oldImage = UIImage(data: data) {
                            let imgData = oldImage.jpegData(compressionQuality: 1)! as NSData
                            imgData.write(toFile: localPath!, atomically: true)
                            let photoUrl = URL.init(fileURLWithPath: localPath!)
                            let imgPath = photoUrl.path
                            let uploadProductImage = UploadProductImage(image: oldImage, data: imgData as Data, imageUrl: imgPath, imageName: imgName, imageId: image.imageId, originUrl: image.productImage)
                            self.uploadedLocalImages.append(uploadProductImage)
                        }
                    }
                }
                
                self.cv_imageCollectionView.reloadData()
            }

            self.btn_proceed.setTitle("UPDATE", for: .normal)
        } else {
            if let product = self.selctedProduct {
                self.lbl_prodName.text = product.name
                
                if let imgUrl = URL(string: product.image ?? "") {
                    self.downloadImage(url: imgUrl)
                }
                
                if ConstHelper.productCategory.lowercased().elementsEqual("Quick needs".lowercased()) {
                    self.vw_productTypeBackView.isHidden = false
                    self.productTypeHeightContraint.constant = 60
                    self.view2HeightContraint.constant = 350
                } else {
                    self.vw_productTypeBackView.isHidden = true
                    self.productTypeHeightContraint.constant = 0
                    self.view2HeightContraint.constant = 278
                }
                
                sg_notifyPartner.selectedSegmentIndex = 3
                self.selectedRange = "100km"
                
                sg_connectPartner.selectedSegmentIndex = 3
                self.selectedPrivacy = "Any"
                
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
            self.selectedPrivacy = "Men"
        case 1:
            self.selectedPrivacy = "Women"
        case 2:
            self.selectedPrivacy = "Trans"
        case 3:
            self.selectedPrivacy = "Any"
        default:
            break
        }
    }
    
    @objc
    func notifyNearByTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectedRange = "10km"
        case 1:
            self.selectedRange = "25km"
        case 2:
            self.selectedRange = "50km"
        case 3:
            self.selectedRange = "100km"
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
        
        photoCell.btn_delete.tag = indexPath.row
        photoCell.btn_delete.addTarget(self, action: #selector(deleteUploadImageAction(_:)), for: .touchUpInside)
        
        return photoCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 80)
    }
    
    @objc private func deleteUploadImageAction(_ sender: UIButton) {
        let deleteQr = self.uploadedLocalImages[sender.tag]
        if let originUrl = deleteQr.originUrl, !originUrl.isEmpty {
            self.uploadedLocalImages.remove(at: sender.tag)
            self.lbl_message.text = "Deleting photo..."
            self.setupAnimation(withAnimation: true, name: ConstHelper.lottie_loader)
            self.post_RemoveSelectedImage(withImageId: deleteQr.imageId, image: deleteQr.originUrl)
        } else {
            self.uploadedLocalImages.remove(at: sender.tag)
            self.cv_imageCollectionView.reloadData()
        }
        
    }
    

}

extension FormFilllingViewController: MultipleImagePickerDelegate {
    func didSelectMultiple(_ imageAsset: [ImageAsset]?) {
        if let assets = imageAsset {
            DispatchQueue.main.async {
                assets.forEach { [weak self] (asset) in
                    guard  let image = asset.image, let imgData = asset.image?.jpegData(compressionQuality: 0.6), let imgUrl = URL(string: asset.name) else { return }
                    let uploadProductImage = UploadProductImage(image: image, data: imgData, imageUrl: asset.name, imageName: imgUrl.lastPathComponent, imageId: nil, originUrl: nil)
                    self?.uploadedLocalImages.append(uploadProductImage)
                }
                self.cv_imageCollectionView.reloadData()
            }
        }
    }
    
}

// MARK: Multipart Service call ---
extension FormFilllingViewController {
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    /**
     Generate QR Code
     */
    private func uploadProductImagesWith(_
        productId: Int,
        personType: String,
        productType: String,
        title: String,
        description: String,
        minAmount: Int,
        maxAmount: Int,
        privacyStatus: String,
        connectRange: String,
        productImages: [UploadProductImage]) {
        
        let parameter = [
            "productId": "\(productId)",
            "personType": personType,
            "productType": productType,
            "title": title,
            "description": description,
            "minAmount": "\(minAmount)",
            "maxAmount": "\(maxAmount)",
            "privacyStatus": privacyStatus,
            "connectRange": connectRange
        ]
        
        self.uploadMultipartDataForProfileWith(productImages, parameters: parameter, endPoint: Apifeed.generateQrcode.rawValue)
    }

    /**
     Update QR Code
     */
    private func uploadModifiedProductImagesWith(_
        qrId: Int,
        title: String,
        description: String,
        minAmount: Int,
        maxAmount: Int,
        privacyStatus: String,
        connectRange: String,
        productImages: [UploadProductImage]) {
        
        let parameter = [
            "qrId": "\(qrId)",
            "title": title,
            "description": description,
            "minAmount": "\(minAmount)",
            "maxAmount": "\(maxAmount)",
            "privacyStatus": privacyStatus,
            "connectRange": connectRange
        ]
                
        self.uploadMultipartDataForProfileWith(productImages, parameters: parameter, endPoint: Apifeed.updateQRcode.rawValue)
    }
    
    private func uploadMultipartDataForProfileWith(_ productImages: [UploadProductImage], parameters: [String: String], endPoint: String) {
        let url = NSURL(string: DynamicBaseUrl.baseUrl.rawValue + endPoint)
        
        let boundary = generateBoundaryString()
        
        //Request
        let request = NSMutableURLRequest(url:url! as URL);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ConstHelper.DYNAMIC_TOKEN, forHTTPHeaderField:"Authorization" )
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = self.createData(withBoundary: boundary, parameters: parameters, productImages: productImages)
        
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
                let response = try JSONDecoder().decode(FormResModel.self, from: data)
                DispatchQueue.main.async {
                    strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.lottie_generate)
                }
                
                if response.status {
                    DispatchQueue.main.async {
                        if strongSelf.isFromEditQRInfo {
                            Switcher.updateRootViewController(setTabIndex: 2)
                        } else {
                            strongSelf.moveToQRGenerateViewController(withQRInfo: response)
                        }
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: (response.message ?? ""), actionTitle: "Ok")
                    }
                    
                    return
                }
            } catch {
                DispatchQueue.main.async {
                    strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
                }
                
            }
            
            dispatchGroup.leave()
        }
        
        task.resume()
        
        
    }

    private func createData(withBoundary boundary: String, parameters: [String: String], productImages: [UploadProductImage]) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        let mimetype = "image/jpg"
        let key = "images[]"
        
        for asset in productImages {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(asset.imageName)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(asset.data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        
        return body
    }
    
    func moveToQRGenerateViewController(withQRInfo qrInfo: FormResModel) {
        if let qrVC = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
            if let qr = qrInfo.data {
                let info = QrCodeData(qrId: qr.qrId, qrCode: qr.qrCode, personType: qr.personType, productName: qr.productName, productImage: qr.productImage, productType: qr.productType, title: qr.title, description: qr.description, minAmount: qr.minAmount, maxAmount: qr.maxAmount, privacyStatus: qr.privacyStatus, connectRange: qr.connectRange, activeCount: qr.activeCount, lockCount: qr.lockCount, paidCount: qr.paidCount, chatCount: qr.chatCount, qrStatus: qr.qrStatus, qrGeneratedDate: qr.qrGeneratedDate, turnOn: qr.turnOn, paidConnections: nil, images: qr.images, b2bRequest: qr.b2bRequest)
                qrVC.qrInfo = info
            }
        self.navigationController?.pushViewController(qrVC, animated: true)
      }
    }
    
    /**
     Removed selected images from server
     */
    private func post_RemoveSelectedImage(withImageId id: Int?, image: String?) {
        guard let imageId = id, let originUrl = image else { return }
        
        let parameters = RemoveImageReqModel(imageId: imageId, image: originUrl, status: "Qrcode")

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .removeImage

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        client.post_removeImage(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.lottie_loader)
            switch result {
            case .success(let response):
                guard let response = response else { return }
                if response.status {
                    DispatchQueue.main.async {
                        strongSelf.cv_imageCollectionView.reloadData()

                    }
                } else {
//                   strongSelf.setupAnimation(withAnimation: true)
                }
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
            }
        }
    }
}


//MARK: - Custom UISegmentedControl
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

//MARK: - Download Image
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

//MARK: - UITextViewDelegate
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

