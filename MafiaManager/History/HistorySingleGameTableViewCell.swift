//
//  HistorySingleGameTableViewCell.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 4/23/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class HistorySingleGameTableViewCell: UITableViewCell {

//    var playerName: String?
//    var status: String?
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
