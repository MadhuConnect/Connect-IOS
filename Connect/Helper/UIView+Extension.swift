//
//  UIView+Extension.swift
//  Connect
//
//  Created by Venkatesh Botla on 06/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

extension UIView {
    func gradientColorForView(firstColor: UIColor, secondColor: UIColor) {
        let gradientColor = CAGradientLayer()
        gradientColor.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientColor.locations = [0.0, 1.0]
        gradientColor.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientColor.endPoint = CGPoint(x: 0.5, y: 1)
        gradientColor.frame = self.bounds
        self.layer.addSublayer(gradientColor)
    }
    
    func setBorderForView(width: CGFloat, color: UIColor, radius: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
    
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height - 4)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height - 4)
        addSubview(border)
    }
    

     func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
         layer.masksToBounds = false
         layer.shadowOffset = offset
         layer.shadowColor = color.cgColor
         layer.shadowRadius = radius
         layer.shadowOpacity = opacity

         let backgroundCGColor = backgroundColor?.cgColor
         backgroundColor = nil
         layer.backgroundColor =  backgroundCGColor
     }
    
//    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
//
//        let shadowLayer = CAShapeLayer()
//        let size = CGSize(width: cornerRadius, height: cornerRadius)
//        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
//        shadowLayer.path = cgPath //2
//        shadowLayer.fillColor = fillColor.cgColor //3
//        shadowLayer.shadowColor = shadowColor.cgColor //4
//        shadowLayer.shadowPath = cgPath
//        shadowLayer.shadowOffset = offSet //5
//        shadowLayer.shadowOpacity = opacity
//        shadowLayer.shadowRadius = shadowRadius
//        shadowLayer.masksToBounds = false
//        self.layer.addSublayer(shadowLayer)
//    }

}

extension UILabel {
    func gradientColorForLabel(firstColor: UIColor, secondColor: UIColor) {
        let gradientColor = CAGradientLayer()
        gradientColor.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientColor.locations = [0.0, 1.0]
        gradientColor.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientColor.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientColor.frame = self.bounds
        self.layer.addSublayer(gradientColor)
    }
    
}
