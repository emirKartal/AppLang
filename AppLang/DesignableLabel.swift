//
//  DesignableLabel.swift
//  AppLang
//
//  Created by cagdas on 04/06/2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableLabel: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
