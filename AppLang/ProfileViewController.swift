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

        //UIColor(white: 1, alpha: 0.5)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = topView.bounds
        gradientLayer.colors = [UIColor(white: 1, alpha:1.0).cgColor, UIColor(white: 1, alpha:0).cgColor]
        
        
        
        //topView.backgroundColor = UIColor(white: 10, alpha: 0.5)
    
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
