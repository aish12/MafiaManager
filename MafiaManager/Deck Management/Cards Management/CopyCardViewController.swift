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
import Firebase

class CopyCardViewController: UIViewController, UICollectionViewDelegate, UISearchResultsUpdating, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    var cards: [Card] = []
    var cardSearchController = UISearchController(searchResultsController: nil)
    var filteredCards: [Card] = []
    let copyCardReuseIdentifier: String = "copyCard"
    var selectedCards: [Card] = []
    var deck: Deck!
    weak var cardsViewControllerDelegate: AddCardDelegate?
    
    // On load create collection of all cards and allow multiple to be selected. Setup search controller
    override func viewDidLoad() {
        super.viewDidLoad()
        cards = CoreDataHelper.retrieveCards(deck: nil)
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        cardCollectionView.allowsMultipleSelection = true
        
        cardSearchController.searchResultsUpdater = self
        cardSearchController.obscuresBackgroundDuringPresentation = false
        cardSearchController.searchBar.placeholder = "Search Cards"
        navigationItem.searchController = cardSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    // If the collection is filtered return the number of filtered cards, else all cards
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCards.count
        }
        return cards.count
    }
    
    // If the collection is filtered return the card based on index in filteredCards, else from cards
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: copyCardReuseIdentifier, for: indexPath as IndexPath) as! CopyCardCollectionViewCell
        
        var card: Card!
        if isFiltering() {
            card = filteredCards[indexPath.item]
        } else {
            card = cards[indexPath.item]
        }
        print(card)
        cell.cardLabel.text = card.value(forKey: "cardName") as? String
        cell.cardDescription = card.value(forKey: "cardDescription") as? String
        cell.cardImageView.image = UIImage(data: card.value(forKey: "cardImage") as! Data)
        cell.cardImageView.layer.cornerRadius = 10
        cell.cardImageView.layer.masksToBounds = true
        if selectedCards.contains(where: {(selectedCard: Card) in
            selectedCard == card
        }) {
            CoreGraphicsHelper.createSelectedImageBorder(imageView: cell.cardImageView)
        } else {
            CoreGraphicsHelper.removeSelectedImageBorder(imageView: cell.cardImageView)
        }
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func isFiltering() -> Bool {
        return cardSearchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return cardSearchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCards = cards.filter({( card : Card) -> Bool in
            return card.cardName!.lowercased().contains(searchText.lowercased())
        })
        
        cardCollectionView.reloadData()
    }
    
    
    // When the done button is pressed, return to the Deck Detail VC
    @IBAction func doneButtonPressed(_ sender: Any) {
        for selectedCard in selectedCards {
            let deckName = deck.deckName
            if let newName = selectedCard.cardName,
            let newDescription = selectedCard.cardDescription,
            let newImage = selectedCard.cardImage {
                
                // Firebase
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(deckName)").child("cards").child("cardName:\(newName)").setValue(["cardDescription":newDescription])
                let strBase64 = newImage.base64EncodedString(options: .lineLength64Characters)
                ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(deckName)").child("cards").child("cardName:\(newName)").updateChildValues(["cardImage":strBase64])
                
                // Core Data
                let newCard = CoreDataHelper.addCard(deck: deck, newName: newName, newDescription: newDescription, newImage: newImage)
                cardsViewControllerDelegate?.addCard(cardToAdd: newCard)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // Handles the selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cardCollectionView.deselectItem(at: indexPath, animated: true)
        let selectedCard: Card!
        if isFiltering() {
            selectedCard = filteredCards[indexPath.item]
        } else {
            selectedCard = cards[indexPath.item]
        }
        let indexOfSelectedCard = selectedCards.firstIndex(where: {(card: Card) in
            card == selectedCard
        })
        if (indexOfSelectedCard != nil) {
            selectedCards.remove(at: indexOfSelectedCard!)

        } else {
            selectedCards.append(selectedCard)
        }
        cardCollectionView.reloadData()
    }
    
    // code to dismiss keyboard when user clicks on background
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
