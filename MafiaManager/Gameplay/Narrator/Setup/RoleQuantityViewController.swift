//
//  RoleQuantityViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/7/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import CoreData

class RoleQuantityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateQuantityDelegate {

    @IBOutlet weak var peopleNeededLabel: UILabel!
    @IBOutlet weak var roleTable: UITableView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var deck: Deck?
    var cards: [Card]?
    var cardQuantities: [Card: Int] = [:]
    var numPlayersRequired: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roleTable.delegate = self
        roleTable.dataSource = self
        cards = retrieveCards()
        for card in cards! {
            cardQuantities[card] = 0
        }
        peopleNeededLabel.text = "Players Are Needed to Continue"
        nextButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        roleTable.reloadData()
        cards = retrieveCards()
        for cardQuantity in cardQuantities {
            if !(cards?.contains(cardQuantity.key))!{
                cardQuantities.removeValue(forKey: cardQuantity.key)
            }
        }
        for card in cards! {
            if cardQuantities[card] == nil {
                cardQuantities[card] = 0
            }
        }
        setNumPlayersRequired()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (deck?.cardForDeck?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roleTable.dequeueReusableCell(withIdentifier: "roleCell", for: indexPath as IndexPath) as! RoleQuantityTableViewCell
        cell.selectionStyle = .none
        let card = cards![indexPath.item]
        cell.card = card
        cell.quantity = cardQuantities[card]!
        cell.quantityLabel.text = "\(cardQuantities[card]!)"
        cell.roleLabel.text = card.cardName
        cell.updateQuantityDelegate = self
        cell.updateButtons()
        return cell
    }
    
    func setNumPlayersRequired(){
        numPlayersRequired = 0
        for card in cardQuantities {
            numPlayersRequired += card.value
        }
        if numPlayersRequired == 0 {
            nextButton.isEnabled = false
            peopleNeededLabel.text = "Players Are Needed to Continue"
        } else if numPlayersRequired > 0 {
            nextButton.isEnabled = true
            peopleNeededLabel.text = "\(numPlayersRequired) Players Needed"
        }
    }
    
    func updateQuantity(card: Card, incremented: Bool) {
        if incremented {
            self.cardQuantities[card] = self.cardQuantities[card]! + 1
            numPlayersRequired += 1
        } else {
            self.cardQuantities[card] = self.cardQuantities[card]! - 1
            numPlayersRequired -= 1
        }
        
        if numPlayersRequired == 0 {
            nextButton.isEnabled = false
            peopleNeededLabel.text = "Players Are Needed to Continue"
        } else if numPlayersRequired > 0 {
            nextButton.isEnabled = true
            peopleNeededLabel.text = "\(numPlayersRequired) Players Needed"
        }
    }
    
    // Retrieves decks from core data
    func retrieveCards() -> [Card] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request =
            NSFetchRequest<NSFetchRequestResult>(entityName:"Card")
        request.predicate = NSPredicate(format: "deckForCard == %@", deck!)
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        return(fetchedResults) as! [Card]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromRoleQuantitytoPlayerJoin",
            let destinationVC = segue.destination as? WaitForPlayersViewController{
            destinationVC.cardQuantities = self.cardQuantities
            destinationVC.numPlayers = self.numPlayersRequired
        }
    }

}
