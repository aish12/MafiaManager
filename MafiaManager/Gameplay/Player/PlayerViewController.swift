//
//  PlayViewController.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 3/24/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the game player view controller
import UIKit
import MultipeerConnectivity

class PlayerViewController: UIViewController {

    @IBOutlet weak var playerNavBar: UINavigationItem!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var cardNameTextView: UITextView!
    @IBOutlet weak var cardDescriptionTextView: UITextView!
    @IBOutlet weak var cardImageView: UIImageView!
    
    var playerName: String?
    var cardName: String?
    var cardDescription: String?
    var cardImage: UIImage?
    var deckName: String?
    var statusLabelText: String?
    var mpcManager: MPCManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreGraphicsHelper.shadeTextViews(textView: cardNameTextView)
        CoreGraphicsHelper.shadeTextViews(textView: cardDescriptionTextView)
        playerNavBar.title = playerName
        cardNameTextView.text = cardName!
        cardDescriptionTextView.text = cardDescription!
        cardImageView.image = cardImage!
        // Do any additional setup after loading the view.
        statusLabel.text = statusLabelText
        statusLabel.textColor = UIColor.green
        mpcManager = (UIApplication.shared.delegate as! AppDelegate).mpcManager
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatus), name: NSNotification.Name("assignStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(narratorDisconnected), name: NSNotification.Name("narratorDisconnected"), object: nil)

    }
    
    @objc func narratorDisconnected(notification: Notification){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Narrator has ended the game", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.mpcManager.endGame()
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
    
    // If the player chooses the leave button, display a confirmation
    // If the player chooses yes, segue to the root controller, aka the play tab
    @IBAction func leaveButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Leaving a game cannot be undone!",         preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            NotificationCenter.default.removeObserver(self)
            self.mpcManager.endGame()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    @objc func updateStatus(notification: Notification) {
        DispatchQueue.main.async {
            let status = Array((notification.userInfo?.values)!)[0] as! String
            
            if status == "Alive" {
                self.statusLabel.textColor = UIColor.green
            } else if status == "Dead" {
                self.statusLabel.textColor = UIColor.red
            }
            self.statusLabel.text = status
        }
    }
}
