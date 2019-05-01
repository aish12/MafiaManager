//
//  RecordWinnersViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the record winner's view controller

import UIKit
import MultipeerConnectivity
import Firebase

class RecordWinnersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recordResultsTableView: UITableView!
    var gameTime: String?
    var deckName: String?
    var players: [PlayerSession]!

    override func viewDidLoad() {
        super.viewDidLoad()
        recordResultsTableView.delegate = self
        recordResultsTableView.dataSource = self
        recordResultsTableView.reloadData()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        ref.child("users").child(userID).child("games").child("\(self.deckName!) = \(self.gameTime!)").child("players")
    }
    
    // If they do not want to record winners, return back to play tab screen
    @IBAction func skipButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
        // Save in firebase the status of each player
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        
        for player in players {
            let name = player.playerID.displayName
            let winnerOrNot: String?
            if player.isWinner {
                winnerOrNot = "Winner"
            } else if player.isAlive {
                winnerOrNot = "Alive"
            } else {
                winnerOrNot = "Dead"
            }
            ref.child("users").child(userID).child("games").child("\(self.deckName!) = \(self.gameTime!)").child("players").updateChildValues([name : winnerOrNot!])
        }
    }
    
    // If they have recorded winners, return back to play tab screen
    @IBAction func recordResultsButtonPressed(_ sender: Any) {
        //self.navigationController?.popToRootViewController(animated: true)
        
        // Save in firebase the status of each player
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        
        for player in players {
            let name = player.playerID.displayName
            let winnerOrNot: String?
            if player.isWinner {
                winnerOrNot = "Winner"
            } else if player.isAlive {
                winnerOrNot = "Alive"
            } else {
                winnerOrNot = "Dead"
            }
            ref.child("users").child(userID).child("games").child("\(self.deckName!) = \(self.gameTime!)").child("players").updateChildValues([name : winnerOrNot!])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return players.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordResultsTableView.dequeueReusableCell(withIdentifier: "recordResultsTableCell", for: indexPath as IndexPath)
        let player = players[indexPath.item]
        cell.textLabel!.text = player.playerID.displayName
        cell.detailTextLabel!.text = "\(player.card.cardName!) \u{2022} \(player.isAlive ? "Alive": "Dead")"
        if player.isAlive {
            cell.detailTextLabel?.textColor = CoreGraphicsHelper.greenColor
        } else {
            cell.detailTextLabel?.textColor = CoreGraphicsHelper.redColor
        }
        if player.isWinner {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recordResultsTableView.deselectRow(at: indexPath, animated: true)
        let cell = recordResultsTableView.dequeueReusableCell(withIdentifier: "recordResultsTableCell", for: indexPath as IndexPath)
        players[indexPath.item].isWinner = !players[indexPath.item].isWinner
        if players[indexPath.item].isWinner {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        recordResultsTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "recordToHistory" {
            if let destinationVC = segue.destination as? HistoryViewController {
            }
        }
        
    }

}
