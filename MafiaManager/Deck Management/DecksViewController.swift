//
//  DecksViewController.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 3/24/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Manages the Decks View Controller

import UIKit
import CoreData

class DecksViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, AddDeckDelegate, DeleteDeckDelegate {

    @IBOutlet weak var decksCollectionView: UICollectionView!
    let deckCellIdentifier = "DeckCell"
    let addDeckCellIdentifier = "NewDeckCell"
    var decks: [NSManagedObject] = []
    var settingsNavBarItem:UIBarButtonItem!
    var inEditMode = false
    
    // Returns the number of items in the decks collection. Returns the number of decks + 1 to
    // account for the "new deck" button
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decks.count + 1
    }
    
    // Returns the cell for each item in the decks collection view, including the "new deck" button
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        // If the indexPath is in the first position, return the "new deck" button item
        if (indexPath.section == 0 && indexPath.item == 0){
            let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: addDeckCellIdentifier, for: indexPath as IndexPath) as! NewDeckCellCollectionViewCell
            newCell.addCellImageView.image = UIImage(named: "plusIcon")
            newCell.addCellImageView.layer.cornerRadius = 10
            newCell.addCellImageView.layer.masksToBounds = true
            cell = newCell
        
            // If the indexPath is not in the first position, return the decks in order
        } else if (indexPath.section == 0){
            let deckCell = collectionView.dequeueReusableCell(withReuseIdentifier: deckCellIdentifier, for: indexPath as IndexPath) as! DeckCellCollectionViewCell
            
            // The index of the deck in decks is item - 1 to account for the "new deck" button being item 0
            let deck = decks[indexPath.item - 1]
            deckCell.deckNameLabel.text = deck.value(forKey: "deckName") as? String
            deckCell.deckCellImageView.image = UIImage(data: deck.value(forKey: "deckImage") as! Data)
            deckCell.deckCellImageView.layer.cornerRadius = 10
            deckCell.deckCellImageView.layer.masksToBounds = true
            deckCell.delegate = self
            deckCell.cellIndex = indexPath.item - 1
            // If the view is not in edit mode, ensure the reusable cell is not in edit mode
            // Without this, if the cell held another item in edit mode which was deleted, then another item was added to this cell
            // It would retain the styling of an editable cell
            if (!inEditMode){
                deckCell.leaveEditMode()
            } else {
                deckCell.enterEditMode()
            }
            cell = deckCell
        
        // Everything is held in section 0, this should not be reached
        } else {
            print("Section beyond 0 reached for decks, should not happen")
            abort()
        }
        return cell
    }
    
    // If an item is selected, deselect it since we do not implement "selected" traits
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        decksCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // On load, round the corners of any buttons to standard size (10), assign an action to long press
    // on a cell where handleLongPress is called, and load the deck's data from core data
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.decksCollectionView.addGestureRecognizer(longPressGR)
        decksCollectionView.dataSource = self
        decksCollectionView.delegate = self
        loadDecks()
    }
    
    // Retrieves the decks data from core data and reloads the Collection View's data with this
    func loadDecks() {
        decks = retrieveDecks()
        decksCollectionView.reloadData()
    }
    
    // Retrieves decks from core data
    func retrieveDecks() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request =
            NSFetchRequest<NSFetchRequestResult>(entityName:"Deck")
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
    
    // Adds a newly created deck to the collection view
    func addDeck(deckToAdd: NSManagedObject) {
        self.decks.append(deckToAdd)
        let newIPath: IndexPath = IndexPath(item: decks.count, section: 0)
        self.decksCollectionView.insertItems(at: [newIPath])
    }
    
    // Deletes a deck at cellIndex from both core data and the collection view.
    // cellIndex is the index of the deck in decks, not the item index
    func deleteDeck(cellIndex: Int) {
        let alert = UIAlertController(title: "Are you sure?", message: "Deleting a deck cannot be undone", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            // Deleting the deck from core data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let targetDeck: Deck = self.decks[cellIndex] as! Deck
            let targetCards: NSOrderedSet? = targetDeck.cardForDeck
            context.delete(targetDeck)
            if targetCards != nil {
                for targetCard in targetCards! {
                    context.delete(targetCard as! Card)
                }
            }
            self.decks.remove(at: cellIndex)
            self.decksCollectionView.deleteItems(at: [IndexPath(item: cellIndex + 1, section: 0)])
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Prepares segues for creating a new deck and viewing a deck's details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDecksToNewDeckSegue",
            let destinationVC = segue.destination as? NewDeckViewController {
            destinationVC.decksViewControllerDelegate = self
        } else if segue.identifier == "fromDecksToDeckDetail",
            // Determines the iPath of the selected item to send the selected item
            // to the detail VC
            let destinationVC = segue.destination as? DeckDetailViewController,
            let iPaths = self.decksCollectionView.indexPathsForSelectedItems {
                let firstPath: NSIndexPath = iPaths[0] as NSIndexPath
                if (firstPath.row > 0){
                    destinationVC.decksCollectionView = self.decksCollectionView
                    destinationVC.deckIPath = firstPath
                    destinationVC.deckObject = decks[firstPath.row - 1]
                }
        }
    }
 
    // Long press for each collection view cell
    @objc func handleLongPress(longPressGR : UILongPressGestureRecognizer) {
        if longPressGR.state != .began {
            return
        }
        let point = longPressGR.location(in: self.decksCollectionView)
        let indexPath = self.decksCollectionView.indexPathForItem(at: point)
        if let indexPath = indexPath,
            indexPath.row != 0,
            inEditMode != true {
            inEditMode = true
            startEditState()
            self.settingsNavBarItem = navigationItem.rightBarButtonItem
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endEditState))
        } else {
            print("Could not find indexPath")
        }
    }
    
    // Returns cells to normal state where a tap takes you to detail and you can add new decks
    @objc func endEditState() {
        inEditMode = false
        for section in 0..<self.decksCollectionView.numberOfSections {
            for item in 0..<self.decksCollectionView.numberOfItems(inSection: section){
                if section == 0 && item == 0 {
                    continue
                } else {
                    let currCell = self.decksCollectionView.cellForItem(at: IndexPath(item: item, section: section)) as! DeckCellCollectionViewCell
                    currCell.leaveEditMode()
                }
            }
        }
        navigationItem.rightBarButtonItem = self.settingsNavBarItem
    }
    
    // Brings cells to edit mode, where they wobble and have an X icon that when pressed deletes the deck
    func startEditState() {
        inEditMode = true
        for section in 0..<self.decksCollectionView.numberOfSections {
            for item in 0..<self.decksCollectionView.numberOfItems(inSection: section){
                if section == 0 && item == 0 {
                    continue
                } else {
                    let currCell = self.decksCollectionView.cellForItem(at: IndexPath(item: item, section: section)) as! DeckCellCollectionViewCell
                    currCell.enterEditMode()
                }
            }
        }
    }
    
}

