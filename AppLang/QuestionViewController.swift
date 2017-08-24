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
import SCLAlertView

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
    var qSound : AVPlayer!
    var soundArr = [String]()
    var results = [String]()
    var dicToResultView = [String:Array<Any>]()
    
    var score = 0
    var correctPointCount = 0
    var backButtonControl = Bool()
    
    @IBOutlet weak var QuestionLbl: UILabel!
    @IBOutlet weak var AnswerTxt: UITextField!
    @IBOutlet weak var AnswerView: UIView!
    @IBOutlet weak var labelQuestionIndex: UILabel!
    @IBOutlet weak var labelQuestionCount: UILabel!
    
    @IBOutlet weak var labelCorrectPoint: UILabel!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.isHidden = true
        
        // back butonuna art arda basilinca puan isi olmuo ona bak
        // unite 1 : 5 dogru 15 yanlis.
        
        loadData()
        
        getJSON()
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        deleteButtons()
        results.removeLast()
        
        questionNum -= 1
        
        //print(" count:  \(questionNum) totalcount: \(questionArr.count)" )
        
        if questionNum < 0
        {
            // Display alert message with confirmation.
            SCLAlertView().showNotice("Upppss!!!", subTitle: "Fazla geri gittin...")
            questionNum += 1  // bunu tekrar artirdim cunku daha sonrasinda next butonuna basinca patliyordu
            createAnswers()
            return
            
        }
        if backButtonControl {
            correctPointCount -= 1
        }
        
        loadData()
        wordNum = 0
        AnswerTxt.text = ""
        wordCheck = ""
        
        QuestionLbl.text = questionArr[questionNum]
        UIView.transition(with: AnswerView, duration: 0.4, options: [.transitionFlipFromBottom], animations: { 
            self.createAnswers()
        })
        
        
        labelQuestionIndex.text = String(questionNum + 1)
        
    }
    
    @IBAction func btnReset(_ sender: UIButton) {
        
        deleteButtons()
        wordNum = 0
        AnswerTxt.text = ""
        wordCheck = ""
        createAnswers()
        
    }

    @IBAction func btnHome(_ sender: Any) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        performSegue(withIdentifier: "toHomeBack", sender: nil)
        
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
        
        if questionNum + 1 == questionArr.count{
            
            results.append(AnswerTxt.text!)
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton : false
            )
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("Results", action: {
                self.dicToResultView = ["Questions" : self.questionArr , "Answers" : self.answerArr , "Results" : self.results]
                self.performSegue(withIdentifier: "toResultView", sender: self.dicToResultView)
            })
            
            alertView.addButton("Home", action: {
                self.btnHome(self)
            })
            
            alertView.addButton("Next Unit", action: {
                //self.performSegue(withIdentifier: "toResultView", sender: nil)
            })
            
            alertView.showSuccess("Bravooo!!!", subTitle: "Your score is \(score)")
            
            /*if answerArr[questionNum] != AnswerTxt.text{
             SCLAlertView().showError("Uppsssss!!!", subTitle: "Dogrusu : \(answerArr[questionNum])  Cevabin :\(AnswerTxt.text!)")
             }*/
            
            return
            
        }

    
        if answerArr[questionNum] == AnswerTxt.text {
            
            deleteButtons()
            correctPointCount  = correctPointCount + 1
            backButtonControl = true
            
        }else {
           
            //SCLAlertView().showError("Uppsssss!!!", subTitle: "Dogrusu : \(answerArr[questionNum])  Cevabin :\(AnswerTxt.text!)")
            backButtonControl = false
            deleteButtons()
            
        }
        
        if correctPointCount % 5 == 0 && correctPointCount != 0 {
            
            SCLAlertView().showSuccess("Run Forrest Run :))", subTitle: "Pes pese 5 soru dogru...")
            correctPointCount = 0 
            
        }
        
        questionNum += 1
        labelQuestionIndex.text = String(questionNum + 1)
        
        wordNum = 0
        results.append(AnswerTxt.text!)
        AnswerTxt.text = ""
        wordCheck = ""
        QuestionLbl.text = questionArr[questionNum]
        UIView.transition(with: AnswerView, duration: 0.4, options: [.transitionFlipFromTop], animations: { 
            self.createAnswers()
        })
        
        loadData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultView" {
            
            if let viewCont = segue.destination as? ResultViewController {
                
                viewCont.questionsResult = sender as! [String:Array<Any>]
               
            }
        }
    }
    
    @IBAction func btnSound(_ sender: Any) {
        
        let url = URL(string: "http://management.giflisozluk.com\(soundArr[questionNum])")
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        qSound = AVPlayer(playerItem: playerItem)
        
        qSound.play()
        
    }
    
    func loadData() {
    
        score = correctPointCount * 5
        labelCorrectPoint.text = String(score)
       
        
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
            
            //controlWords(btn: sender)
            buttonBackgroundChangeByStatus(btn: sender, status: true)
            wordNum += 1
            
        }else {
            
            wordCheck = "\(wordCheck) \(sender.currentTitle!)"
            AnswerTxt.text = wordCheck
            //sender.isHidden = true
            
            //controlWords(btn: sender)
            buttonBackgroundChangeByStatus(btn: sender, status: true)
            wordNum += 1
            
            
        }
        
    }
    
    func createAnswers() {
        
        let xWidth = AnswerView.frame.width
        let yHeight = AnswerView.frame.height
        
        var x = Double(xWidth / 20)
        var y = Double(yHeight / 20)
        
        let sentence = answerArr[questionNum]
        
        wordArr = sentence.components(separatedBy: " ")
        wordArr.shuffle()
        
        for word in wordArr {
            
            createButton(word: word, x: x , y: y)
            
            x += Double(xWidth / 3)
            if x > Double(xWidth){
                x = Double(xWidth / 20)
                y += Double(yHeight / 8)
            }
            
        }
    
    }
    
    /*func controlWords(btn : UIButton) {
        
        let controlSentence = answerArr[questionNum]
        
        controlWordArr = controlSentence.components(separatedBy: " ")
        
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

    }*/
    
    func deleteButtons () {
    
        let subviews = AnswerView.subviews
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
    
    }
    
    func buttonBackgroundChangeByStatus(btn : UIButton, status : Bool) {
        /*
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
            
            correctPointCount  = 0
            
        }*/
        playSound(status: true)
        
        UIView.animate(withDuration: 0.5, animations: {
            btn.layer.backgroundColor = UIColor.green.cgColor
        }, completion: {(finished:Bool) in
            btn.isHidden = true
        })

        
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
                    let soundPath = unit.1["ToVoice"].string
                    self.questionArr.append(question!)
                    self.answerArr.append(answer!)
                    self.soundArr.append(soundPath!)
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


