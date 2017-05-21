//
//  RememberViewController.swift
//  AppLang
//
//  Created by cagdas on 21/05/2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView

class RememberViewController: UIViewController {

    var json:JSON = []
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var textEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observekeyboardNotifications()
        createGradientLayer()
        
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func buttonRemember(_ sender: Any) {
        
        let email = textEmail.text!
        let deviceId =  UIDevice.current.identifierForVendor!.uuidString
        print(deviceId)
        getJSON(userEmail: email, deviceId:deviceId)
        
    }
    
    @IBAction func buttonRegister(_ sender: Any) {
        
        performSegue(withIdentifier: "rememberToRegisterSegue", sender: self)
    }
    
    @IBAction func buttonLogin(_ sender: Any) {
        
        performSegue(withIdentifier: "rememberToLoginSegue", sender: self)
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
    
    func keyboardDidShow(notification:NSNotification) {
        
        // keyboard height
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height - 20
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: -keyboardHeight, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
        
    }
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RememberViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createGradientLayer() {
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:0.76, green:0.22, blue:0.39, alpha:1.0).cgColor, UIColor(red:0.11, green:0.15, blue:0.44, alpha:1.0).cgColor]
        
        gradientLayer.zPosition = -1
        self.view.layer.addSublayer(gradientLayer)
        self.view.sendSubview(toBack: self.view)
    }
    

    func getJSON(userEmail : String, deviceId: String) {
        
        let url = "http://giflisozluk.com/api/v1/student/remember"
        
        let params: Parameters = [
            "email": userEmail
        ]
        
        let headers: HTTPHeaders = [
            "auth-token": deviceId
        ]
        
        Alamofire.request(url ,method: .post ,parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    let json = JSON(data)
                    
                    //let user = json["user"]
                    let status = json["status"].intValue
                    let message = json["message"].stringValue
                    
                    UserDefaults.standard.set(status, forKey: "status")
                    
                    if status == 200
                    {
                     
                        SCLAlertView().showSuccess("Yep", subTitle: message)
                        
                    }else if status == 400
                    {
                        
                        SCLAlertView().showError("Upps!!", subTitle: message)
                        
                    }
                    
                }
                break
                
            case .failure(_):
                print(response.result.error ?? "selam")
                break
                
            }
            
        }
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
