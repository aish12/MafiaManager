//
//  WaitForPlayersViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/7/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class WaitForPlayersViewController: UIViewController{
    
    
    @IBOutlet weak var playerCountLabel: UILabel!
    
    let mpcNarrator = MPCNarrator()
    var cardQuantities: [Card: Int]?
    var connections: [Int] = []
    var numPlayers: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        resetPlayerCountLabel()
        mpcNarrator.view = self as? WaitForPlayersViewController
    }
    
    func resetPlayerCountLabel(){
        playerCountLabel.text = "\(connections.count)/\(numPlayers) Players Joined"

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
