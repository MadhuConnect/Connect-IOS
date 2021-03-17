//
//  EmergencyInterestViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 29/10/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class EmergencyInterestViewController: UIViewController {
    
    @IBOutlet weak var interestTableView: UITableView!
    
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    
    let animationView = AnimationView()
    
    var interestedPersons: [Interests]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.interestTableView.tableFooterView = UIView(frame: .zero)
        self.interestTableView.reloadData()
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
    
}

extension EmergencyInterestViewController {
    private func updateDefaultUI() {
        navigationController?.navigationBar.isHidden = true
        self.lbl_title.text = "Interested users"
        
        self.interestTableView.delegate = self
        self.interestTableView.dataSource = self
        
        self.lbl_message.font = ConstHelper.h6Normal
        self.lbl_message.textColor = ConstHelper.gray
        
        let interestsCount = self.interestedPersons?.count ?? 0
        if interestsCount == 0 {
            self.setupAnimation(withAnimation: true, name: ConstHelper.lottie_nodata)
            self.lbl_message.text = "No interests"
        } else {
            self.setupAnimation(withAnimation: false, name: ConstHelper.lottie_nodata)
            self.lbl_message.text = ""
        }
    }
}

extension EmergencyInterestViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let interestedPersons = self.interestedPersons {
            return interestedPersons.count
        }
            
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let interestedCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.emergencyInterestTableViewCell, for: indexPath) as! EmergencyInterestTableViewCell
        
        if let interested = self.interestedPersons?[indexPath.row] {
            interestedCell.setInterestedInformation(interested)
        }
        
        //Button actions
        interestedCell.btn_makeCall.tag = indexPath.row
        interestedCell.btn_makeCall.addTarget(self, action: #selector(makeCallAction(_:)), for: .touchUpInside)
        
        return interestedCell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    @objc private func makeCallAction(_ sender: UIButton) {
        self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "Make call", actionTitle: "Ok")
        return
    }
    

}
