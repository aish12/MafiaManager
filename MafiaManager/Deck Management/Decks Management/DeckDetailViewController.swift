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
import Firebase

class DeckDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, updateDeckDetailDelegate, AddCardDelegate, DeleteCardDelegate {
    
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    let cardCellIdentifier = "CardCell"
    let addCardCellIdentifier = "NewCardCell"
    var inEditMode: Bool = false
    var cards: [Card] = []
    weak var decksCollectionView: UICollectionView?
    var deckIPath: NSIndexPath?
    var deckObject: Deck!
    var editNavBarItem:UIBarButtonItem!
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
            cardCell.cardNameLabel.text = card.value(forKey: "cardName") as? String
            cardCell.cardCellImageView.image = UIImage(data: card.value(forKey: "cardImage") as! Data)
            cardCell.cardCellImageView.layer.cornerRadius = 10
            cardCell.cardCellImageView.layer.masksToBounds = true
            cardCell.delegate = self
            cardCell.cellIndex = indexPath.item - 1
            cardCell.card = card
            // If the view is not in edit mode, ensure the reusable cell is not in edit mode
            // Without this, if the cell held another item in edit mode which was deleted, then another item was added to this cell
            // It would retain the styling of an editable cell
            if (!inEditMode){
                cardCell.leaveEditMode()
            } else {
                cardCell.enterEditMode()
            }
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
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.cardsCollectionView.addGestureRecognizer(longPressGR)
        navbar.title = deckObject.value(forKey: "deckName") as? String
        deckDetailTextView.text = deckObject.value(forKey: "deckDescription") as? String
        cardsCollectionView.dataSource = self
        cardsCollectionView.delegate = self
        loadCards()
    }
    
    // Retrieves the cards data from core data and reloads the Collection View's data with this
    func loadCards() {
        cards = CoreDataHelper.retrieveCards(deck: deckObject)
        cardsCollectionView.reloadData()
    }
    
    func addCard(cardToAdd: Card) {
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
    
    func deleteCard(cardCell: CardCellCollectionViewCell) {
        let alert = UIAlertController(title: "Are you sure?", message: "Deleting a card cannot be undone", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            
            // Firebase deletion of the cards
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let card = cardCell.card!
            let deckName = card.deckForCard!.deckName!
            let cardName = card.cardName!
            
            // Deleting the card from firebase
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(deckName)").child("cards").child("cardName:\(cardName)").removeValue()
            
            
            // Deleting the card from core data
            CoreDataHelper.removeCard(card: card)

            // Removes the card from decks (collection view data source), and the collectionView itself
            self.cards.remove(at: self.cards.firstIndex(where: {(testCard: Card) in
                return testCard == card
            })!)
            self.cardsCollectionView.deleteItems(at: [self.cardsCollectionView.indexPath(for: cardCell)!])
            
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDeckDetailToEditDeck",
            let destinationVC = segue.destination as? EditDeckViewController {
            destinationVC.updateDetail = self
            destinationVC.editDeckObject = self.deckObject
        } else if segue.identifier == "fromDetailToNewCardSegue",
            let destinationVC = segue.destination as? CreateCardViewController {
                    
                destinationVC.cardsViewControllerDelegate = self
                destinationVC.deck = deckObject
                
        
        } else if segue.identifier == "fromCardsToCardDetail",
            // Determines the iPath of the selected item to send the selected item
            // to the detail VC
            let destinationVC = segue.destination as? CardViewController,
            let iPaths = self.cardsCollectionView.indexPathsForSelectedItems {
            let firstPath: NSIndexPath = iPaths[0] as NSIndexPath
            if (firstPath.row > 0){
                // TODO: actual set the information of the card object
                destinationVC.cardsCollectionView = cardsCollectionView
                destinationVC.cardIPath = firstPath
                destinationVC.cardObject = cards[firstPath.row - 1]
                destinationVC.deckName = (deckObject.value(forKey: "deckName") as! String)
            }
        } else if segue.identifier == "fromDetailToCopyCardSegue",
            let destinationVC = segue.destination as? CopyCardViewController {
            destinationVC.cardsViewControllerDelegate = self
            destinationVC.deck = deckObject
        }
    }
    
    func updateDeckDetail(name: String, desc: String) {
        navbar.title = name
        deckDetailTextView.text = desc
        decksCollectionView?.reloadItems(at: [deckIPath! as IndexPath])
    }
    
    // Long press for each collection view cell
    @objc func handleLongPress(longPressGR : UILongPressGestureRecognizer) {
        if longPressGR.state != .began {
            return
        }
        let point = longPressGR.location(in: self.cardsCollectionView)
        let indexPath = self.cardsCollectionView.indexPathForItem(at: point)
        if let indexPath = indexPath,
            indexPath.row != 0,
            inEditMode != true {
            inEditMode = true
            startEditState()
            editNavBarItem = navigationItem.rightBarButtonItem
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endEditState))
        } else {
            print("Could not find indexPath")
        }
    }
    
    // Returns cells to normal state where a tap takes you to detail and you can add new decks
    @objc func endEditState() {
        inEditMode = false
        for section in 0..<self.cardsCollectionView.numberOfSections {
            for item in 0..<self.cardsCollectionView.numberOfItems(inSection: section){
                if section == 0 && item == 0 {
                    continue
                } else {
                    let currCell = self.cardsCollectionView.cellForItem(at: IndexPath(item: item, section: section)) as! CardCellCollectionViewCell
                    currCell.leaveEditMode()
                }
            }
        }
        navigationItem.rightBarButtonItem = editNavBarItem
        
    }
    
    // Brings cells to edit mode, where they wobble and have an X icon that when pressed deletes the deck
    func startEditState() {
        inEditMode = true
        for section in 0..<self.cardsCollectionView.numberOfSections {
            for item in 0..<self.cardsCollectionView.numberOfItems(inSection: section){
                if section == 0 && item == 0 {
                    continue
                } else {
                    let currCell = self.cardsCollectionView.cellForItem(at: IndexPath(item: item, section: section)) as! CardCellCollectionViewCell
                    currCell.enterEditMode()
                }
            }
        }
    }
    
    // code to dismiss keyboard when user clicks on background
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
