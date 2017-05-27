//
//  ProfileViewController.swift
//  AppLang
//
//  Created by cagdas on 26/05/2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        corderRadius(imageView: profileImageButton)
        
    }

    func corderRadius(imageView: UIButton){
    
        imageView.layer.cornerRadius = profileImageButton.frame.width / 2;
        imageView.layer.borderWidth = 2.0;
        imageView.layer.masksToBounds = true

        
        //topView.accessibilityPath = doYourPath

        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:0.76, green:0.22, blue:0.39, alpha:1.0).cgColor, UIColor(red:0.11, green:0.15, blue:0.44, alpha:1.0).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 50, y: 50)
        gradientLayer.endPoint = CGPoint(x: 300, y: 300)

        //self.view.layer.addSublayer(gradientLayer)
        //self.view.sendSubview(toBack: self.view)
        
        
    }
    

    
    @IBAction func profileImageButton(_ sender: Any) {
        
        
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
