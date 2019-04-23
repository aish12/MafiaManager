//
//  CoreFirebaseHelper.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/23/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import Foundation
import Firebase

class CoreFirebaseHelper: NSObject {
    
    static func getAllData() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        
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
    }
    
}

