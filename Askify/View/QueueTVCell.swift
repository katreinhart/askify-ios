//
//  QueueTVCell.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

class QueueTVCell: UITableViewCell {

    @IBOutlet weak var queuePosition: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func answerButtonPressed(_ sender: Any) {
    }
}
