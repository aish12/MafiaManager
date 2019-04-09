//
//  PlayerWaitingViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/8/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class PlayerWaitingViewController: UIViewController {

    var cardName: String?
    var cardDescription: String?
    var cardImage: UIImage?
    var playerName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToCard), name: NSNotification.Name("assignCard"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func goToCard(notification: Notification){
        print("In go to card")
        DispatchQueue.main.async {
            let cardInfo = notification.userInfo!
            self.cardName = cardInfo["cardName"] as? String
            self.cardDescription = cardInfo["cardDescription"] as? String
            self.cardImage = UIImage(data: cardInfo["cardImage"] as! Data)
            self.performSegue(withIdentifier: "fromWaitingToPlayer", sender: self)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromWaitingToPlayer" {
            let destinationVC = segue.destination as! PlayerViewController
            destinationVC.cardName = cardName
            destinationVC.cardDescription = cardDescription
            destinationVC.cardImage = cardImage
        }
    }


}
