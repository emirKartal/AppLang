//
//  ResultViewController.swift
//  AppLang
//
//  Created by Emir Kartal on 25.04.2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var questionsResult = [String:Array<Any>]()
    
    @IBOutlet weak var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultTableView.dataSource = self
        self.resultTableView.dataSource = self
        
        let nib = UINib(nibName: "ResultCell" , bundle: nil)
        resultTableView.register(nib, forCellReuseIdentifier: "resultCell")
        // Cevaplanamayan sorular listelenecek ve kullanici ister ise tekrar bu sorulara bakabilecek. 
        // Soru id listesi servisle gonderilecek. 
        // yanlis yapilan sorulari sqlite icinde tutmakta fayda var. Soru sayisi sabit deil ise total soru sayisi tutulmali 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (questionsResult["Questions"]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultCell
        
        cell.lblQuestion.text = questionsResult["Questions"]?[indexPath.row] as? String
        cell.lblSolution.text = questionsResult["Answers"]?[indexPath.row] as? String
        //cell.lblAnswer.text = questionsResult["Results"]?[indexPath.row] as? String
        if questionsResult["Answers"]?[indexPath.row] as? String != questionsResult["Results"]?[indexPath.row] as? String {
            
            cell.lblAnswer.text = questionsResult["Results"]?[indexPath.row] as? String
            
        }
    
        return cell
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
