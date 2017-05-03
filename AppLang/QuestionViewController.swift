//
//  QuestionViewController.swift
//  AppLang
//
//  Created by Emir Kartal on 25.04.2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class QuestionViewController: UIViewController {

    var qId = Int()
    var json:JSON = []
    var questionArr = [String]()
    var answerArr = [String]()
    var questionNum = 0
    var wordArr = [String]()
    var wordNum = 0
    var wordCheck = String()
    
    @IBOutlet weak var QuestionLbl: UILabel!
    @IBOutlet weak var AnswerTxt: UITextField!
    @IBOutlet weak var AnswerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        getJSON()
        
        
      
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        // 
        
        let xWidth = AnswerView.frame.width;
        let yHeight = AnswerView.frame.height;
        
        var x = Double(xWidth / 20)
        var y = Double(yHeight / 10)
        
        QuestionLbl.text = questionArr[questionNum]
        
        let sentence = answerArr[questionNum]
        
        wordArr = sentence.components(separatedBy: " ")
        
        for word in wordArr {
            
            createButton(word: word, x: x , y: y)
            
            x += Double(xWidth / 3)
            if x > Double(xWidth){
                x = Double(xWidth / 20)
                y += Double(yHeight / 2)
            }
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createButton (word : String, x : Double , y : Double) {
        
        let button = UIButton(frame: CGRect(x: x, y: y, width: 80.0, height: 10.0)) // butonun genisligi cumle uzunlugu ile oran
        
        button.setTitle(word, for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        
        self.AnswerView.addSubview(button)
        
    }
    
    func btnPressed (sender: UIButton) {
        
        if wordNum == 0 {
            
            wordCheck = sender.currentTitle!
            AnswerTxt.text = wordCheck
            wordNum += 1
            sender.isHidden = true
            
        }else {
            wordCheck = "\(wordCheck) \(sender.currentTitle!)"
            AnswerTxt.text = wordCheck
            wordNum += 1
            sender.isHidden = true
        }
        
        if questionArr[questionNum] == AnswerTxt.text { // cevaplar uzerinden kontrol etmek gerekiyor...
            questionNum += 1
            print(questionNum)
        }
        
        // ceviri yanlis ise buton rengi saniyelik kirmizi olacak Ses olacak. O buton text field e yazilmayacak.
        // dogru ise ses ve saniyelik yesil 
        
    }
    
    func getJSON() {
        
        let url = "http://www.giflisozluk.com/api/v1/Question/GetAllQuestions?subcategoryId=\(qId)&fromLanguageId=1&toLanguageId=2"
        Alamofire.request(url ,method: .get ,parameters: nil, encoding: URLEncoding.default).responseJSON { response in
            
            if let data = response.result.value{
                self.json = JSON(data)
                for unit in self.json{
                    let question = unit.1["FromTitle"].string
                    let answer = unit.1["ToTitle"].string
                    self.questionArr.append(question!)
                    self.answerArr.append(answer!)
                }
                
            }else {
                print("error")
            }
            
        }
    }

}
