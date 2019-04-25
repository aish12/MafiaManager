//
//  PlayerWaitingViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/8/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class PlayerWaitingViewController: UIViewController {

    var playerName: String?
    var cardName: String?
    var cardDescription: String?
    var cardImage: UIImage?
    var deckName: String?
    var statusText: String?
    var gameTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToCard), name: NSNotification.Name("assignCard"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func goToCard(notification: Notification){
        DispatchQueue.main.async {
            let cardInfo = notification.userInfo!["assignCard"] as! [String: Any]
            self.playerName = cardInfo["playerName"] as? String
            self.cardName = cardInfo["cardName"] as? String
            self.cardDescription = cardInfo["cardDescription"] as? String
            self.cardImage = UIImage(data: cardInfo["cardImage"] as! Data)
            self.deckName = cardInfo["deckName"] as? String
            self.gameTime = cardInfo["gameTime"] as? String
            self.performSegue(withIdentifier: "fromWaitingToPlayer", sender: self)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromWaitingToPlayer" {
            let destinationVC = segue.destination as! PlayerViewController
            destinationVC.playerName = playerName
            destinationVC.cardName = cardName
            destinationVC.cardDescription = cardDescription
            destinationVC.cardImage = cardImage
            destinationVC.deckName = deckName
            destinationVC.gameTime = gameTime
            destinationVC.statusLabelText = "Alive"
        }
    }

}
