//
//  LoadingWelcomeViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 3/21/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the "Welcome User" View Controller

import UIKit
import Firebase

class LoadingWelcomeViewController: UIViewController {
    
    let DecksViewController = "DecksViewControllerIdentifier"
    
    @IBOutlet weak var mafiaUserImage: UIImageView!
    @IBOutlet weak var usersNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mafiaUserImage.image = UIImage(named: "WelcomeLoadingPicture")
    
        // Clear data first so theres no duplicate downloading from Firebase
        CoreDataHelper.clearAllData()
    
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! NSDictionary
            self.usersNameLabel.text = value["Name"] as? String
            
            // Check if has deck names
            if (snapshot.hasChild("decks")) {
                // it exists! So do core data logic by setting up the decks child in Firebase
                // Get a snapshot for the decks
                ref.child("users").child(userID).child("decks").observeSingleEvent(of: .value, with: { (snapshot1) in
                    let enumerator = snapshot1.children
                    var deckNameSnapshot: String = ""
                    var deckDescSnapshot: String = ""
                    var deckImageSnapshot: String = ""
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        // The deck name
                        let sub: Substring = rest.key.split(separator: ":")[1]
                        deckNameSnapshot = String(sub)
                        
                        // Go through the values and don't know which is which
                        let vals = rest.value as! NSDictionary
                        deckDescSnapshot = (vals["deckDescription"] as! String)
                        deckImageSnapshot = (vals["deckImage"] as! String)
                        let deckImageData = NSData(base64Encoded: deckImageSnapshot, options: .ignoreUnknownCharacters)
                        let newDeck = CoreDataHelper.addDeck(newName: deckNameSnapshot, newDescription: deckDescSnapshot, newImage: deckImageData! as Data)
                        
                        // Go through the cards too
                        if vals["cards"] != nil {
                            ref.child("users").child(userID).child("decks").child("deckName:\(deckNameSnapshot)").child("cards").observeSingleEvent(of: .value, with: { (snapshot2) in
                                let enumeratorCards = snapshot2.children
                                var cardNameSnapshot: String = ""
                                var cardDescSnapshot: String = ""
                                var cardImageSnapshot: String = ""
                                while let cards = enumeratorCards.nextObject() as? DataSnapshot {
                                    // The card name
                                    let subCard: Substring = cards.key.split(separator: ":")[1]
                                    print(subCard)
                                    cardNameSnapshot = String(subCard)
                                    
                                    // Go through the values and don't know which is which
                                    let cardVals = cards.value as! NSDictionary
                                    cardDescSnapshot = (cardVals["cardDescription"] as! String)
                                    cardImageSnapshot = (cardVals["cardImage"] as! String)
                                    let cardImageData = NSData(base64Encoded: cardImageSnapshot, options: .ignoreUnknownCharacters)
                                    let newCard = CoreDataHelper.addCard(deck: newDeck, newName: cardNameSnapshot, newDescription: cardDescSnapshot, newImage: cardImageData! as Data)
                                    
                                }
                            }) { (error2) in
                                print(error2.localizedDescription)
                            }
                        }
                    }
                    
                }) { (error1) in
                    print(error1.localizedDescription)
                }
            }else{
                // does not exist
            }
 
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Transitions after a few seconds to the first VC (deck management)
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "tabBarSegueIdentifier") as! TabBarViewController
            self.present(homeView, animated: true, completion: nil)
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
