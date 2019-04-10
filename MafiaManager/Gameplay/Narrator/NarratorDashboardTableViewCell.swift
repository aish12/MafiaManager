//
//  NarratorDashboardTableViewCell.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/9/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class NarratorDashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var playerStatusLabel: UILabel!
    
    var playerID: MCPeerID?
    var playerName: String?
    var playerRole: String?
    var playerStatus: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playerNameLabel.text = playerName
        roleLabel.text = playerRole
        playerStatusLabel.text = playerStatus
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
