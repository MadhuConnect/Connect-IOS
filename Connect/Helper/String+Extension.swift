//
//  String+Extension.swift
//  Connect
//
//  Created by Venkatesh Botla on 25/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

extension String {
    func strikeThorughtext() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
