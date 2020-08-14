//
//  HomeViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 06/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    @IBOutlet weak var vw_emergencyBackView: UIView!
    @IBOutlet weak var btn_emergencyBtn: UIButton!
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    //Navbar
    @IBOutlet weak var iv_profile: UIImageView!
    @IBOutlet weak var btn_profile: UIButton!
    @IBOutlet weak var lbl_userName: UILabel!
    
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
        
    let animationView = AnimationView()
    private let client = APIClient()
    
    var categoryModel: CategoryModel?
    var mainCategoryModel: [MainCategoryModel]?
    var subCategoryModel: [SubCategoryModel]?
    var miniCategoryModel: [MiniCategoryModel]?
    var productModel: [ProductModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        
        self.cv_mainCategoryCollectionView.delegate = self
        self.cv_mainCategoryCollectionView.dataSource = self
        
        self.cv_subCategoryCollectionView.delegate = self
        self.cv_subCategoryCollectionView.dataSource = self

        self.cv_miniCategoryCollectionView.delegate = self
        self.cv_miniCategoryCollectionView.dataSource = self
//
        self.cv_prodCategoryCollectionView.delegate = self
        self.cv_prodCategoryCollectionView.dataSource = self
        
        vw_mainBackView.isHidden = true
        vw_subBackView.isHidden = true
        vw_miniBackView.isHidden = true
        vw_prodBackView.isHidden = true
        
        self.updateDefaultUI()
        self.setupAnimation(withAnimation: true)
        self.getAllCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    
    @IBAction func logoutAction(_ sender: UIButton) {
        self.showAlertMax(title: "Logout", message: "Are you sure you want to logout?", actionTitles: ["Cancel", "Ok"], actionStyle: [.cancel,.default], action: [
            { cancelAction in
                print("User cancel the operation")
            }, { okAction in
                print("User logged out successful")
                UserDefaults.standard.set(nil, forKey: "LoggedUserId")
                UserDefaults.standard.set(false, forKey: "loginStatusKey")
                UserDefaults.standard.synchronize()
                
                Switcher.updateRootViewController()
            }
        ])
    }
    
    private func formFillingViewController(_ product: ProductModel?) {
        let storyboard = UIStoryboard(name: "Form", bundle: nil)
        if let rootVC = storyboard.instantiateViewController(withIdentifier: "FormFilllingViewController") as? FormFilllingViewController {
            rootVC.selctedProduct = product
            let nav = UINavigationController(rootViewController: rootVC)
            nav.modalPresentationStyle = .fullScreen
            self.view.window?.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }

}

extension HomeViewController {
    private func updateDefaultUI() {
        self.btn_emergencyBtn.titleLabel?.font = ConstHelper.h3Bold
        self.btn_emergencyBtn.backgroundColor = .clear
        self.btn_emergencyBtn.tintColor = ConstHelper.white
        self.vw_emergencyBackView.backgroundColor = ConstHelper.red
        self.vw_emergencyBackView.setBorderForView(width: 0, color: .red, radius: 10)
        
        //Update user info
        let username = UserDefaults.standard.value(forKey: "LoggedUserName") as? String ?? ""
        self.lbl_userName.text = "Hi!" + " " + username
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
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
        case self.cv_mainCategoryCollectionView:
//            let size = (self.cv_mainCategoryCollectionView.frame.width-8)
            return CGSize(width: 80, height: 120)
        case self.cv_subCategoryCollectionView:
//            let size = (self.cv_subCategoryCollectionView.frame.width-8)
            return CGSize(width: 80, height: 120)
        case self.cv_miniCategoryCollectionView:
//            let size = (self.cv_miniCategoryCollectionView.frame.width-8)
            return CGSize(width: 80, height: 120)
        case self.cv_prodCategoryCollectionView:
//            let size = (self.cv_prodCategoryCollectionView.frame.width-8)
            return CGSize(width: 80, height: 120)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.cv_mainCategoryCollectionView:
            if let category = self.mainCategoryModel?[indexPath.row] {
                
                self.vw_subBackView.isHidden = true
                self.vw_miniBackView.isHidden = true
                self.vw_prodBackView.isHidden = true
                
                let subCategoryAvailable = category.subCategory
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
                }
            }
        case self.cv_subCategoryCollectionView:
            if let sub = self.subCategoryModel?[indexPath.row] {
                self.vw_miniBackView.isHidden = true
                self.vw_prodBackView.isHidden = true
                
                let miniCategoryAvailable = sub.miniCategory
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
                }
            }
        case self.cv_miniCategoryCollectionView:
            if let mini = self.miniCategoryModel?[indexPath.row] {
                self.productModel = mini.products
                self.lbl_prodCategoryName.text = mini.products?.first?.name
                self.vw_prodBackView.isHidden = false
                
                DispatchQueue.main.async {
                    self.cv_prodCategoryCollectionView.reloadData()
                }
            }
            
        case self.cv_prodCategoryCollectionView:
            let selectedProduct = self.productModel?[indexPath.item]
            self.formFillingViewController(selectedProduct)
        default:
            break
        }
    }
    
}

//MARK: - API Call
extension HomeViewController {
    private func getAllCategories() {
        print("All Categories Loading...")
        let api: Apifeed = .allProducts
        let endPoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get, headers: [.contentType("application/json")], body: nil, timeInterval: 120)
        
        client.getAllCategories(from: endPoint) { [weak self] result in
            guard let strongSelf = self else { return }
            print("Downloaded Finished...")
            strongSelf.setupAnimation(withAnimation: false)
            switch result {
            case .success(let categories):
                guard let categories = categories else { return }
                
                if categories.status {
                    strongSelf.handleResult(categories)
                } else {
                    
                }
                
            case .failure(let error):
                strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
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
        
        guard let categoryModel = result else { return }
        
        self.categoryModel = categoryModel
        
        self.mainCategoryModel = categoryModel.data
        
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
        }
        
    }
    
}
