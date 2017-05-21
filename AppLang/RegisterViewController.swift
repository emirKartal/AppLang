//
//  RegisterViewController.swift
//  AppLang
//
//  Created by Emir Kartal on 24.04.2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    var gradientLayer: CAGradientLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observekeyboardNotifications()
        createGradientLayer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createGradientLayer() {
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:0.76, green:0.22, blue:0.39, alpha:1.0).cgColor, UIColor(red:0.11, green:0.15, blue:0.44, alpha:1.0).cgColor]
        
        gradientLayer.zPosition = -1
        self.view.layer.addSublayer(gradientLayer)
        self.view.sendSubview(toBack: self.view)
    }

    fileprivate func observekeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        
    }
    
    func keyboardDidHide() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
        
    }
    
    func keyboardDidShow() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: -300, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
        
    }
    
    @IBAction func buttonLogin(_ sender: Any) {
        
        performSegue(withIdentifier: "registerToLoginSegue", sender: self)
        
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
