//
//  CardViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/5/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import CoreData
import CoreGraphics
import Firebase

class CardViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate {

    @IBOutlet weak var cardName: UITextView!
    @IBOutlet weak var cardDescription: UITextView!
    @IBOutlet weak var cardImageButton: UIButton!
    
    var inEditMode: Bool = false
    
    weak var cardsCollectionView: UICollectionView?
    var cardIPath: NSIndexPath?
    var cardObject: Card!
    var deckName: String!
    
    var editImagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //  Creates an image picker for user to select card image
        self.editImagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.cardName.text = cardObject.cardName!
        self.cardDescription.text = cardObject.cardDescription!
        self.cardImageButton.setImage(UIImage(data: cardObject.cardImage!), for: .normal)
        CoreGraphicsHelper.shadeTextViews(textView: cardName)
        CoreGraphicsHelper.shadeTextViews(textView: cardDescription)
        
        cardName.selectedTextRange = cardName.textRange(from: cardName.endOfDocument, to: cardName.endOfDocument)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        inEditMode = true
        cardDescription.isEditable = true
        cardDescription.isSelectable = true
        cardName.isEditable = true
        cardName.isSelectable = true
        self.cardName.placeholder = "Enter card name"
        self.cardDescription.placeholder = "Enter card name"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endEditState))
    
        cardName.becomeFirstResponder()
        cardName.selectedTextRange = cardName.textRange(from: cardName.endOfDocument, to: cardName.endOfDocument)
    }
    
    @objc func endEditState() {
        inEditMode = false
        cardName.textColor = UIColor.black
        cardDescription.textColor = UIColor.black
        
        var editedName = cardName.text!
        var editedDesc = cardDescription.text!
        let editedImage = cardImageButton.image(for: .normal)
        
        let oldName = cardObject.value(forKey: "cardName") as! String
        let oldDesc = cardObject.value(forKey: "cardDescription") as! String
        
        if editedName == "" {
            cardName.setText(newText: oldName)
            editedName = oldName
        }
        if editedDesc == "" {
            cardDescription.setText(newText: oldDesc)
            editedDesc = oldDesc
        }
        
        // Firebase
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(deckName!)").child("cards").child("cardName:\(oldName)").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! NSDictionary
            
            // Delete the old deck's name node
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(self.deckName!)").child("cards").child("cardName:\(oldName)").removeValue()
            // Create a node with the edited deck name
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(self.deckName!)").child("cards").child("cardName:\(editedName)").setValue(value)
            
            // Change the description
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(self.deckName!)").child("cards").child("cardName:\(editedName)").updateChildValues(["cardDescription":editedDesc])
            // Change the images
            let editImageData = editedImage!.pngData()
            let strBase64 = editImageData!.base64EncodedString(options: .lineLength64Characters)
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(self.deckName!)").child("cards").child("cardName:\(editedName)").updateChildValues(["cardImage":strBase64])
            
            (UIApplication.shared.delegate as! AppDelegate).username = (value["name"] as? String) ?? "user"

        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Core Data
        CoreDataHelper.editCard(card: cardObject as Card, newName: editedName, newDescription: editedDesc, newImage: (cardImageButton.image(for: .normal)?.pngData()!)!)

        cardsCollectionView?.reloadItems(at: [cardIPath! as IndexPath])
        
        cardDescription.isEditable = false
        cardDescription.isSelectable = false
        cardName.isEditable = false
        cardName.isSelectable = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
    }
    
    @IBAction func cardButtonPressed(_ sender: UIButton) {
        if !inEditMode {
            return
        }
        editImagePicker.present(from: sender)
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
