//
//  NarratorDashboardViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the narrator's dashboard view controller

import UIKit
import MultipeerConnectivity

class NarratorDashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangePlayerStatusProtocol {
    

    @IBOutlet weak var narratorTableView: UITableView!
    var cardPlayer = [Dictionary<String, Card>]()
    var playerStatuses = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        narratorTableView.delegate = self
        narratorTableView.dataSource = self
        for _ in 1...cardPlayer.count {
            playerStatuses.append("Alive")
        }
        narratorTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardPlayer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = narratorTableView.dequeueReusableCell(withIdentifier: "narratorTableResultsCell", for: indexPath as IndexPath) as! NarratorDashboardTableViewCell
        cell.playerName = cardPlayer[indexPath.item].keys.first
        cell.playerNameLabel.text = cell.playerName

        let card = cardPlayer[indexPath.item].values.first
        cell.roleLabel.text = card?.cardName
        // TODO: change to a variable for now
        cell.playerStatusLabel.text = playerStatuses[indexPath.item]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        narratorTableView.deselectRow(at: indexPath, animated: true)
        // the "row"th note
        let row = indexPath.row
        print(row)
    }

    
    // If the narrator decides to end the game, display a confirmation
    // If they choose yes, segue to the record winners screen, if no, stay on dashboard
    @IBAction func endGameButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Ending a game cannot be undone", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.performSegue(withIdentifier: "fromDashboardToRecordSegue", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func updatePlayerStatus(status: String, indexPath: IndexPath) {
        playerStatuses[indexPath.item] = status;
        let cell = narratorTableView.cellForRow(at: indexPath) as! NarratorDashboardTableViewCell
        cell.playerStatus = status
        cell.playerStatusLabel.text = status
        narratorTableView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromNarratorDashboardCellToPlayerCard" {
            let destinationVC = segue.destination as! NarratorChangeRoleViewController
            
            let funcIndex = narratorTableView.indexPathForSelectedRow?.row
            let card = cardPlayer[funcIndex!].values.first
            
            destinationVC.cardName = card?.cardName
            destinationVC.cardDescription = card?.cardDescription
            destinationVC.cardImage = card?.cardImage
            destinationVC.playerName = cardPlayer[funcIndex!].keys.first
            destinationVC.playerStatusLabel = playerStatuses[funcIndex!]
            destinationVC.indexPath = narratorTableView.indexPathForSelectedRow
            destinationVC.changePlayerDelegate = self
            // TODO: do status logic
            //destinationVC.playerStatus.text = "Alive"
        } else if segue.identifier == "fromDashboardToRecordSegue" {
            print ("Ending Game")
            let destinationVC = segue.destination as! RecordWinnersViewController
            destinationVC.cardPlayer = cardPlayer
            destinationVC.playerStatuses = playerStatuses
        }
    }
}
