//
//  AdPremiumListViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 20/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import UIKit

class AdPremiumListViewController: UIViewController {

    @IBOutlet weak var cv_adPremiumCollectionView: UICollectionView!
    var b2bList: [B2bApprovedModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cv_adPremiumCollectionView.delegate = self
        self.cv_adPremiumCollectionView.dataSource = self
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

extension AdPremiumListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let b2bList = self.b2bList {
            return b2bList.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let adPremiumListCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.adPremiumListCellTableViewCell, for: indexPath) as! AdPremiumListCell
        
        if let b2b = self.b2bList?[indexPath.item] {
            adPremiumListCell.setB2bApprovedCell(b2b.titleBanner)
        }
        
        return adPremiumListCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = self.view.frame.width
        let height = width/2.0
        return CGSize(width: (width/2.0) - 26, height: (height - 20))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return  16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let b2b = self.b2bList?[indexPath.item] {
            self.adPremiumDetailViewController(b2b)
        }
    }
    
    private func adPremiumDetailViewController(_ b2nApproved: B2bApprovedModel) {
        if let adPremiumDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPremiumDetailViewController") as? AdPremiumDetailViewController {
            adPremiumDetailVC.b2bApprovedModel = b2nApproved
            adPremiumDetailVC.modalPresentationStyle = .fullScreen
            self.present(adPremiumDetailVC, animated: true, completion: nil)
        }
    }
}
