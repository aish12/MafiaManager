//
//  NarratorChangeRoleViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/9/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

protocol ChangePlayerStatusProtocol: class {
    func updatePlayerStatus(status:String, indexPath:IndexPath)
}
class NarratorChangeRoleViewController: UIViewController {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNameTextView: UITextView!
    @IBOutlet weak var playerStatus: UILabel!
    @IBOutlet weak var killOrReviveButton: UIButton!
    
    @IBOutlet weak var cardDescriptionTextView: UITextView!
    
    weak var changePlayerDelegate:ChangePlayerStatusProtocol?
    var cardName: String?
    var cardDescription: String?
    var cardImage: Data?
    var playerName: String?
    var playerStatusLabel : String?
    var indexPath: IndexPath? //for the delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreGraphicsHelper.shadeTextViews(textView: cardNameTextView)
        CoreGraphicsHelper.shadeTextViews(textView: cardDescriptionTextView)
        cardNameTextView.text = cardName
        cardDescriptionTextView.text = cardDescription
        cardImageView.image = UIImage(data:cardImage!)
        playerStatus.text = playerStatusLabel
        
        killOrReviveButton.layer.cornerRadius = 5
        setKillOrReviveButtonColor()
        self.navigationItem.title = playerName
    }
    
    func setKillOrReviveButtonColor() {
        if (playerStatusLabel == "Alive") {
            
            killOrReviveButton.setTitle("Kill", for: .normal)
            killOrReviveButton.layer.backgroundColor = UIColor(red: 0.8275, green: 0, blue: 0.0118, alpha: 1.0).cgColor
        } else {
            killOrReviveButton.setTitle("Revive", for: .normal)
            killOrReviveButton.layer.backgroundColor = UIColor(red: 0.0706, green: 0.7294, blue: 0, alpha: 1.0).cgColor
        }
    }
    
    @IBAction func killOrReviveButtonPressed(_ sender: Any) {
        if playerStatusLabel == "Alive" {
            playerStatusLabel = "Dead"
            playerStatus.text = "Dead"
        } else {
            playerStatusLabel = "Alive"
            playerStatus.text = "Alive"
        }
        setKillOrReviveButtonColor()
        changePlayerDelegate?.updatePlayerStatus(status: playerStatusLabel!, indexPath: indexPath!)
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
