//
//  CopyCardViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Manages the copy card view controller
import UIKit
import CoreData

class CopyCardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    var cards: [NSManagedObject] = []
    let copyCardReuseIdentifier: String = "copyCard"
    var selectedCards: [IndexPath] = []
    var deck: NSManagedObject?
    weak var cardsViewControllerDelegate: AddCardDelegate?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: copyCardReuseIdentifier, for: indexPath as IndexPath) as! CopyCardCollectionViewCell
        let card = cards[indexPath.item]
        cell.cardLabel.text = card.value(forKey: "cardName") as? String
        cell.cardDescription = card.value(forKey: "cardDescription") as? String
        cell.cardImageView.image = UIImage(data: card.value(forKey: "cardImage") as! Data)
        cell.cardImageView.layer.cornerRadius = 10
        cell.cardImageView.layer.masksToBounds = true
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cards = retrieveCards()
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        cardCollectionView.allowsMultipleSelection = true

        // Do any additional setup after loading the view.
    }
    
    // When the done button is pressed, return to the Deck Detail VC
    @IBAction func doneButtonPressed(_ sender: Any) {
        for selectedCardIPath in selectedCards {
            let selectedCard = cardCollectionView.cellForItem(at: selectedCardIPath) as! CopyCardCollectionViewCell
            if let newName = selectedCard.cardLabel.text,
            let newDescription = selectedCard.cardDescription,
            let newImage = selectedCard.cardImageView.image?.pngData() {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let newCard = Card(context: context)
                newCard.setValue(newName, forKey: "cardName")
                newCard.setValue(newDescription, forKey: "cardDescription")
                newCard.setValue(newImage, forKey: "cardImage")
                newCard.deckForCard = deck as! Deck?
                storeCard(card: newCard, context: context)
                cardsViewControllerDelegate?.addCard(cardToAdd: newCard)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func storeCard(card: NSManagedObject, context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Successfully saved card")
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    // Handles the selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cardCollectionView.deselectItem(at: indexPath, animated: true)
        let indexOfSelected = selectedCards.firstIndex(of:indexPath)
        if (indexOfSelected != nil) {
            selectedCards.remove(at: indexOfSelected!)
            let cell = cardCollectionView.cellForItem(at: indexPath) as! CopyCardCollectionViewCell
            CoreGraphicsHelper.removeSelectedImageBorder(imageView: cell.cardImageView)

        } else {
            selectedCards.append(indexPath)
            let cell = cardCollectionView.cellForItem(at: indexPath) as! CopyCardCollectionViewCell
            CoreGraphicsHelper.createSelectedImageBorder(imageView: cell.cardImageView)
        }
    }
    
    // Retrieves decks from core data
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
