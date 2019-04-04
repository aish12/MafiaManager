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

class DecksViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ReloadDecksDelegate, DeleteDeckDelegate {

    @IBOutlet weak var decksCollectionView: UICollectionView!
    let deckCellIdentifier = "DeckCell"
    let addDeckCellIdentifier = "NewDeckCell"
    var decks: [NSManagedObject] = []
    var deckCounter = 0
    var settingsNavBarItem:UIBarButtonItem!
    var inEditMode = false
    
    // Dummy to be completed, required for collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decks.count + 1
    }
    
    // Returns the cell for each item in the decks collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Running for cell \(deckCounter) and in edit mdoe: \(inEditMode)")
        var cell: UICollectionViewCell
        if (deckCounter == 0){
            let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: addDeckCellIdentifier, for: indexPath as IndexPath) as! NewDeckCellCollectionViewCell
            newCell.addCellImageView.image = UIImage(named: "plusIcon")
            newCell.addCellImageView.layer.cornerRadius = 10
            newCell.addCellImageView.layer.masksToBounds = true
            cell = newCell
        } else {
            let deckCell = collectionView.dequeueReusableCell(withReuseIdentifier: deckCellIdentifier, for: indexPath as IndexPath) as! DeckCellCollectionViewCell
            let deck = decks[deckCounter - 1]
            deckCell.deckCellImageView.image = UIImage(data: deck.value(forKey: "deckImage") as! Data)
            deckCell.deckCellImageView.layer.cornerRadius = 10
            deckCell.deckCellImageView.layer.masksToBounds = true
            deckCell.delegate = self
            deckCell.cellIndex = deckCounter - 1
//            if inEditMode {
//                print("in edit mode for cell \(deckCell.cellIndex)")
//                deckCell.enterEditMode()
//            } else {
//                print("out of edit mode for cell \(deckCell.cellIndex)")
//                deckCell.leaveEditMode()
//            }
            cell = deckCell
        }
        deckCounter = (deckCounter + 1) % (decks.count + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        decksCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // On load, round the corners of any buttons to standard size (10)
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.decksCollectionView.addGestureRecognizer(longPressGR)
        decksCollectionView.dataSource = self
        decksCollectionView.delegate = self
        reloadDecks()
    
        
    }
    
    func reloadDecks() {
        decks = retrieveDecks()
        decksCollectionView.reloadData()
        print("Number of decks = \(decks.count)")
    }
    
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
    
    func deleteDeck(cellIndex: Int) {
        let alert = UIAlertController(title: "Are you sure?", message: "Deleting a deck cannot be undone", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request =
                NSFetchRequest<NSFetchRequestResult>(entityName:"Deck")
            let targetCell: NSManagedObject = self.decks[cellIndex]
            var fetchResults:[NSManagedObject]
        
            do {
                try fetchResults = context.fetch(request) as! [NSManagedObject]
                if fetchResults.count > 0 {
                    for result:AnyObject in fetchResults {
                        if result as! NSObject == targetCell {
                            context.delete(result as! NSManagedObject)
                        }
                    }
                }
                try context.save()
                self.reloadDecks()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDecksToNewDeckSegue",
            let destinationVC = segue.destination as? NewDeckViewController {
            print("in first")
            destinationVC.decksViewControllerDelegate = self
        } else if segue.identifier == "fromDecksToDeckDetail",
            let destinationVC = segue.destination as? DeckDetailViewController,
            let iPaths = self.decksCollectionView.indexPathsForSelectedItems {
                print("in second")
                let firstPath: NSIndexPath = iPaths[0] as NSIndexPath
                if (firstPath.row > 0){
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
    
    @objc func endEditState() {
        inEditMode = false
        for section in 0..<self.decksCollectionView.numberOfSections {
            for item in 0..<self.decksCollectionView.numberOfItems(inSection: section){
                if section == 0 && item == 0 {
                    let currCell = self.decksCollectionView.cellForItem(at: IndexPath(item: item, section: section)) as! NewDeckCellCollectionViewCell
                    currCell.isUserInteractionEnabled = true
                    currCell.backgroundColor = UIColor.clear
                } else {
                    let currCell = self.decksCollectionView.cellForItem(at: IndexPath(item: item, section: section)) as! DeckCellCollectionViewCell
                    currCell.leaveEditMode()
                }
            }
        }
        navigationItem.rightBarButtonItem = self.settingsNavBarItem
    }
    
    func startEditState(){
        inEditMode = true
        for section in 0..<self.decksCollectionView.numberOfSections {
            for item in 0..<self.decksCollectionView.numberOfItems(inSection: section){
                if section == 0 && item == 0 {
                    let currCell = self.decksCollectionView.cellForItem(at: IndexPath(item: item, section: section)) as! NewDeckCellCollectionViewCell
                    currCell.isUserInteractionEnabled = false
                    currCell.backgroundColor = UIColor.lightGray
                } else {
                    let currCell = self.decksCollectionView.cellForItem(at: IndexPath(item: item, section: section)) as! DeckCellCollectionViewCell
                    currCell.enterEditMode()
                }
            }
        }
    }
    
}

