//
//  HomeViewController.swift
//  AppLang
//
//  Created by Emir Kartal on 2.05.2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    var json:JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Do any additional setup after loading the view.
        
        //let data = UserDefaults.standard.string(forKey: "jsonUser")!
        
        //let json = JSON(data)
        
        //print(json["user"])
        //print(json)
        
        // popover koyulaak dil secenekleri,
        // from id, to id, userdefault atilacak. 
        // TODO:
        
        
        let url = UserDefaults.standard.string(forKey: "userImage")!
        print(String(describing: url))
        get_image("http://management.giflisozluk.com\(String(describing: url))", _imageView: profileImageView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonStartGame(_ sender: Any) {
        
         self.performSegue(withIdentifier: "menuViewSegue", sender: self)
        
    }
    
    @IBAction func buttonRegister(_ sender: Any) {
        
        //self.performSegue(withIdentifier: "rememberToRegisterSegue", sender: self)
        
    }
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func get_image(_ url_str: String, _imageView: UIImageView){
    
        let url:URL = URL(string: url_str)!
        let nsUrl = NSString(string: url_str)
        
        if let imageFromCache = imageCache.object(forKey: nsUrl) {
        
            _imageView.image = imageFromCache
            print("return")
            return
        }
        
        print("return degil")
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error ) in
            
            if data != nil
            {
                let image = UIImage(data: data!)
                if (image != nil)
                {
                    DispatchQueue.main.async(execute: {
                        
                        self.imageCache.setObject(image!, forKey: nsUrl)
                        
                        _imageView.image = image
                    })
                }
            }
            
        }
        
        task.resume()
        
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
