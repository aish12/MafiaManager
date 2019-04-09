//
//  PlayViewController.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 3/24/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the game player view controller
import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var cardNameTextView: UITextView!
    @IBOutlet weak var cardDescriptionTextView: UITextView!
    @IBOutlet weak var cardImageView: UIImageView!
    
    var cardName: String?
    var cardDescription: String?
    var cardImage: UIImage?
    var statusLabelText: String?
    
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
    }
    
    // If the player chooses the leave button, display a confirmation
    // If the player chooses yes, segue to the root controller, aka the play tab
    @IBAction func leaveButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Leaving a game cannot be undone",         preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
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
