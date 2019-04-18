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

    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var cardNameTextView: UITextView!
    @IBOutlet weak var cardDescriptionTextView: UITextView!
    @IBOutlet weak var cardImageView: UIImageView!
    
    var cardName: String?
    var cardDescription: String?
    var cardImage: UIImage?
    var statusLabelText: String?
    var mpcManager: MPCManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreGraphicsHelper.shadeTextViews(textView: cardNameTextView)
        CoreGraphicsHelper.shadeTextViews(textView: cardDescriptionTextView)
        cardNameTextView.text = cardName!
        cardDescriptionTextView.text = cardDescription!
        cardImageView.image = cardImage!
        // Do any additional setup after loading the view.
        statusLabel.text = statusLabelText
        statusLabel.textColor = UIColor.green
        mpcManager = (UIApplication.shared.delegate as! AppDelegate).mpcManager
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatus), name: NSNotification.Name("assignStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(peerDidChangeStateWithNotification), name: NSNotification.Name("MCDidChangeStateNotification"), object: nil)

    }
    
    @objc func peerDidChangeStateWithNotification(notification: Notification){
        let peerID: MCPeerID = notification.userInfo!["peerID"] as! MCPeerID
        let state: MCSessionState = notification.userInfo!["state"] as! MCSessionState
        if peerID == self.mpcManager.narratorID && state == MCSessionState.notConnected {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Narrator has ended the game", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    self.mpcManager.close()
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    // If the player chooses the leave button, display a confirmation
    // If the player chooses yes, segue to the root controller, aka the play tab
    @IBAction func leaveButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Leaving a game cannot be undone!",         preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.mpcManager.session.disconnect()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
