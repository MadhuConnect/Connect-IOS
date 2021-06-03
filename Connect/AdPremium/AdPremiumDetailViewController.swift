//
//  AdPremiumDetailViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 20/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import UIKit

class AdPremiumDetailViewController: UIViewController {

    @IBOutlet weak var cv_sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    @IBOutlet weak var lbl_nameHead: UILabel!
    @IBOutlet weak var lbl_nameValue: UILabel!
    
    @IBOutlet weak var lbl_descriptionHead: UILabel!
    @IBOutlet weak var lbl_descriptionValue: UILabel!
    
    @IBOutlet weak var lbl_offerHead: UILabel!
    @IBOutlet weak var lbl_offerValue: UILabel!
    
    @IBOutlet weak var lbl_contactUsHead: UILabel!
    @IBOutlet weak var lbl_contactUsValue: UILabel!
    
    @IBOutlet weak var vw_line1: UIView!
    @IBOutlet weak var vw_line2: UIView!
    @IBOutlet weak var vw_line3: UIView!
    @IBOutlet weak var vw_line4: UIView!
    
    var timer = Timer()
    var counter = 0
    
    //slide images
    var b2bApprovedModel: B2bApprovedModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateDefaultUI()
        
        self.cv_sliderCollectionView.delegate = self
        self.cv_sliderCollectionView.dataSource = self
        
        self.loadPageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.lbl_nameValue.text = self.b2bApprovedModel?.name
        self.lbl_descriptionValue.text = self.b2bApprovedModel?.description
        self.lbl_offerValue.text = self.b2bApprovedModel?.offer
        self.lbl_contactUsValue.text = self.b2bApprovedModel?.contactUs
    }
    
    func loadPageView() {
        if let qrImages = self.b2bApprovedModel?.viewImages {
            pageView.numberOfPages = qrImages.count
            pageView.currentPage = 0
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func changeImage() {
        if let qrImages = self.b2bApprovedModel?.viewImages {
            if counter < qrImages.count {
                let index = IndexPath.init(item: counter, section: 0)
                self.cv_sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                pageView.currentPage = counter
                counter += 1
            } else {
                counter = 0
                let index = IndexPath.init(item: counter, section: 0)
                self.cv_sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                pageView.currentPage = counter
                counter = 1
            }
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

}

extension AdPremiumDetailViewController {
    private func updateDefaultUI() {
        self.lbl_nameHead.font = ConstHelper.h4Bold
        self.lbl_nameHead.textColor = ConstHelper.black
        self.lbl_nameValue.font = ConstHelper.h6Normal
        self.lbl_nameValue.textColor = ConstHelper.gray
        
        self.lbl_descriptionHead.font = ConstHelper.h4Bold
        self.lbl_descriptionHead.textColor = ConstHelper.black
        self.lbl_descriptionValue.font = ConstHelper.h6Normal
        self.lbl_descriptionValue.textColor = ConstHelper.gray
        
        self.lbl_offerHead.font = ConstHelper.h4Bold
        self.lbl_offerHead.textColor = ConstHelper.black
        self.lbl_offerValue.font = ConstHelper.h6Normal
        self.lbl_offerValue.textColor = ConstHelper.gray
        
        self.lbl_contactUsHead.font = ConstHelper.h4Bold
        self.lbl_contactUsHead.textColor = ConstHelper.black
        self.lbl_contactUsValue.font = ConstHelper.h6Normal
        self.lbl_contactUsValue.textColor = ConstHelper.gray
        
        self.vw_line1.backgroundColor = ConstHelper.lineColor
        self.vw_line2.backgroundColor = ConstHelper.lineColor
        self.vw_line3.backgroundColor = ConstHelper.lineColor
        self.vw_line4.backgroundColor = ConstHelper.lineColor
    }
}

extension AdPremiumDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let qrImages = self.b2bApprovedModel?.viewImages {
            return qrImages.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sliderCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.sliderCellIdentifier, for: indexPath) as! SlideCollectionViewCell
        
        if let qrImage = self.b2bApprovedModel?.viewImages?[indexPath.row] {
            sliderCell.setB2bApprovedlider(qrImage)
        }

        return sliderCell
    }
}

extension AdPremiumDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = cv_sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
