//
//  NarratorDetailViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/9/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

protocol ChangePlayerStatusProtocol: class {
    func updatePlayerStatus(isAlive: Bool, indexPath:IndexPath)
}
class NarratorDetailViewController: UIViewController {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNameTextView: UITextView!
    @IBOutlet weak var playerStatus: UILabel!
    @IBOutlet weak var killOrReviveButton: UIButton!
    @IBOutlet weak var cardDescriptionTextView: UITextView!
    
    var playerSession: PlayerSession!
    weak var changePlayerDelegate:ChangePlayerStatusProtocol?
    var indexPath: IndexPath? //for the delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardImageView.image = UIImage(data: playerSession.card.cardImage!)
        cardNameTextView.text = playerSession.card.cardName
        playerStatus.text = playerSession.isAlive ? "Alive" : "Dead"
        playerStatus.textColor = playerSession.isAlive ? UIColor.green : UIColor.red
        cardDescriptionTextView.text = playerSession.card.cardDescription
        
        CoreGraphicsHelper.shadeTextViews(textView: cardNameTextView)
        CoreGraphicsHelper.shadeTextViews(textView: cardDescriptionTextView)
        
        killOrReviveButton.layer.cornerRadius = 5
        setKillOrReviveButtonColor()
        self.navigationItem.title = playerSession.playerID.displayName
    }
    
    func setKillOrReviveButtonColor() {
        if (playerSession.isAlive) {
            killOrReviveButton.setTitle("Kill", for: .normal)
            killOrReviveButton.layer.backgroundColor = UIColor(red: 0.8275, green: 0, blue: 0.0118, alpha: 1.0).cgColor
        } else {
            killOrReviveButton.setTitle("Revive", for: .normal)
            killOrReviveButton.layer.backgroundColor = UIColor(red: 0.0706, green: 0.7294, blue: 0, alpha: 1.0).cgColor
        }
    }
    
    @IBAction func killOrReviveButtonPressed(_ sender: Any) {
        playerSession.isAlive = !playerSession.isAlive
        playerStatus.text = playerSession.isAlive ? "Alive" : "Dead"
        playerStatus.textColor = playerSession.isAlive ? UIColor.green : UIColor.red
        setKillOrReviveButtonColor()
        changePlayerDelegate?.updatePlayerStatus(isAlive: playerSession!.isAlive, indexPath: indexPath!)
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
