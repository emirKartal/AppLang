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

class LoginViewController: UIViewController {

    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    var json:JSON = []
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
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
    
    @IBAction func loginButton(_ sender: Any) {
        
        let email = lblEmail.text!
        let password = lblPassword.text!
        let deviceId =  UIDevice.current.identifierForVendor!.uuidString
        print(deviceId)
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
                    
                    let text = " message \(json["message"].stringValue) , status \(json["status"].intValue)"
                    
                    print(text)
                    
                    UserDefaults.standard.set(status, forKey: "status")
                    
                    if status == 200
                    {
                        //store data
                        UserDefaults.standard.set(user["FullName"].stringValue, forKey: "userEmail")
                        UserDefaults.standard.set(user["token"].stringValue, forKey: "userPassword")
                        UserDefaults.standard.set(true, forKey: "isUserLoggenIn") //Bool
                        
                        self.performSegue(withIdentifier: "homeViewSegue", sender: self)
                        
                        
                    }else if status == 400
                    {
                        
                        self.labelMessage.text = message
                        
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
