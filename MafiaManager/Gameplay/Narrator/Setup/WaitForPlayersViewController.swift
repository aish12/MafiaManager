//
//  WaitForPlayersViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/7/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
import UIKit
import MultipeerConnectivity

class WaitForPlayersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cardQuantities: [Card: Int]?
    var connectedDevices: [MCPeerID] = []
    var numPlayers: Int = 0
    var playerAndCard: [(player: MCPeerID, card: Card)] = []
    
    @IBOutlet weak var joinedPlayersTableView: UITableView!
    
    private var mpcManager: MPCManager!
    private var appDelegate: AppDelegate!
    
    @IBOutlet weak var availableNarratorsTableView: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var numPlayersJoinedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numPlayersJoinedLabel.text = "0/\(numPlayers) joined"
        joinedPlayersTableView.delegate = self
        joinedPlayersTableView.dataSource = self
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        mpcManager = appDelegate.mpcManager!
        mpcManager.setupPeerAndSession()
        mpcManager.advertiseSelf(shouldAdvertise: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(peerDidChangeStateWithNotification), name: NSNotification.Name("MCDidChangeStateNotification"), object: nil)
        
    }
    
    @objc func peerDidChangeStateWithNotification(notification: Notification){
        let peerID: MCPeerID = notification.userInfo!["peerID"] as! MCPeerID
        let state: MCSessionState = notification.userInfo!["state"] as! MCSessionState
        if state != MCSessionState.connecting {
            if state == MCSessionState.connected {
                    connectedDevices.append(peerID)
                    if connectedDevices.count == numPlayers {
                        mpcManager.advertiseSelf(shouldAdvertise: false)
                    } else if connectedDevices.count > numPlayers {
                        mpcManager.advertiseSelf(shouldAdvertise: false)
                        mpcManager.removePeer(peerID: peerID)
                        connectedDevices.remove(at: connectedDevices.count - 1)
                    }
            } else if state == MCSessionState.notConnected {
                let deviceIndex = connectedDevices.index(of: peerID)
                if deviceIndex != nil {
                    connectedDevices.remove(at: deviceIndex!)
                    if connectedDevices.count < numPlayers && mpcManager.advertiser == nil {
                        mpcManager.advertiseSelf(shouldAdvertise: true)
                    }
                }
            }
        }
        DispatchQueue.main.async {
        self.updateNumPlayersLabel()
        self.joinedPlayersTableView.reloadData()
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        connectedDevices.shuffle()
        var playerIndex = 0
        if connectedDevices.count < numPlayers {
            let alert = UIAlertController(title: "Insufficient Number of Players", message: "Wait for all players to join before starting the game.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        for (card, count) in cardQuantities! {
            for _ in 1...count {
                setPlayerRole(peerID: connectedDevices[playerIndex],card: card)
               // Also store it in the dictionary that ties the name and the card role for narrator dashboard
                playerAndCard.append((player: connectedDevices[playerIndex], card: card))
                playerIndex += 1
                
            }
        }
        self.performSegue(withIdentifier: "fromWaitForPlayersToDashboard", sender: self)
    }
    
    func setPlayerRole(peerID: MCPeerID, card: Card){
        let playerCard: [String: Any] = ["assignCard": ["cardName": card.cardName!, "cardDescription": card.cardDescription!, "cardImage": card.cardImage!]]
        mpcManager.sendObject(objData: playerCard, peers: [peerID])
    }
    
    func updateNumPlayersLabel() {
        numPlayersJoinedLabel.text = "\(connectedDevices.count)/\(numPlayers) joined"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = joinedPlayersTableView.dequeueReusableCell(withIdentifier: "joinedPlayerCell", for: indexPath as IndexPath)
        cell.textLabel!.text = connectedDevices[indexPath.item].displayName
        return cell
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromWaitForPlayersToDashboard" {
            let destinationVC = segue.destination as! NarratorDashboardViewController
            destinationVC.playerAndCard = self.playerAndCard
        }
    }
    
}
