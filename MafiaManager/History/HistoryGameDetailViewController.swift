//
//  HistoryGameDetailViewController.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 4/23/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class HistoryGameDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var historyGameTableView: UITableView!
    var otherPlayers: [PlayerSession]!
    var deckName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyGameTableView.delegate = self
        historyGameTableView.dataSource = self
        // Do any additional setup after loading the view.
        self.navigationItem.title = deckName
        
        // From Firebase get the information
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyGameTableView.dequeueReusableCell(withIdentifier: "historySingleGameTableResultsCell", for: indexPath as IndexPath) as! HistorySingleGameTableViewCell
       
        
        
        
        
            cell.playerNameLabel.text = "Player"
            cell.statusLabel.text = "Dead"
            cell.statusLabel.textColor = UIColor.red
    
        return cell
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
