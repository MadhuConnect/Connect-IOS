//
//  ContactUsViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 19/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_emergency: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var sg_contactType: UISegmentedControl!
    
    @IBOutlet weak var vw_enguiryBackView: UIView!
    @IBOutlet weak var vw_feedbackBackView: UIView!
    @IBOutlet weak var vw_requestBackView: UIView!
    
    @IBOutlet weak var lbl_enquiryDescHeading: UILabel!
    @IBOutlet weak var vw_enquiryDescBackView: UIView!
    @IBOutlet weak var lbl_enquiryDescPlaceholder: UILabel!
    @IBOutlet weak var tv_enquiryDescTV: UITextView!
    
    @IBOutlet weak var lbl_feedbackDescHeading: UILabel!
    @IBOutlet weak var vw_feedbackDescBackView: UIView!
    @IBOutlet weak var lbl_feedbackDescPlaceholder: UILabel!
    @IBOutlet weak var tv_feedbackDescTV: UITextView!
    
    @IBOutlet weak var lbl_requestDescHeading: UILabel!
    @IBOutlet weak var vw_requestDescBackView: UIView!
    @IBOutlet weak var lbl_requestDescPlaceholder: UILabel!
    @IBOutlet weak var tv_requestDescTV: UITextView!
    
    @IBOutlet weak var vw_prodTitleTFBackView: UIView!
    @IBOutlet weak var lbl_prodTitle: UILabel!
    @IBOutlet weak var tf_prodTitleTF: UITextField!
    
    @IBOutlet weak var vw_prodCategoryTFBackView: UIView!
    @IBOutlet weak var lbl_prodCategory: UILabel!
    @IBOutlet weak var tf_prodCategoryTF: UITextField!
    
    var headerTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateDefaultUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.updateUIWhenViewWillAppear()
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitContactUsAction(_ sender: UIButton) {
        switch sg_contactType.selectedSegmentIndex {
        case 0:
            print("Enguiry")
        case 1:
            print("Feedback")
        case 2:
            print("Request")
        default:
            break
        }
    }
    
}

extension ContactUsViewController {
    private func updateDefaultUI() {
        lbl_title.text = headerTitle
        
        btn_submit.backgroundColor = ConstHelper.cyan
        btn_submit.setTitleColor(ConstHelper.enableColor, for: .normal)

        sg_contactType.backgroundColor = ConstHelper.lightGray
        sg_contactType.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ConstHelper.white], for: .selected)
        self.sg_contactType.addTarget(self, action: #selector(contactTypeChanged(_:)), for: .valueChanged)
        
        self.tv_enquiryDescTV.delegate = self
        self.lbl_enquiryDescHeading.font = ConstHelper.h5Bold
        self.lbl_enquiryDescHeading.textColor = ConstHelper.gray
        self.lbl_enquiryDescPlaceholder.font = ConstHelper.h5Normal
        self.lbl_enquiryDescPlaceholder.textColor = ConstHelper.lightGray
        self.vw_enquiryDescBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        
        self.tv_feedbackDescTV.delegate = self
        self.lbl_feedbackDescHeading.font = ConstHelper.h5Bold
        self.lbl_feedbackDescHeading.textColor = ConstHelper.gray
        self.lbl_feedbackDescPlaceholder.font = ConstHelper.h5Normal
        self.lbl_feedbackDescPlaceholder.textColor = ConstHelper.lightGray
        self.vw_feedbackDescBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
            
        self.tv_requestDescTV.delegate = self
        self.lbl_requestDescHeading.font = ConstHelper.h5Bold
        self.lbl_requestDescHeading.textColor = ConstHelper.gray
        self.lbl_requestDescPlaceholder.font = ConstHelper.h5Normal
        self.lbl_requestDescPlaceholder.textColor = ConstHelper.lightGray
        self.vw_requestDescBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        
        self.lbl_prodTitle.font = ConstHelper.h5Bold
        self.lbl_prodTitle.textColor = ConstHelper.gray
        self.lbl_prodCategory.font = ConstHelper.h5Bold
        self.lbl_prodCategory.textColor = ConstHelper.gray

        self.vw_prodTitleTFBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        self.vw_prodCategoryTFBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        
        self.tf_prodTitleTF.attributedPlaceholder = NSAttributedString(string: "Title of the product", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.lightGray])
        self.tf_prodCategoryTF.attributedPlaceholder = NSAttributedString(string: "Category of the product", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.lightGray])
    }
    
    private func updateUIWhenViewWillAppear() {        
        self.visibleView(false, visibleFeedbackView: true, visibleRequestView: true)
    }
    
    @objc
    func contactTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.visibleView(false, visibleFeedbackView: true, visibleRequestView: true)
        case 1:
            self.visibleView(true, visibleFeedbackView: false, visibleRequestView: true)
        case 2:
            self.visibleView(true, visibleFeedbackView: true, visibleRequestView: false)
        default:
            self.visibleView(false, visibleFeedbackView: true, visibleRequestView: true)
        }
    }
    
    private func visibleView(_ visibleEnguiryView: Bool, visibleFeedbackView: Bool, visibleRequestView: Bool) {
        self.vw_enguiryBackView.isHidden = visibleEnguiryView
        self.vw_feedbackBackView.isHidden = visibleFeedbackView
        self.vw_requestBackView.isHidden = visibleRequestView
    }
}


//MARK: - UITextViewDelegate
extension ContactUsViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == self.tv_enquiryDescTV {
            self.lbl_enquiryDescPlaceholder.isHidden = true
        } else if textView == self.tv_feedbackDescTV {
            self.lbl_feedbackDescPlaceholder.isHidden = true
        } else if textView == self.tv_requestDescTV {
            self.lbl_requestDescPlaceholder.isHidden = true
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.tv_enquiryDescTV {
            if self.tv_enquiryDescTV.text.isEmpty {
                self.lbl_enquiryDescPlaceholder.isHidden = false
            } else {
                self.lbl_enquiryDescPlaceholder.isHidden = true
            }
        } else if textView == self.tv_feedbackDescTV {
            if self.tv_feedbackDescTV.text.isEmpty {
                self.lbl_feedbackDescPlaceholder.isHidden = false
            } else {
                self.lbl_feedbackDescPlaceholder.isHidden = true
            }
        } else if textView == self.tv_requestDescTV {
            if self.tv_requestDescTV.text.isEmpty {
                self.lbl_requestDescPlaceholder.isHidden = false
            } else {
                self.lbl_requestDescPlaceholder.isHidden = true
            }
        }
    }
}
