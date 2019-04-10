//
//  NarratorChangeRoleViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/9/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class NarratorChangeRoleViewController: UIViewController {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNameTextView: UITextView!
    @IBOutlet weak var playerStatus: UILabel!
    
    @IBOutlet weak var cardDescriptionTextView: UITextView!
    
    var cardName: String?
    var cardDescription: String?
    var cardImage: Data?
    var playerName: String?
    var playerStatusLabel : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreGraphicsHelper.shadeTextViews(textView: cardNameTextView)
        CoreGraphicsHelper.shadeTextViews(textView: cardDescriptionTextView)
        cardNameTextView.text = cardName
        cardDescriptionTextView.text = cardDescription
        cardImageView.image = UIImage(data:cardImage!)
        playerStatus.text = playerStatusLabel
        self.navigationItem.title = playerName
        // TODO: navigation bar title = playerName and set the status label
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
