//
//  DesingableTextField.swift
//  AppLang
//
//  Created by cagdas on 28/05/2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit


@IBDesignable
class DesignableTextField: UITextField {

    @IBInspectable var leftImage: UIImage? {
    
        didSet {
            updateView()
        }
        
    }

    @IBInspectable var leftPadding: CGFloat = 0 {
        
        didSet {
            updateView()
        }
        
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            layer.cornerRadius = cornerRadius
        }
        
    }
    
    @IBInspectable var imageWidth: CGFloat = 20 {
        
        didSet {
            updateView()
        }
        
    }
    
    @IBInspectable var imageHeight: CGFloat = 20 {
        
        didSet {
            updateView()
        }
        
    }
    
    func updateView() {
        
        if let image = leftImage {
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: imageWidth, height: imageHeight))
            
            imageView.image = image
            imageView.tintColor = tintColor
            
            var width = leftPadding + imageWidth
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
            
                width = width + 5
                
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: imageHeight))
            
            view.addSubview(imageView)
            
            leftView = view
            
        } else {
        
            leftViewMode = .never
        
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName: tintColor])
        
    }
}







