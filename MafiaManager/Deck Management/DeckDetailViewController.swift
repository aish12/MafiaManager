//
//  DeckDetailViewController.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for managing the Deck Detail View Controller
import UIKit
import CoreData

class DeckDetailViewController: UIViewController {

    var deckObject: NSManagedObject = NSManagedObject()
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var deckDetailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbar.title = deckObject.value(forKey: "deckName") as? String
        deckDetailTextView.text = deckObject.value(forKey: "deckDescription") as? String
        // Do any additional setup after loading the view.
    }
    
    // When the Add Card button is pressed, show an action sheet with the options to
    // create a new card, copy an existing card, or cancel
    // Upon selecting new or existing card, segue to the new card or existing card selection views
    @IBAction func addCardButtonPressed(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let createAction = UIAlertAction(title: "Create a New Card", style: .default) { (action) in
            self.performSegue(withIdentifier: "fromDetailToNewCardSegue", sender: nil)
        }
        
        let copyAction = UIAlertAction(title: "Copy Existing Card", style: .default) { (action) in
            self.performSegue(withIdentifier: "fromDetailToCopyCardSegue", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(createAction)
        optionMenu.addAction(copyAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
}
