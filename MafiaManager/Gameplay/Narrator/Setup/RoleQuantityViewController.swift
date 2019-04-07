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
        peopleNeededLabel.text = "0 People Needed"
        print("view did load")
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
        peopleNeededLabel.text = "\(numPlayersRequired) People Needed"
    }
    
    func updateQuantity(card: Card, incremented: Bool) {
        if incremented {
            self.cardQuantities[card] = self.cardQuantities[card]! + 1
            numPlayersRequired += 1
        } else {
            self.cardQuantities[card] = self.cardQuantities[card]! - 1
            numPlayersRequired -= 1
        }
        self.peopleNeededLabel.text = "\(numPlayersRequired) People Needed"
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
