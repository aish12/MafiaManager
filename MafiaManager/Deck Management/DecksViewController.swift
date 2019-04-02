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

class DecksViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ReloadDecksDelegate {

    @IBOutlet weak var decksCollectionView: UICollectionView!
    @IBOutlet weak var newDeckButton: UIButton!
    let deckCellIdentifier = "DeckCell"
    let addDeckCellIdentifier = "AddDeckCell"
    var decks: [NSManagedObject] = []
    var deckCounter = 0
    // Dummy to be completed, required for collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decks.count
    }
    
    // Dummy to be completed, required for collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Running for cell \(deckCounter)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deckCellIdentifier, for: indexPath as IndexPath) as! DeckCellCollectionViewCell
        let deck = decks[deckCounter]
        deckCounter = (deckCounter + 1) % decks.count
        cell.deckCellImageView.image = UIImage(data: deck.value(forKey: "deckImage") as! Data)
        return cell
    }
    
    // On load, round the corners of any buttons to standard size (10)
    override func viewDidLoad() {
        super.viewDidLoad()
        newDeckButton.layer.cornerRadius = 10
        
        decksCollectionView.dataSource = self
        decksCollectionView.delegate = self
        print("ViewDidLoad")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDecksToNewDeckSegue",
            let destinationVC = segue.destination as? NewDeckViewController {
            destinationVC.decksViewControllerDelegate = self
        }
    }
 

}
