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

class CopyCardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    var cards: [Card] = []
    let copyCardReuseIdentifier: String = "copyCard"
    var selectedCards: [IndexPath] = []
    var deck: Deck!
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
        cards = CoreDataHelper.retrieveCards(deck: nil)
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        cardCollectionView.allowsMultipleSelection = true

        // Do any additional setup after loading the view.
    }
    
    // When the done button is pressed, return to the Deck Detail VC
    @IBAction func doneButtonPressed(_ sender: Any) {
        for selectedCardIPath in selectedCards {
            let selectedCard = cardCollectionView.cellForItem(at: selectedCardIPath) as! CopyCardCollectionViewCell
            let deckName = deck?.value(forKey: "deckName") as! String
            if let newName = selectedCard.cardLabel.text,
            let newDescription = selectedCard.cardDescription,
            let newImage = selectedCard.cardImageView.image?.pngData() {
                
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
