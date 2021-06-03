//
//  HomeViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 06/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie
import Kingfisher
import youtube_ios_player_helper

class HomeViewController: UIViewController {
    
    @IBOutlet weak var allProductsBackView: UIView!
    
    // Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    //Navbar
    @IBOutlet weak var iv_accountVerified: UIImageView!
    @IBOutlet weak var btn_profile: UIButton!
    @IBOutlet weak var lbl_userName: UILabel!
    
    // Emergency
    @IBOutlet weak var vw_emergencyBackView: UIView!
    @IBOutlet weak var vw_emergencyTitleBackView: UIView!
    @IBOutlet weak var lbl_emergencyTitle: UILabel!
    @IBOutlet weak var vw_emergencyListBackView: UIView!
    @IBOutlet weak var vw_emergencyImgBackView: UIView!
    @IBOutlet weak var lbl_emergencyListTitle: UILabel!
    
    @IBOutlet weak var vw_nearbyListBackView: UIView!
    @IBOutlet weak var vw_nearbyImgBackView: UIView!
    @IBOutlet weak var lbl_nearbyListTitle: UILabel!
    
    @IBOutlet weak var vw_lockedListBackView: UIView!
    @IBOutlet weak var vw_lockedImgBackView: UIView!
    @IBOutlet weak var lbl_lockedListTitle: UILabel!
    
    @IBOutlet weak var btn_emergency: UIButton!
    @IBOutlet weak var btn_nearby: UIButton!
    @IBOutlet weak var btn_locked: UIButton!
    
    @IBOutlet weak var vw_emergencyLottieView: UIView!
    @IBOutlet weak var vw_nearbyLottieView: UIView!
    @IBOutlet weak var vw_lockedLottieView: UIView!
    
    //Subscription
    @IBOutlet weak var cv_subsciptionCollectionView: UICollectionView!
    @IBOutlet weak var vw_subscriptionBackView: UIView!
    
    // Main Category
    @IBOutlet weak var vw_mainBackView: UIView!
    @IBOutlet weak var vw_mainTitleBackView: UIView!
    @IBOutlet weak var lbl_mainCategoryName: UILabel!
    @IBOutlet weak var vw_mainCategoryBackView: UIView!
    @IBOutlet weak var cv_mainCategoryCollectionView: UICollectionView!

    // Sub Category
    @IBOutlet weak var vw_subBackView: UIView!
    @IBOutlet weak var vw_subTitleBackView: UIView!
    @IBOutlet weak var lbl_subCategoryName: UILabel!
    @IBOutlet weak var vw_subCategoryBackView: UIView!
    @IBOutlet weak var cv_subCategoryCollectionView: UICollectionView!

    // Mini Category
    @IBOutlet weak var vw_miniBackView: UIView!
    @IBOutlet weak var vw_miniTitleBackView: UIView!
    @IBOutlet weak var lbl_miniCategoryName: UILabel!
    @IBOutlet weak var vw_miniCategoryBackView: UIView!
    @IBOutlet weak var cv_miniCategoryCollectionView: UICollectionView!
    
    // Product
    @IBOutlet weak var vw_prodBackView: UIView!
    @IBOutlet weak var vw_prodTitleBackView: UIView!
    @IBOutlet weak var lbl_prodCategoryName: UILabel!
    @IBOutlet weak var vw_prodCategoryBackView: UIView!
    @IBOutlet weak var cv_prodCategoryCollectionView: UICollectionView!
    
    //Notification Count
    @IBOutlet weak var vw_notificationBadgeView: UIView!
    @IBOutlet weak var lbl_notificationBadge: UILabel!
    
    @IBOutlet weak var vw_notificationNearByBadgeView: UIView!
    @IBOutlet weak var lbl_notificationNearByBadge: UILabel!
    
    @IBOutlet weak var btn_viewAll: UIButton!
        
    var locationManager: MyLocationManager?
    weak var timer: Timer?
    
    let animationView = AnimationView()
    let emergencyAnimationView = AnimationView()
    let nearbyAnimationView = AnimationView()
    let lockedAnimationView = AnimationView()
    
    private let client = APIClient()
    
