//
//  HistoryTableViewCell.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 4/23/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    var deck : Deck?
    var narrator : String?
    var winner : String?
    
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var narratorLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
