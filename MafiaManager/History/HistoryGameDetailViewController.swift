//
//  HistoryGameDetailViewController.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 4/23/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class HistoryGameDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var historyGameTableView: UITableView!
    var winnerName: String?
    var otherPlayers: [String] = ["Bob", "Jim", "Alice"];

    override func viewDidLoad() {
        super.viewDidLoad()

        historyGameTableView.delegate = self
        historyGameTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherPlayers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyGameTableView.dequeueReusableCell(withIdentifier: "historySingleGameTableResultsCell", for: indexPath as IndexPath) as! HistorySingleGameTableViewCell
        if (indexPath.row == 0) {
            cell.playerName = winnerName
            cell.status = "Winner"
            cell.playerNameLabel.text = winnerName
            cell.statusLabel.text = "Winner"
            cell.statusLabel.textColor = UIColor.green
        } else {
            cell.playerName = otherPlayers[indexPath.row - 1]
            cell.status = "Dead"
            cell.playerNameLabel.text = otherPlayers[indexPath.row - 1]
            cell.statusLabel.text = "Dead"
            cell.statusLabel.textColor = UIColor.red
        }
        
        
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