    var categoryModel: CategoryModel?
    var mainCategoryModel: [MainCategoryModel]?
    var subCategoryModel: [SubCategoryModel]?
    var miniCategoryModel: [MiniCategoryModel]?
    var productModel: [ProductModel]?
    var banners: [Banners]?
    var b2bApprovedList: B2bApprovedListResModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        
        locationManager = MyLocationManager()
        locationManager?.delegate = self
        
        self.cv_subsciptionCollectionView.delegate = self
        self.cv_subsciptionCollectionView.dataSource = self
        
        self.cv_mainCategoryCollectionView.delegate = self
        self.cv_mainCategoryCollectionView.dataSource = self
        
        self.cv_subCategoryCollectionView.delegate = self
        self.cv_subCategoryCollectionView.dataSource = self

        self.cv_miniCategoryCollectionView.delegate = self
        self.cv_miniCategoryCollectionView.dataSource = self
        
        self.cv_prodCategoryCollectionView.delegate = self
        self.cv_prodCategoryCollectionView.dataSource = self
        
        vw_mainBackView.isHidden = true
        vw_subBackView.isHidden = true
        vw_miniBackView.isHidden = true
        vw_prodBackView.isHidden = true
        
        self.updateDefaultUI()
        
        self.emergencyLottieAnimation(withAnimation: true)
        self.nearbyLottieAnimation(withAnimation: true)
        self.lockedLottieAnimation(withAnimation: true)
        
        timer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(self.getUpdateMyLocationForEvery2Minutes), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.vw_notificationBadgeView.isHidden = true
        self.vw_notificationNearByBadgeView.isHidden = true
        
        self.setupAnimation(withAnimation: true)
        self.getAllCategories()
        
        self.iv_accountVerified.image = UIImage(named: "cyn_grayNotVerified")
//        let isAccountVerified = UserDefaults.standard.value(forKey: "LoggedKYC") as? Bool ?? false
        
//        if isAccountVerified {
//            self.iv_accountVerified.image = UIImage(named: "cyn_greenVerified")
//        } else {
//            self.iv_accountVerified.image = UIImage(named: "cyn_grayNotVerified")
//        }
        
        let username = UserDefaults.standard.value(forKey: "LoggedUserName") as? String ?? ""
        self.lbl_userName.text = "Hi!" + " " + username
        
        guard let imageUrl = UserDefaults.standard.value(forKey: "LoggedUserProfileImage") as? String, let url = URL(string: imageUrl) else {
            self.setProfileNameIfNotPhoto(username)
            return
        }
        
        self.downloadImage(url: url)
        
