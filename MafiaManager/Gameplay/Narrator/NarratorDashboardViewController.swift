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
    @IBOutlet weak var timerBarButtonItem: UIBarButtonItem!
    var mpcManager: MPCManager!
    var connectedPlayers: [PlayerSession]!
    var timer = GlobalTimer.sharedTimer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if timer.isRunning(){
            if timer.timeLeft! > 30 {
                timerBarButtonItem.tintColor = self.view.tintColor
            }
            timerBarButtonItem.title = timer.timeAsString()
        } else {
            timerBarButtonItem.tintColor = self.view.tintColor
        }
        NotificationCenter.default.addObserver(self, selector: #selector(timerTick), name: NSNotification.Name("timerTick"), object: nil)
        
        narratorTableView.delegate = self
        narratorTableView.dataSource = self
        narratorTableView.reloadData()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        mpcManager = appDelegate!.mpcManager!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedPlayers.count
    }
    
    @objc func timerTick(notification: Notification) {
        let timeLeft = notification.userInfo!["timeLeft"] as! Int
        DispatchQueue.main.async {
            if timeLeft > 0 {
                if timeLeft <= 30 {
                    self.timerBarButtonItem.tintColor = UIColor.red
                } else {
                    self.timerBarButtonItem.tintColor = self.view.tintColor
                }
                self.timerBarButtonItem.title = self.timer.timeAsString()
            } else {
                self.timerBarButtonItem.title = self.timer.timeAsString()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer: Timer) in
                    self.timerBarButtonItem.tintColor = self.view.tintColor
                    self.timerBarButtonItem.title = "Timer"
                })            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = narratorTableView.dequeueReusableCell(withIdentifier: "narratorTableResultsCell", for: indexPath as IndexPath) as! NarratorDashboardTableViewCell
        let player = connectedPlayers[indexPath.item]
        cell.playerName = player.playerID.displayName
        cell.playerNameLabel.text = cell.playerName

        cell.playerID = player.playerID
        cell.roleLabel.text = player.card?.cardName
        // TODO: change to a variable for now
        cell.playerStatusLabel.text = player.isAlive ? "Alive" : "Dead"
        cell.playerStatusLabel.textColor = player.isAlive ? UIColor.green : UIColor.red

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        narratorTableView.deselectRow(at: indexPath, animated: true)
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
    
    func updatePlayerStatus(isAlive: Bool, indexPath: IndexPath) {
        connectedPlayers[indexPath.item].isAlive = isAlive
        narratorTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        mpcManager.sendObject(objData: ["assignStatus": isAlive ? "Alive" : "Dead"], peers: [connectedPlayers[indexPath.item].playerID])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromNarratorDashboardCellToPlayerCard" {
            let destinationVC = segue.destination as! NarratorDetailViewController
            
            let funcIndex = narratorTableView.indexPathForSelectedRow?.row
            destinationVC.playerSession = connectedPlayers[funcIndex!]
            destinationVC.indexPath = narratorTableView.indexPathForSelectedRow
            destinationVC.changePlayerDelegate = self
        } else if segue.identifier == "fromDashboardToRecordSegue" {
            let destinationVC = segue.destination as! RecordWinnersViewController
            destinationVC.playerAndCard = []
            destinationVC.playerStatuses = []
        }
    }
}
