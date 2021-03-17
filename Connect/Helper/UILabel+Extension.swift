//
//  UILabel+Extension.swift
//  Connect
//
//  Created by Venkatesh Botla on 18/12/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

extension UILabel {
    
    func addUnderline(_ title: String) {
        self.attributedText = NSAttributedString(string: title, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.blue])
    }
    
    func gradientColorForLabel(firstColor: UIColor, secondColor: UIColor) {
        let gradientColor = CAGradientLayer()
        gradientColor.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientColor.locations = [0.0, 1.0]
        gradientColor.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientColor.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientColor.frame = self.bounds
        self.layer.addSublayer(gradientColor)
    }
    
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        self.attributedText = attribute
    }
    
}
