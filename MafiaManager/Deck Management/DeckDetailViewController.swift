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

class DeckDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, updateDeckDetailDelegate, AddCardDelegate {
    
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    let cardCellIdentifier = "CardCell"
    let addCardCellIdentifier = "NewCardCell"
    var cards: [NSManagedObject] = []
    
    var deckObject: NSManagedObject = NSManagedObject()
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var deckDetailTextView: UITextView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        // If the indexPath is in the first position, return the "new card" button item
        if (indexPath.section == 0 && indexPath.item == 0){
            let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: addCardCellIdentifier, for: indexPath as IndexPath) as! NewCardCellCollectionViewCell
            newCell.addCellImageView.image = UIImage(named: "plusIcon")
            newCell.addCellImageView.layer.cornerRadius = 10
            newCell.addCellImageView.layer.masksToBounds = true
            cell = newCell
            
            // If the indexPath is not in the first position, return the cards in order
        } else if (indexPath.section == 0){
            let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: cardCellIdentifier, for: indexPath as IndexPath) as! CardCellCollectionViewCell
            
            // The index of the card in decks is item - 1 to account for the "new card" button being item 0
            let card = cards[indexPath.item - 1]
            cardCell.cardCellImageView.image = UIImage(data: card.value(forKey: "cardImage") as! Data)
            cardCell.cardCellImageView.layer.cornerRadius = 10
            cardCell.cardCellImageView.layer.masksToBounds = true
            //cardCell.delegate = self
            cardCell.cellIndex = indexPath.item - 1
            // If the view is not in edit mode, ensure the reusable cell is not in edit mode
            // Without this, if the cell held another item in edit mode which was deleted, then another item was added to this cell
            // It would retain the styling of an editable cell
            /*
            if (!inEditMode){
                deckCell.leaveEditMode()
            } else {
                deckCell.enterEditMode()
            }
            */
            cell = cardCell
            
            // Everything is held in section 0, this should not be reached
        } else {
            print("Section beyond 0 reached for cards, should not happen")
            abort()
        }
        return cell
    }
    
    // If an item is selected, deselect it since we do not implement "selected" traits
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section == 0 && indexPath.item == 0){
            addCardButtonPressed(self)
        }
        cardsCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbar.title = deckObject.value(forKey: "deckName") as? String
        deckDetailTextView.text = deckObject.value(forKey: "deckDescription") as? String
        cardsCollectionView.dataSource = self
        cardsCollectionView.delegate = self
        loadCards()
    }
    
    // Retrieves the cards data from core data and reloads the Collection View's data with this
    func loadCards() {
        cards = retrieveCards()
        cardsCollectionView.reloadData()
    }
    
    // Retrieves cards from core data
    func retrieveCards() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request =
            NSFetchRequest<NSFetchRequestResult>(entityName:"Card")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        return(fetchedResults)!
    }
    
    func addCard(cardToAdd: NSManagedObject) {
        self.cards.append(cardToAdd)
        let newIPath: IndexPath = IndexPath(item: cards.count, section: 0)
        self.cardsCollectionView.insertItems(at: [newIPath])
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDeckDetailToEditDeck",
            let destinationVC = segue.destination as? EditDeckViewController {
            destinationVC.updateDetail = self
            // Set the text views as placeholders
            destinationVC.editName = self.navbar.title
            destinationVC.editDescription = self.deckDetailTextView.text
            // TODO: Set photo for the deck detail and for the edit view
            destinationVC.editDeckObject = self.deckObject
        } else if segue.identifier == "fromDetailToNewCardSegue",
            let destinationVC = segue.destination as? CreateCardViewController {
                    
                destinationVC.cardsViewControllerDelegate = self
                    
                
        
        } else if segue.identifier == "fromCardsToCardDetail",
            // Determines the iPath of the selected item to send the selected item
            // to the detail VC
            let destinationVC = segue.destination as? CardViewController,
            let iPaths = self.cardsCollectionView.indexPathsForSelectedItems {
            let firstPath: NSIndexPath = iPaths[0] as NSIndexPath
            if (firstPath.row > 0){
                // TODO: actual set the information of the card object
                destinationVC.cardObject = cards[firstPath.row - 1]
            }
        }
    }
    
    // TODO: update with image param
    func updateDeckDetail(name: String, desc: String) {
        navbar.title = name
        deckDetailTextView.text = desc
    }
}