        if imageUrl.count == 0 {
            self.setProfileNameIfNotPhoto(username)
        } else {
            self.btn_profile.setTitle("", for: .normal)
        }

    }
    
    private func setProfileNameIfNotPhoto(_ name: String) {
        let namePrefix = name.prefix(1)
        self.btn_profile.setTitle("\(namePrefix)", for: .normal)
        self.btn_profile.titleLabel?.font = ConstHelper.h4Bold
        self.btn_profile.tintColor = ConstHelper.cyan
        self.btn_profile.backgroundColor = ConstHelper.white
        self.btn_profile.setBorderForView(width: 1, color: .white, radius: self.btn_profile.frame.size.height / 2.0)
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
    
    private func emergencyLottieAnimation(withAnimation status: Bool) {
        emergencyAnimationView.animation = Animation.named(ConstHelper.lottie_heartbeat)
        emergencyAnimationView.frame = vw_emergencyLottieView.bounds
        emergencyAnimationView.backgroundColor = ConstHelper.white
        emergencyAnimationView.contentMode = .scaleAspectFit
        emergencyAnimationView.loopMode = .loop
        emergencyAnimationView.play()
        vw_emergencyLottieView.addSubview(emergencyAnimationView)
    }
    
    private func nearbyLottieAnimation(withAnimation status: Bool) {
        nearbyAnimationView.animation = Animation.named(ConstHelper.lottie_nearbyeme)
        nearbyAnimationView.frame = vw_nearbyLottieView.bounds
        nearbyAnimationView.backgroundColor = ConstHelper.white
        nearbyAnimationView.contentMode = .scaleAspectFit
        nearbyAnimationView.loopMode = .loop
        nearbyAnimationView.play()
        vw_nearbyLottieView.addSubview(nearbyAnimationView)
    }
    
    private func lockedLottieAnimation(withAnimation status: Bool) {
        lockedAnimationView.animation = Animation.named(ConstHelper.lottie_lockOutline)
        lockedAnimationView.frame = vw_lockedLottieView.bounds
        lockedAnimationView.backgroundColor = ConstHelper.white
        lockedAnimationView.contentMode = .scaleAspectFit
        lockedAnimationView.loopMode = .loop
        lockedAnimationView.play()
        vw_lockedLottieView.addSubview(lockedAnimationView)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        self.showAlertMax(title: "Logout", message: "Are you sure you want to logout?", actionTitles: ["Cancel", "Ok"], actionStyle: [.cancel,.default], action: [
            { cancelAction in
                print("User cancel the operation")
            }, { okAction in
                UserDefaults.standard.set(nil, forKey: "LoggedUserId")
                UserDefaults.standard.set(false, forKey: "loginStatusKey")
                UserDefaults.standard.synchronize()
                LoginViewController.removeUserDetailsWhenLoggedOut()
                Switcher.updateRootViewController(setTabIndex: 0)
            }
        ])
    }
    
    private func formFillingViewController(_ product: ProductModel?) {
        let storyboard = UIStoryboard(name: "Form", bundle: nil)
        if let rootVC = storyboard.instantiateViewController(withIdentifier: "FormFilllingViewController") as? FormFilllingViewController {
            rootVC.selctedProduct = product
            rootVC.isFromEditQRInfo = false
            let nav = UINavigationController(rootViewController: rootVC)
            nav.modalPresentationStyle = .fullScreen
            self.view.window?.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func emergencyRequestAction(_ sender: UIButton) {
        self.emergencyRequestViewController()
    }
    
    @IBAction func emergencyNearbyAction(_ sender: UIButton) {
        self.emergencyNearbyViewController()
    }
    
    @IBAction func emergencyLockedAction(_ sender: UIButton) {
        self.emergencyLockedViewController()
    }
    
    private func emergencyRequestViewController() {
        let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
        if let emergencyRequestVC = storyboard.instantiateViewController(withIdentifier: "EmergencyRequestViewController") as? EmergencyRequestViewController {
            emergencyRequestVC.modalPresentationStyle = .fullScreen
            self.present(emergencyRequestVC, animated: true, completion: nil)
        }
    }
    
    private func emergencyNearbyViewController() {
        let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
        if let emergencyNearbyVC = storyboard.instantiateViewController(withIdentifier: "EmergencyNearbyViewController") as? EmergencyNearbyViewController {
            emergencyNearbyVC.modalPresentationStyle = .fullScreen
            self.present(emergencyNearbyVC, animated: true, completion: nil)
        }
    }
    
    private func emergencyLockedViewController() {
        let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
        if let emergencyLockedVC = storyboard.instantiateViewController(withIdentifier: "EmergencyLockedViewController") as? EmergencyLockedViewController {
            emergencyLockedVC.modalPresentationStyle = .fullScreen
            self.present(emergencyLockedVC, animated: true, completion: nil)
        }
    }
    
    private func subcribeViewController() {
        let storyboard = UIStoryboard(name: "Subscribe", bundle: nil)
        if let subscribeVC = storyboard.instantiateViewController(withIdentifier: "SubscribeViewController") as? SubscribeViewController {
            subscribeVC.modalPresentationStyle = .fullScreen
            self.present(subscribeVC, animated: true, completion: nil)
        }
    }
    
    private func addPremiumListViewController(_ b2nApproved: B2bApprovedModel) {
        let storyboard = UIStoryboard(name: "AdPremium", bundle: nil)
        if let adPremiumDetailVC = storyboard.instantiateViewController(withIdentifier: "AdPremiumDetailViewController") as? AdPremiumDetailViewController {
            adPremiumDetailVC.b2bApprovedModel = b2nApproved
            adPremiumDetailVC.modalPresentationStyle = .fullScreen
            self.present(adPremiumDetailVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func myOrdersNotificationAction(_ sender: UIButton) {
        Switcher.updateRootViewController(setTabIndex: 2)
    }
    
    //MARK: - StopTimer Methods
    func stopTimer() {
        timer?.invalidate()
    }
    
    @IBAction func viewAllAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AdPremium", bundle: nil)
        if let adPremiumListVC = storyboard.instantiateViewController(withIdentifier: "AdPremiumListViewController") as? AdPremiumListViewController {
            adPremiumListVC.b2bList = self.b2bApprovedList?.data
            adPremiumListVC.modalPresentationStyle = .fullScreen
            self.present(adPremiumListVC, animated: true, completion: nil)
        }
    }
}

extension HomeViewController {
    private func updateDefaultUI() {
        self.vw_emergencyTitleBackView.backgroundColor = ConstHelper.darkRed
        self.vw_mainTitleBackView.backgroundColor = ConstHelper.lightWhiteGray
        self.vw_subTitleBackView.backgroundColor = ConstHelper.lightWhiteGray
        self.vw_miniTitleBackView.backgroundColor = ConstHelper.lightWhiteGray
        self.vw_prodTitleBackView.backgroundColor = ConstHelper.lightWhiteGray
        
        self.lbl_emergencyTitle.font = ConstHelper.h4Bold
        self.lbl_emergencyTitle.textColor = ConstHelper.white
        
        self.lbl_mainCategoryName.font = ConstHelper.h4Bold
        self.lbl_mainCategoryName.textColor = ConstHelper.cyan
        
        self.lbl_subCategoryName.font = ConstHelper.h4Bold
        self.lbl_subCategoryName.textColor = ConstHelper.cyan
        
        self.lbl_miniCategoryName.font = ConstHelper.h4Bold
        self.lbl_miniCategoryName.textColor = ConstHelper.cyan
        
        self.lbl_prodCategoryName.font = ConstHelper.h4Bold
        self.lbl_prodCategoryName.textColor = ConstHelper.cyan
        
        self.vw_emergencyImgBackView.setBorderForView(width: 1, color: UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 0.5), radius: 10)
        self.lbl_emergencyListTitle.text = "Request"
        lbl_emergencyListTitle.font = ConstHelper.h5Normal
        lbl_emergencyListTitle.textColor = ConstHelper.black
        
        self.vw_nearbyImgBackView.setBorderForView(width: 1, color: UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 0.5), radius: 10)
        self.lbl_nearbyListTitle.text = "Nearby"
        lbl_nearbyListTitle.font = ConstHelper.h5Normal
        lbl_nearbyListTitle.textColor = ConstHelper.black
        
        self.vw_lockedImgBackView.setBorderForView(width: 1, color: UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 0.5), radius: 10)
        self.lbl_lockedListTitle.text = "Locked"
        lbl_lockedListTitle.font = ConstHelper.h5Normal
        lbl_lockedListTitle.textColor = ConstHelper.black
        
        self.btn_profile.setBorderForView(width: 1, color: .clear, radius: btn_profile.frame.size.height / 2)
        
        self.vw_notificationBadgeView.backgroundColor = ConstHelper.orange
        self.vw_notificationBadgeView.setBorderForView(width: 0, color: ConstHelper.white, radius: vw_notificationBadgeView.frame.size.height / 2)
        lbl_notificationBadge.font = ConstHelper.h7Normal
        lbl_notificationBadge.textColor = ConstHelper.white
        
        self.vw_notificationNearByBadgeView.backgroundColor = ConstHelper.orange
        self.vw_notificationNearByBadgeView.setBorderForView(width: 0, color: ConstHelper.white, radius: vw_notificationBadgeView.frame.size.height / 2)
        lbl_notificationNearByBadge.font = ConstHelper.h7Normal
        lbl_notificationNearByBadge.textColor = ConstHelper.white
        
        self.cv_mainCategoryCollectionView.backgroundColor = .white
        self.cv_subCategoryCollectionView.backgroundColor = .white
        self.cv_miniCategoryCollectionView.backgroundColor = .white
        self.cv_prodCategoryCollectionView.backgroundColor = .white

    }
    
    private func updateDefaultSelectionForAll() {
        let indexPath = IndexPath(item: 0, section: 0)
        self.cv_mainCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.cv_subCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.cv_miniCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.cv_prodCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func updateDefaultSelectionForSubMiniProd() {
        let indexPath = IndexPath(item: 0, section: 0)
        self.cv_subCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.cv_miniCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.cv_prodCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func updateDefaultSelectionForMiniProd() {
        let indexPath = IndexPath(item: 0, section: 0)
        self.cv_miniCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.cv_prodCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func updateDefaultSelectionForProd() {
        let indexPath = IndexPath(item: 0, section: 0)
        self.cv_prodCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.cv_subsciptionCollectionView:
            if let b2bList = self.b2bApprovedList?.data {
                return b2bList.count
            }
            return 0
        case self.cv_mainCategoryCollectionView:
            if let mainCategory = self.mainCategoryModel {
                return mainCategory.count
            }
            return 0
        case self.cv_subCategoryCollectionView:
            if let subCategory = self.subCategoryModel {
                return subCategory.count
            }
            return 0
        case self.cv_miniCategoryCollectionView:
            if let miniCategory = self.miniCategoryModel {
                return miniCategory.count
            }
            return 0
        case self.cv_prodCategoryCollectionView:
            if let products = self.productModel {
                return products.count
            }
            return 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch collectionView {
            case self.cv_subsciptionCollectionView:
                let subscriptionCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.subscriptionCollectionIdentifier, for: indexPath) as! SubscriptionCell
                if let b2bApproved = self.b2bApprovedList?.data?[indexPath.item] {
                    subscriptionCollectionCell.setB2bApprovedCell(b2bApproved.banner)
                }
                return subscriptionCollectionCell
            case self.cv_mainCategoryCollectionView:
                let categoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.categoryCollectionIdentifier, for: indexPath) as! CategoryCollectionCell
                if let category = self.mainCategoryModel?[indexPath.item] {
                    categoryCollectionCell.setCategoryCell(category.image, title: category.name)
                }
                return categoryCollectionCell
            case self.cv_subCategoryCollectionView:
                let categoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.categoryCollectionIdentifier, for: indexPath) as! CategoryCollectionCell
                if let subCategory = self.subCategoryModel?[indexPath.item] {
                    categoryCollectionCell.setCategoryCell(subCategory.image, title: subCategory.name)
                }
                return categoryCollectionCell
            case self.cv_miniCategoryCollectionView:
                let categoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.categoryCollectionIdentifier, for: indexPath) as! CategoryCollectionCell
                if let miniCategory = self.miniCategoryModel?[indexPath.item] {
                    categoryCollectionCell.setCategoryCell(miniCategory.image, title: miniCategory.name)
                }
                return categoryCollectionCell
            case self.cv_prodCategoryCollectionView:
                let categoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.categoryCollectionIdentifier, for: indexPath) as! CategoryCollectionCell
                if let product = self.productModel?[indexPath.item] {
                    categoryCollectionCell.setCategoryCell(product.image, title: product.name)
                }
                return categoryCollectionCell
            default:
                let categoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.categoryCollectionIdentifier, for: indexPath) as! CategoryCollectionCell
  
                return categoryCollectionCell
            }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.cv_subsciptionCollectionView:
            return CGSize(width: vw_subscriptionBackView.frame.width, height: 155)
        case self.cv_mainCategoryCollectionView:
            return CGSize(width: 100, height: 120)
        case self.cv_subCategoryCollectionView:
            return CGSize(width: 100, height: 120)
        case self.cv_miniCategoryCollectionView:
            return CGSize(width: 100, height: 120)
        case self.cv_prodCategoryCollectionView:
            return CGSize(width: 100, height: 120)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.cv_subsciptionCollectionView:
            if let b2bApproved = self.b2bApprovedList?.data?[indexPath.item] {
                self.addPremiumListViewController(b2bApproved)
            }
        case self.cv_mainCategoryCollectionView:
            if let category = self.mainCategoryModel?[indexPath.row] {
                
                ConstHelper.productCategory = (category.name ?? "").lowercased()

                self.vw_subBackView.isHidden = true
                self.vw_miniBackView.isHidden = true
                self.vw_prodBackView.isHidden = true
                
                let subCategoryAvailable = category.subCategory ?? false
                if subCategoryAvailable {
                    self.vw_subBackView.isHidden = false
                    self.subCategoryModel = category.subCategoryData
                    self.lbl_subCategoryName.text = category.subCategoryData?.first?.name
                    
                    let miniCategoryAvailable = self.subCategoryModel?.first?.miniCategory ?? false
                    if miniCategoryAvailable {
                        self.vw_miniBackView.isHidden = false
                        self.miniCategoryModel = self.subCategoryModel?.first?.miniCategoryData
                        self.lbl_miniCategoryName.text = self.subCategoryModel?.first?.miniCategoryData?.first?.name
                        
                        self.productModel = self.subCategoryModel?.first?.miniCategoryData?.first?.products
                        self.lbl_prodCategoryName.text = self.subCategoryModel?.first?.miniCategoryData?.first?.products?.first?.name
                        self.vw_prodBackView.isHidden = false
                    } else {
                        self.productModel = self.subCategoryModel?.first?.products
                        self.lbl_prodCategoryName.text = self.subCategoryModel?.first?.products?.first?.name
                        self.vw_prodBackView.isHidden = false
                    }
                } else {
                    self.productModel = category.subCategoryData?.first?.miniCategoryData?.first?.products
                    self.lbl_prodCategoryName.text = category.subCategoryData?.first?.miniCategoryData?.first?.products?.first?.name
                    self.vw_prodBackView.isHidden = false
                }
                
                DispatchQueue.main.async {
                    self.cv_subCategoryCollectionView.reloadData()
                    self.cv_miniCategoryCollectionView.reloadData()
                    self.cv_prodCategoryCollectionView.reloadData()
                    self.updateDefaultSelectionForSubMiniProd()
                }
            }
        case self.cv_subCategoryCollectionView:
            if let sub = self.subCategoryModel?[indexPath.row] {
                self.vw_miniBackView.isHidden = true
                self.vw_prodBackView.isHidden = true
                self.lbl_subCategoryName.text = sub.name
                
                let miniCategoryAvailable = sub.miniCategory ?? false
                if miniCategoryAvailable {
                    self.vw_miniBackView.isHidden = false
                    self.miniCategoryModel = sub.miniCategoryData
                    self.lbl_miniCategoryName.text = sub.miniCategoryData?.first?.name
                    
                    self.productModel = sub.miniCategoryData?.first?.products
                    self.lbl_prodCategoryName.text = sub.miniCategoryData?.first?.products?.first?.name
                    self.vw_prodBackView.isHidden = false
                } else {
                    self.productModel = sub.products
                    self.lbl_prodCategoryName.text = sub.products?.first?.name
                    self.vw_prodBackView.isHidden = false
                }
                
                DispatchQueue.main.async {
                    self.cv_miniCategoryCollectionView.reloadData()
                    self.cv_prodCategoryCollectionView.reloadData()
                    self.updateDefaultSelectionForMiniProd()
                }
            }
        case self.cv_miniCategoryCollectionView:
            if let mini = self.miniCategoryModel?[indexPath.row] {
                self.productModel = mini.products
                self.lbl_miniCategoryName.text = mini.name
                self.lbl_prodCategoryName.text = mini.products?.first?.name
                self.vw_prodBackView.isHidden = false
                
                DispatchQueue.main.async {
                    self.cv_prodCategoryCollectionView.reloadData()
                    self.updateDefaultSelectionForProd()
                }
            }
            
        case self.cv_prodCategoryCollectionView:
            let selectedProduct = self.productModel?[indexPath.item]
            self.lbl_prodCategoryName.text = selectedProduct?.name
            self.formFillingViewController(selectedProduct)
        default:
            break
        }
    }
    
}

