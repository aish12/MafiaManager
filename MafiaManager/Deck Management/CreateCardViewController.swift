//
//  CreateCardViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for managing the card creation view controller

import UIKit
import CoreData
import CoreGraphics

class CreateCardViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var cardNameTextView: UITextView!
    @IBOutlet weak var cardDescriptionTextView: UITextView!
    @IBOutlet weak var cardImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardNameTextView.text = "Enter deck name"
        cardNameTextView.textColor = UIColor.lightGray
        cardNameTextView.becomeFirstResponder()
        cardNameTextView.selectedTextRange = cardNameTextView.textRange(from: cardNameTextView.beginningOfDocument, to: cardNameTextView.beginningOfDocument)
        cardNameTextView.delegate = self
        cardNameTextView.layer.shadowOpacity = 0.4
        cardNameTextView.layer.shadowColor = UIColor.lightGray.cgColor
        cardNameTextView.layer.shadowOffset = CGSize(width: 3, height: 3)
        cardNameTextView.layer.shadowRadius = 5
        cardNameTextView.layer.cornerRadius = 5
        cardNameTextView.layer.masksToBounds = false
        
        cardDescriptionTextView.text = "Enter deck description"
        cardDescriptionTextView.textColor = UIColor.lightGray
        cardDescriptionTextView.delegate = self
        cardDescriptionTextView.layer.shadowOpacity = 0.4
        cardDescriptionTextView.layer.shadowOffset = CGSize(width: 3, height: 3)
        cardDescriptionTextView.layer.shadowColor = UIColor.lightGray.cgColor
        cardDescriptionTextView.layer.shadowRadius = 5
        cardDescriptionTextView.layer.cornerRadius = 5
        cardDescriptionTextView.layer.masksToBounds = false
    }
    
    // When the done button is pressed, return to the previous VC,
    // the Deck Detail VC
    @IBAction func doneButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
