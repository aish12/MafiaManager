//
//  DeckSelectionViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/6/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import CoreData

class DeckSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate {
    
    var deckObjects: [Deck] = []
    let deckSelectReuseIdentifier: String = "DeckSelectCell"
    @IBOutlet weak var decksCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        decksCollectionView.dataSource = self
        decksCollectionView.delegate = self
        
        loadDecks()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        loadDecks()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deckObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deckSelectReuseIdentifier, for: indexPath as IndexPath) as! DeckSelectionCollectionViewCell
        let deck = deckObjects[indexPath.item]
        cell.deckLabel.text = deck.value(forKey: "deckName") as? String
        cell.deckImageView.image = UIImage(data: deck.value(forKey: "deckImage") as! Data)
        cell.deckImageView.layer.cornerRadius = 10
        cell.deckImageView.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         performSegue(withIdentifier: "fromDeckSelectToDeckDetail", sender: self)
        /*
        let popoverContent: SelectDetailViewController! = self.storyboard?.instantiateViewController(withIdentifier: "SelectDetailViewController") as! SelectDetailViewController
        popoverContent.modalPresentationStyle = .popover
        _ = popoverContent.presentationController
        
        if let popover = popoverContent.popoverPresentationController {
            let viewForSource = self.view!
            popover.sourceView = viewForSource
            
            popover.sourceRect = viewForSource.bounds
            popoverContent.preferredContentSize = CGSize(width: 200, height: 500)
            popover.delegate = self
            popoverContent.deck = deckObjects[indexPath.item]
        }
        self.present(popoverContent, animated: true, completion: nil)
 */
    }
    
    // Retrieves the decks data from core data and reloads the Collection View's data with this
    func loadDecks() {
        deckObjects = (retrieveDecks() as! [Deck])
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDeckSelectToDeckDetail" {
            if let destinationVC = segue.destination as? SelectDetailViewController,
                let indexPaths: [IndexPath] = self.decksCollectionView.indexPathsForSelectedItems {
                let deck: Deck = deckObjects[indexPaths[0].item]
                print(deck)
                //destinationVC.popoverPresentationController?.sourceView = self.view
                destinationVC.popoverPresentationController?.sourceRect = CGRect(x:-self.view.bounds.width, y:-self.view.bounds.height, width: self.view.bounds.width - 20, height: self.view.bounds.height - 30)

                destinationVC.deck = deck
                destinationVC.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
                destinationVC.modalPresentationStyle = .popover
                destinationVC.popoverPresentationController?.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}