//MARK: - API Call
extension HomeViewController {
    private func getAllCategories() {
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .allProducts
        print(ConstHelper.dynamicBaseUrl)
        let endPoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get, headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)
        
        client.getAllCategories(from: endPoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false)
            switch result {
            case .success(let categories):
                guard let categories = categories else { return }
                
                if categories.status {
                    strongSelf.handleResult(categories)
                    strongSelf.getAllNotificationsCount()
//                    strongSelf.getBanners()
                    strongSelf.getB2bApprovedList()
                }
                
            case .failure(let error):
                strongSelf.setNilAllDataWhenNetworkError()
            }
        }
    }
    
//    private func getBanners() {
//        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
//        let api: Apifeed = .getBanners
//        let endPoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get, headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)
//
//        client.get_getBanners(from: endPoint) { [weak self] result in
//            guard let strongSelf = self else { return }
//            strongSelf.setupAnimation(withAnimation: false)
//            switch result {
//            case .success(let banners):
//                guard let bannersRes = banners else { return }
//                print("Banners: \(bannersRes)")
//                if bannersRes.status {
//                    strongSelf.banners = bannersRes.data
////                    strongSelf.getKYCStatus()
//                }
//
//                strongSelf.cv_subsciptionCollectionView.reloadData()
//
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
////                strongSelf.setNilAllDataWhenNetworkError()
//            }
//        }
//    }
    
    private func getB2bApprovedList() {
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .getApprovedList
        
        let endPoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get, headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)
        
        client.get_b2bApprovedList(from: endPoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false)
            switch result {
            case .success(let res):
                guard let res = res else { return }
                
                if res.status {
                    strongSelf.b2bApprovedList = res
                    strongSelf.getKYCStatus()
                }
                
                strongSelf.cv_subsciptionCollectionView.reloadData()
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func getKYCStatus() {
        let api: Apifeed = .getKycStatus
        print(ConstHelper.dynamicBaseUrl)
        let endPoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get, headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)
        
        client.get_KYCStatus(from: endPoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false)
            switch result {
            case .success(let kyc):
                guard let kycRes = kyc else { return }
                
                if kycRes.status {
                    let isAccountVerified = kycRes.data?.kyc ?? false
                    UserDefaults.standard.set(isAccountVerified, forKey: "LoggedKYC")
                    if isAccountVerified {
                        strongSelf.iv_accountVerified.image = UIImage(named: "cyn_greenVerified")
                    } else {
                        strongSelf.iv_accountVerified.image = UIImage(named: "cyn_grayNotVerified")
                    }
                }
                
                strongSelf.cv_subsciptionCollectionView.reloadData()
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
//                strongSelf.setNilAllDataWhenNetworkError()
            }
        }
    }
    
    //MARK: - Handle Api response
    private func handleResult(_ result: CategoryModel?) {
        self.categoryModel = nil
        self.mainCategoryModel = nil
        self.subCategoryModel = nil
        self.miniCategoryModel = nil
        self.productModel = nil
        
        guard let categoryModel = result else {
            self.allProductsBackView.isHidden = true
            self.vw_emergencyBackView.isHidden = true
            return
        }
        
        self.allProductsBackView.isHidden = false
        self.vw_emergencyBackView.isHidden = false
        
        self.categoryModel = categoryModel
        
        self.mainCategoryModel = categoryModel.data
        ConstHelper.productCategory = (self.mainCategoryModel?.first?.name ?? "").lowercased()
        self.vw_mainBackView.isHidden = false
        
        let subCategoryAvailable =  categoryModel.data?.first?.subCategory ?? false
        
        if subCategoryAvailable {
            self.subCategoryModel = categoryModel.data?.first?.subCategoryData
            self.lbl_subCategoryName.text = categoryModel.data?.first?.subCategoryData?.first?.name
            self.vw_subBackView.isHidden = false
            
            let miniCategoryAvailable = categoryModel.data?.first?.subCategoryData?.first?.miniCategory ?? false
            if miniCategoryAvailable {
                self.miniCategoryModel = self.subCategoryModel?.first?.miniCategoryData
                self.lbl_miniCategoryName.text = self.miniCategoryModel?.first?.name
                self.vw_miniBackView.isHidden = false
                
                self.productModel = self.miniCategoryModel?.first?.products
                self.lbl_prodCategoryName.text = self.productModel?.first?.name
                self.vw_prodBackView.isHidden = false
            } else {
                self.productModel = self.subCategoryModel?.first?.products
                self.lbl_prodCategoryName.text = self.productModel?.first?.name
                self.vw_prodBackView.isHidden = false
            }
            
        } else {
            self.productModel = self.mainCategoryModel?.first?.products
            self.lbl_prodCategoryName.text = self.productModel?.first?.name
            self.vw_prodBackView.isHidden = false
        }
        
        DispatchQueue.main.async {
            self.cv_mainCategoryCollectionView.reloadData()
            self.cv_subCategoryCollectionView.reloadData()
            self.cv_miniCategoryCollectionView.reloadData()
            self.cv_prodCategoryCollectionView.reloadData()
            self.updateDefaultSelectionForAll()
        }
        
    }
    
    private func getAllNotificationsCount() {
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .notificationsCounts
        
        let endPoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get, headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)
        
        client.get_NotificationsCount(from: endPoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false)
            switch result {
            case .success(let notificationsCount):
                guard let notificationsCount = notificationsCount else { return }
                
                if notificationsCount.status {
                    strongSelf.handleNotificationCount(notificationsCount)
                }
                
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
            }
        }
    }
    
    private func handleNotificationCount(_ count: NotificationsCountResModel) {
        DispatchQueue.main.async {
            let quickNeedsCount = count.quickNeedsCount ?? 0
            let emergencyCount = count.emergencyCounts ?? 0
            
            if quickNeedsCount != 0 {
                self.vw_notificationBadgeView.isHidden = false
                self.lbl_notificationBadge.text = "\(count.quickNeedsCount ?? 0)"
            }
            
            if emergencyCount != 0 {
                self.vw_notificationNearByBadgeView.isHidden = false
                self.lbl_notificationNearByBadge.text = "\(count.emergencyCounts ?? 0)"
            }
            
            
        }
    }
    
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: btn_profile.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 10)
        self.btn_profile.kf.setBackgroundImage(
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
    
    private func setNilAllDataWhenNetworkError() {
        self.categoryModel = nil
        self.mainCategoryModel = nil
        self.subCategoryModel = nil
        self.miniCategoryModel = nil
        self.productModel = nil
        
        self.cv_mainCategoryCollectionView.reloadData()
        self.cv_subCategoryCollectionView.reloadData()
        self.cv_miniCategoryCollectionView.reloadData()
        self.cv_prodCategoryCollectionView.reloadData()
        
        self.allProductsBackView.isHidden = true
        self.vw_emergencyBackView.isHidden = true
        
    }
    
    private func playAppTutorial(_ videoId: String) {
        let videoPlayer = YTPlayerView()
        view.addSubview(videoPlayer)
        
        videoPlayer.delegate = self
        videoPlayer.load(withVideoId: videoId)
        
    }
}

extension HomeViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print("playing video")
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .unstarted:
            print("unstarted")
        case .buffering:
            print("buffering")
        case .playing:
            print("playing")
        case .paused:
            print("paused")
        default:
            print("Unknown")
        }
    }
}

extension HomeViewController: MyLocationManagerDelegate {
    func didGetErrorForPermissions(withTitle title: String, andError error: String) {
//        print("Title: \(title), Error: \(error)")
    }
    
    func didGetLocation(withLocation name: String?, latitude: Double?, longitude: Double?) {
//        print("Location: \(name ?? "")\nLatitude: \(latitude ?? 0.0), Longitude: \(longitude ?? 0.0)")
    }
    
    @objc private func getUpdateMyLocationForEvery2Minutes() {
        if let lat = ConstHelper.myLatitude, let lng = ConstHelper.myLogitude, let locName = ConstHelper.myLocationName {
            DispatchQueueHelper.delay(bySeconds: 0) {
                let locMngr = MyLocationManager()
                locMngr.updateLocationToServer(witCordinates: lat, lng: lng, location: locName)
            }
        }
    }
    
}
