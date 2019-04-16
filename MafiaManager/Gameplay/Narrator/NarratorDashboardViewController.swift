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
    var playerAndCard: [(player: MCPeerID, card: Card)] = []
    var playerStatuses = [String]();
    var mpcManager: MPCManager!
    var connectedPlayers: [PlayerSession]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        narratorTableView.delegate = self
        narratorTableView.dataSource = self
        for _ in 1...playerAndCard.count {
            playerStatuses.append("Alive")
        }
        narratorTableView.reloadData()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        mpcManager = appDelegate!.mpcManager!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerAndCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = narratorTableView.dequeueReusableCell(withIdentifier: "narratorTableResultsCell", for: indexPath as IndexPath) as! NarratorDashboardTableViewCell
        cell.playerName = connectedPlayers[indexPath.item].playerID.displayName
        cell.playerNameLabel.text = cell.playerName

        let card = connectedPlayers[indexPath.item].card
        cell.playerID = connectedPlayers[indexPath.item].playerID
        cell.roleLabel.text = card!.cardName
        // TODO: change to a variable for now
        cell.playerStatusLabel.text = connectedPlayers[indexPath.item].isAlive ? "Alive" : "Dead"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        narratorTableView.deselectRow(at: indexPath, animated: true)
        // the "row"th note
        let row = indexPath.row
    }

    // If the narrator decides to end the game, display a confirmation
    // If they choose yes, segue to the record winners screen, if no, stay on dashboard
    @IBAction func endGameButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Ending a game cannot be undone!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.mpcManager.endGame()
            self.performSegue(withIdentifier: "fromDashboardToRecordSegue", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func updatePlayerStatus(status: String, indexPath: IndexPath) {
        playerStatuses[indexPath.item] = status
        let cell = narratorTableView.cellForRow(at: indexPath) as! NarratorDashboardTableViewCell
        cell.playerStatus = status
        cell.playerStatusLabel.text = status
        narratorTableView.reloadData()
        
        mpcManager.sendObject(objData: ["assignStatus": status], peers: [cell.playerID!])
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromNarratorDashboardCellToPlayerCard" {
            let destinationVC = segue.destination as! NarratorChangeRoleViewController
            
            let funcIndex = narratorTableView.indexPathForSelectedRow?.row
            let card = playerAndCard[funcIndex!].card
            
            destinationVC.cardName = card.cardName
            destinationVC.cardDescription = card.cardDescription
            destinationVC.cardImage = card.cardImage
            destinationVC.playerName = playerAndCard[funcIndex!].player.displayName
            destinationVC.playerStatusLabel = playerStatuses[funcIndex!]
            destinationVC.indexPath = narratorTableView.indexPathForSelectedRow
            destinationVC.changePlayerDelegate = self
            // TODO: do status logic
            //destinationVC.playerStatus.text = "Alive"
        } else if segue.identifier == "fromDashboardToRecordSegue" {
            let destinationVC = segue.destination as! RecordWinnersViewController
            destinationVC.playerAndCard = playerAndCard
            destinationVC.playerStatuses = playerStatuses
        }
    }
}
