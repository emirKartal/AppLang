//
//  RegisterViewController.swift
//  AppLang
//
//  Created by Emir Kartal on 24.04.2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var gradientLayer: CAGradientLayer!
    var localPath: String!
    
    @IBOutlet weak var labelFirstName: UITextField!
    @IBOutlet weak var labelLastName: UITextField!
    @IBOutlet weak var labelEmail: UITextField!
    @IBOutlet weak var labelPassword: UITextField!
    @IBOutlet weak var labelGsm: UITextField!
    
    @IBOutlet weak var myImageView: UIImageView!
    
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
    
    @IBAction func buttonLogin(_ sender: Any) {
        
        performSegue(withIdentifier: "registerToLoginSegue", sender: self)
        
    }

    
    @IBAction func buttonSelectPhotoTapped(_ sender: Any) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        myImageView.image = image
        
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let imageName = "temp.jpg"
        let imagePath = documentDirectory.appendingPathComponent(imageName)
        
        if let data = UIImageJPEGRepresentation(image!, 80) {
            try? data.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
        }
        
        localPath = imagePath

        print(localPath)
        
        picker.dismiss(animated: true, completion: nil)
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func buttonRegister(_ sender: Any) {
        
        let email = labelEmail.text!
        let password = labelPassword.text!
        let firstname = labelFirstName.text!
        let lastname = labelLastName.text!
        let gsm = labelGsm.text!
        
        register(local: localPath, email: email, password: password, firstname: firstname, lastname: lastname, gsm: gsm)
        
    }
    
    func register(local: String,email: String, password: String, firstname: String, lastname:String, gsm: String ) {
        
        let parameters = [
            "FirstName": firstname,
            "LastName": lastname,
            "Email": email,
            "Gsm": gsm,
            "Password": password,
            "Gender": "0",
            
            ]
        
        let headers1 = [
            "auth-token": "1DD67360-BAE0-44F1-83F0-EF5520B12234"
            ]
        
        let url = "http://giflisozluk.com/api/v1/student"
        
        let urlImage = URL(fileURLWithPath: localPath)
        
        print("urlImage \(urlImage)")
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(urlImage, withName: "image", fileName: "temp.jpg", mimeType: "image/jpeg")
        
        for (key, val) in parameters {
            multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
        }
         print("multipart \(multipartFormData)")
            
        }, to: url, method: HTTPMethod.put, headers: headers1,
           
           encodingCompletion: { encodingResult in
            
            switch encodingResult {
                        
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let jsonResponse = response.result.value as? [String: Any] {
                            
                                let json = JSON(jsonResponse)
                                
                                print(json)
                                print(json["user"])
                                
                                let user = json["user"]
                                let status = json["status"].intValue
                                let message = json["message"].stringValue

                                
                                if status == 200
                                {
                                    //store data
                                    UserDefaults.standard.set(user["FullName"].stringValue, forKey: "userEmail")
                                    UserDefaults.standard.set(user["token"].stringValue, forKey: "userPassword")
                                    UserDefaults.standard.set(user["Image"].stringValue, forKey: "userImage")
                                    UserDefaults.standard.set(true, forKey: "isUserLoggenIn") //Bool
                                    
                                    SCLAlertView().showSuccess("Success!!", subTitle: message)
                                    
                                    //self.performSegue(withIdentifier: "homeViewSegue", sender: self)
                                    
                                    // resim secildigi anda cihaz id ile ilgili varsa update yok ise yeni uye kaydi olusturmali.
                                    
                                    
                                }else if status == 400
                                {
                                    
                                    SCLAlertView().showError("Upps!!", subTitle: message)
                                    
                                    //self.labelMessage.text = message
                                    
                                }

                            
                            }
                    }
                    case .failure(let encodingError):
                         print(encodingError)
            }
            
        })
    }
    

}
