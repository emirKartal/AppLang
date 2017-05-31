//
//  LoginViewController.swift
//  AppLang
//
//  Created by Emir Kartal on 24.04.2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView

class LoginViewController: UIViewController {

    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    var json:JSON = []
    
    var gradientLayer: CAGradientLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deviceId = UserDefaults.standard.string(forKey: "deviceId")!
        print(deviceId)
        
        // beni hatirla dedigi zaman bu islemi yap.
        //UserDefaults.standard.set(json, forKey: "userJson")
        
        getUserByToken(token: deviceId)
        
        observekeyboardNotifications()
        createGradientLayer()
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
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
    
    @IBAction func loginButton(_ sender: Any) {
        
        let email = lblEmail.text!
        let password = lblPassword.text!
        let deviceId = UserDefaults.standard.string(forKey: "deviceId")!
        
        if email.isEmpty || password.isEmpty {
            
            SCLAlertView().showError("Upps!!", subTitle: "Email ve Sifre giriniz.")
            return
        }
        
        getJSON(userPassword: password, userEmail: email, deviceId:deviceId)
        
        
    }

    func getJSON(userPassword : String, userEmail : String, deviceId: String) {
        
        let url = "http://giflisozluk.com/api/v1/student/login"
        
        let params: Parameters = [
            "Password": userPassword,
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
                    
                    print(json)
                    print(json["user"])
                    
                    let user = json["user"]
                    let status = json["status"].intValue
                    let message = json["message"].stringValue
                    
                    UserDefaults.standard.set(status, forKey: "status")
                    
                    if status == 200
                    {
                        //store data
                        UserDefaults.standard.set(user["FullName"].stringValue, forKey: "userEmail")
                        UserDefaults.standard.set(user["token"].stringValue, forKey: "userPassword")
                        UserDefaults.standard.set(user["Image"].stringValue, forKey: "userImage")
                        UserDefaults.standard.set(true, forKey: "isUserLoggenIn") //Bool
                        
                        //UserDefaults.standard.set(json, forKey: "userJson")
                        
                        //let datasss = UserDefaults.standard.object(forKey: "userJson") as? JSON
                        //print(datasss)
                        
                       self.performSegue(withIdentifier: "homeViewSegue", sender: self)
                        
                        
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
    
    func getUserByToken(token : String) {
        
        let url = "http://giflisozluk.com/api/v1/student"
        
        let params: Parameters = [
            "password": "",
            "email": ""
        ]
        
        let headers: HTTPHeaders = [
            "auth-token": token
        ]
        
        Alamofire.request(url ,method: .get ,parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    let json = JSON(data)
                    
                    print(json)
                    print(json["user"])
                    
                    let user = json["user"]
                    let status = json["status"].intValue
                    let message = json["message"].stringValue
                    
                    UserDefaults.standard.set(status, forKey: "status")
                    //UserDefaults.standard.set(json, forKey: "jsonUser")
                    
                    if status == 200
                    {
                        //store data
                        UserDefaults.standard.set(user["FullName"].stringValue, forKey: "userEmail")
                        UserDefaults.standard.set(user["token"].stringValue, forKey: "userPassword")
                        UserDefaults.standard.set(user["Image"].stringValue, forKey: "userImage")
                        UserDefaults.standard.set(true, forKey: "isUserLoggenIn") //Bool
                        
                        self.performSegue(withIdentifier: "homeViewSegue", sender: self)
                        
                        
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

    
    @IBAction func buttonLoginRemember(_ sender: Any) {
        
        self.performSegue(withIdentifier: "loginToRememberSegue", sender: self)
        
    }
    
    @IBAction func buttonRegister(_ sender: Any) {
        
        self.performSegue(withIdentifier: "loginToRegister", sender: self)
        
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
