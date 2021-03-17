//
//  GalleryViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 04/03/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    //Gallery
    @IBOutlet weak var cv_galleryCollectionView: UICollectionView!
    
    var paidConnectionImages: [PaidConnectionImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cv_galleryCollectionView.delegate = self
        self.cv_galleryCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.cv_galleryCollectionView.reloadData()
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

//MARK: - Gallery Collection View
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let paidImages = self.paidConnectionImages {
            return paidImages.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let galleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstHelper.galleryCollectionIdentifier, for: indexPath) as! GalleryCell
 
        if let paidImage = self.paidConnectionImages?[indexPath.row] {
            galleryCell.setGalleryCell(paidImage.productImage)
        }
        
        return galleryCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
