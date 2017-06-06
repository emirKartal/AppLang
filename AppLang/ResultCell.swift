//
//  ResultCell.swift
//  AppLang
//
//  Created by Emir Kartal on 6.06.2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var lblSolution: UILabel!
    
    @IBOutlet weak var lblAnswer: UILabel!
    
    @IBOutlet weak var imgResult: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
