//
//  CreateCardViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for managing the card creation view controller

import UIKit
import CoreData
import CoreGraphics
import Firebase

protocol AddCardDelegate: class {
    func addCard(cardToAdd: Card)
}

class CreateCardViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate {

    @IBOutlet weak var cardNameTextView: UITextView!
    @IBOutlet weak var cardDescriptionTextView: UITextView!
    @IBOutlet weak var cardImageButton: UIButton!
    weak var cardsViewControllerDelegate: AddCardDelegate?
    var deck: Deck!
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        cardNameTextView.becomeFirstResponder()
        cardNameTextView.selectedTextRange = cardNameTextView.textRange(from: cardNameTextView.beginningOfDocument, to: cardNameTextView.beginningOfDocument)
        
        cardNameTextView.placeholder = "Enter card name"
        CoreGraphicsHelper.shadeTextViews(textView: cardNameTextView)
        
        cardDescriptionTextView.placeholder = "Enter card description"
        CoreGraphicsHelper.shadeTextViews(textView: cardDescriptionTextView)
    }
    
    // When the done button is pressed, return to the previous VC,
    // the Deck Detail VC
    // Also save the card into core data
    @IBAction func doneButtonPressed(_ sender: Any) {
        if cardNameTextView.text == "" || cardDescriptionTextView.text == "" {
            let alert = UIAlertController(title: "Missing sections", message: "Please fill out any missing sections before continuing.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if let newName = cardNameTextView.text,
            let newDescription = cardDescriptionTextView.text,
            let image = cardImageButton.image(for: .normal) {
            let newImage = image.pngData()
            let deckName = deck.deckName!
            
            // Firebase
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(deckName)").child("cards").child("cardName:\(newName)").setValue(["cardDescription":newDescription])
            let strBase64 = newImage!.base64EncodedString(options: .lineLength64Characters)
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(deckName)").child("cards").child("cardName:\(newName)").updateChildValues(["cardImage":strBase64])
            
            let newCard = CoreDataHelper.addCard(deck: deck, newName: newName, newDescription: newDescription, newImage: newImage!)
            cardsViewControllerDelegate?.addCard(cardToAdd: newCard)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cardImagePickerButtonPressed(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    func didSelect(image: UIImage?) {
        self.cardImageButton.setImage(image, for: .normal)
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
