//
//  CardViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/5/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import CoreData

class CardViewController: UIViewController {

    var cardObject: NSManagedObject = NSManagedObject()
    @IBOutlet weak var cardName: UITextView!
    @IBOutlet weak var cardDescription: UITextView!
    @IBOutlet weak var cardImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cardName.text = cardObject.value(forKey: "cardName") as? String
        self.cardDescription.text = cardObject.value(forKey: "cardDescription") as? String
        self.cardImage.image = UIImage(data: cardObject.value(forKey: "cardImage") as! Data)
        
        cardName.text = cardObject.value(forKey: "cardName") as? String
        //editDeckNameTextView.textColor = UIColor.lightGray
        cardName.becomeFirstResponder()
        cardName.selectedTextRange = cardName.textRange(from: cardName.endOfDocument, to: cardName.endOfDocument)
        //cardName.delegate = self
        cardName.layer.shadowOpacity = 0.4
        cardName.layer.shadowColor = UIColor.lightGray.cgColor
        cardName.layer.shadowOffset = CGSize(width: 3, height: 3)
        cardName.layer.shadowRadius = 5
        cardName.layer.cornerRadius = 5
        cardName.layer.masksToBounds = false
        
        cardDescription.text = cardObject.value(forKey: "cardDescription") as? String
        //editDeckDescriptionTextView.textColor = UIColor.lightGray
        //cardDescription.delegate = self
        cardDescription.layer.shadowOpacity = 0.4
        cardDescription.layer.shadowOffset = CGSize(width: 3, height: 3)
        cardDescription.layer.shadowColor = UIColor.lightGray.cgColor
        cardDescription.layer.shadowRadius = 5
        cardDescription.layer.cornerRadius = 5
        cardDescription.layer.masksToBounds = false
    }

    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        cardDescription.isEditable = true
        cardDescription.isSelectable = true
        cardName.isEditable = true
        cardName.isSelectable = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endEditState))
    }
    
    @objc func endEditState() {
        cardDescription.isEditable = false
        cardDescription.isSelectable = false
        cardName.isEditable = false
        cardName.isSelectable = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
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
