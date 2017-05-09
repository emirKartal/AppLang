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
import AVFoundation

class QuestionViewController: UIViewController {

    var qId = Int()
    var json:JSON = []
    var questionArr = [String]()
    var answerArr = [String]()
    var questionNum = 0
    var wordArr = [String]()
    var wordNum = 0
    var wordCheck = String()
    var controlWordArr = [String]()
    var bombSoundEffect: AVAudioPlayer!
    
    @IBOutlet weak var QuestionLbl: UILabel!
    @IBOutlet weak var AnswerTxt: UITextField!
    @IBOutlet weak var AnswerView: UIView!
    @IBOutlet weak var labelQuestionIndex: UILabel!
    @IBOutlet weak var labelQuestionCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        getJSON()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        
       self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        deleteButtons()
        
        questionNum -= 1
        
        //print(" count:  \(questionNum) totalcount: \(questionArr.count)" )
        
        if questionNum < 0
        {
            // Display alert message with confirmation.
            let myAlert = UIAlertController(title:"Alert", message:"Sorular bitti", preferredStyle: UIAlertControllerStyle.alert);
            
            let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default){ action in
                self.dismiss(animated: true, completion:nil);
            }
            
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion:nil);
            
            return
            
        }
        
        wordNum = 0
        AnswerTxt.text = ""
        wordCheck = ""
        
        QuestionLbl.text = questionArr[questionNum]
        createAnswers()
        
        labelQuestionIndex.text = String(questionNum)
        labelQuestionCount.text = String(questionArr.count)

        
    }
    
    @IBAction func btnPass(_ sender: Any) {
        
        deleteButtons()
        
        questionNum += 1
        
        if Int(labelQuestionIndex.text!) == questionArr.count
        {
            // Display alert message with confirmation.
            let myAlert = UIAlertController(title:"Alert", message:"Sorular bitti", preferredStyle: UIAlertControllerStyle.alert);
            
            let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default){ action in
                self.dismiss(animated: true, completion:nil);
            }
            
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion:nil);
            
            return
            
        }
        
        wordNum = 0
        AnswerTxt.text = ""
        wordCheck = ""
        
        QuestionLbl.text = questionArr[questionNum]
        createAnswers()
        
        labelQuestionIndex.text = String(questionNum + 1)
        labelQuestionCount.text = String(questionArr.count)

        
    }
    
    @IBAction func btnHome(_ sender: Any) {
        
        performSegue(withIdentifier: "toHomeBack", sender: self)
        
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
        
        if answerArr[questionNum] == AnswerTxt.text {
            questionNum += 1
            
            if Int(labelQuestionIndex.text!) == questionArr.count
            {
                // Display alert message with confirmation.
                let myAlert = UIAlertController(title:"Alert", message:"Sorular bitti", preferredStyle: UIAlertControllerStyle.alert);
                
                let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default){ action in
                    self.dismiss(animated: true, completion:nil);
                }
                
                myAlert.addAction(okAction);
                self.present(myAlert, animated:true, completion:nil);
                
                return
                
            }
            
            wordNum = 0
            AnswerTxt.text = ""
            wordCheck = ""
            QuestionLbl.text = questionArr[questionNum]
            createAnswers()
            
            labelQuestionIndex.text = String(questionNum + 1)
            labelQuestionCount.text = String(questionArr.count)
            
        }else {
        
            // Display alert message with confirmation.
            let myAlert = UIAlertController(title:"Alert", message:"Yanlis cevap", preferredStyle: UIAlertControllerStyle.alert);
            
            let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default){ action in
                self.dismiss(animated: true, completion:nil);
            }
            
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion:nil);
            
            return

        
        }

    }
    
    func createButton (word : String, x : Double , y : Double) {
        
        
        let originalString: String = word
        let myString: NSString = originalString as NSString
        let sizeWord: CGSize = myString.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18.0)])
        
    
        let buttonWidth = Double(sizeWord.width) > 80 ? Double(sizeWord.width) + 6 : 80
        
        let button = UIButton(frame: CGRect(x: x, y: y, width: buttonWidth, height: 30)) // butonun genisligi cumle uzunlugu ile oran
        
        button.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0).cgColor
        button.setTitle(word, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        
        self.AnswerView.addSubview(button)
        
    }
    
    func btnPressed (sender: UIButton) {
        
        if wordNum == 0 {
            
            wordCheck = sender.currentTitle!
            AnswerTxt.text = wordCheck
            //sender.isHidden = true
            
            controlWords(btn: sender)
            wordNum += 1
            
        }else {
            
            wordCheck = "\(wordCheck) \(sender.currentTitle!)"
            AnswerTxt.text = wordCheck
            //sender.isHidden = true
            
            controlWords(btn: sender)
            wordNum += 1
            
            
        }
        
        // ceviri yanlis ise buton rengi saniyelik kirmizi olacak Ses olacak. O buton text field e yazilmayacak.
        // dogru ise ses ve saniyelik yesil 
        
    }
    
    func createAnswers() {
        
        let xWidth = AnswerView.frame.width
        let yHeight = AnswerView.frame.height
        
        var x = Double(xWidth / 20)
        var y = Double(yHeight / 10)
        
        let sentence = answerArr[questionNum]
        
        wordArr = sentence.components(separatedBy: " ")
        wordArr.shuffle()
        
        for word in wordArr {
            
            createButton(word: word, x: x , y: y)
            
            x += Double(xWidth / 3)
            if x > Double(xWidth){
                x = Double(xWidth / 20)
                y += Double(yHeight / 4)
            }
            
        }
    
    }
    
    func controlWords(btn : UIButton) {
        
        let controlSentence = answerArr[questionNum]
        
        print(" controlSentence:  \(controlSentence)" )
        
        controlWordArr = controlSentence.components(separatedBy: " ")
        
        print(" controlWordArr:  \(controlWordArr)" )
        
        print(" btn.currentTitle:  \(btn.currentTitle!)" )
        
        print(" controlWordArr[wordNum]:  \(controlWordArr[wordNum])" )
        
        if controlWordArr[wordNum] != btn.currentTitle! {
           
            if wordNum == 0 {
                
                wordCheck = ""
                wordNum -= 1
                
                buttonBackgroundChangeByStatus(btn: btn, status: false)
                
                
            }else {
            
                wordCheck = wordCheck.replacingOccurrences(of: " \(btn.currentTitle!)", with: "")
                wordNum -= 1
                
                buttonBackgroundChangeByStatus(btn: btn, status: false)
                
            }
            
        }else {
        
            buttonBackgroundChangeByStatus(btn: btn, status: true)
            
        }

    }
    
    func deleteButtons () {
    
        let subviews = AnswerView.subviews
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
    
    }
    
    func buttonBackgroundChangeByStatus(btn : UIButton, status : Bool) {
        
        if status
        {
            playSound(status: true)
            
            UIView.animate(withDuration: 0.5, animations: {
                btn.layer.backgroundColor = UIColor.green.cgColor
            }, completion: {(finished:Bool) in
                btn.isHidden = true
            })
            
        }else {
        
            playSound(status: false)
            
            UIView.animate(withDuration: 1.0, animations: {
                btn.layer.backgroundColor = UIColor.red.cgColor
            }, completion: {(finished:Bool) in
                btn.isHidden = false
            })
            
            UIView.animate(withDuration: 1.0, animations: {
                btn.layer.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
            })
            
        }
        
    }
    
    //MARK:- PLAY SOUND
    func playSound(status : Bool) {
        
        let path:String;
        
        if status
        {
            path = Bundle.main.path(forResource: "correct", ofType:"wav")!
        }
        else{
            path = Bundle.main.path(forResource: "incorrect", ofType:"wav")!
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect = sound
            sound.play()
        } catch {
            print("error.description")
        }
        
    }
    
    func getJSON() {
        
        let url = "http://www.giflisozluk.com/api/v1/Question/GetAllQuestions?subcategoryId=\(qId)&fromLanguageId=2&toLanguageId=1"
        Alamofire.request(url ,method: .get ,parameters: nil, encoding: URLEncoding.default).responseJSON { response in
            
            if let data = response.result.value{
                self.json = JSON(data)
                for unit in self.json{
                    let question = unit.1["FromTitle"].string
                    let answer = unit.1["ToTitle"].string
                    self.questionArr.append(question!)
                    self.answerArr.append(answer!)
                }
                
                switch(response.result) {
                case .success(_):
                    
                    self.QuestionLbl.text = self.questionArr[self.questionNum]
                    self.createAnswers()
                    
                    self.labelQuestionIndex.text = String(self.questionNum + 1)
                    self.labelQuestionCount.text = String(self.questionArr.count)
                    
                    break
                case .failure(_):
                    //print(response.result.error)
                    break
                    
                }
                
                
                
                
            }else {
                print("error")
            }
            
        }
    }

}

extension Array
{
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}


