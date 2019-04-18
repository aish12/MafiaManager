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
        
        self.cardName.text = cardObject.value(forKey: "cardName") as? String
        self.cardDescription.text = cardObject.value(forKey: "cardDescription") as? String
        self.cardImageButton.setImage(UIImage(data: cardObject.value(forKey: "cardImage") as! Data), for: .normal)
        
        cardName.text = cardObject.value(forKey: "cardName") as? String
        cardName.becomeFirstResponder()
        cardName.selectedTextRange = cardName.textRange(from: cardName.endOfDocument, to: cardName.endOfDocument)
        //cardName.delegate = self
        CoreGraphicsHelper.shadeTextViews(textView: cardName)
        
        cardDescription.text = cardObject.value(forKey: "cardDescription") as? String
        CoreGraphicsHelper.shadeTextViews(textView: cardDescription)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        inEditMode = true
        cardDescription.isEditable = true
        cardDescription.isSelectable = true
        cardName.isEditable = true
        cardName.isSelectable = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endEditState))
    
        cardName.becomeFirstResponder()
        cardName.selectedTextRange = cardName.textRange(from: cardName.endOfDocument, to: cardName.endOfDocument)
        cardName.delegate = self
        cardDescription.delegate = self
    }
    
    @objc func endEditState() {
        inEditMode = false
        cardName.textColor = UIColor.black
        cardDescription.textColor = UIColor.black
        
        let editedName = cardName.text!
        let editedDesc = cardDescription.text!
        let editedImage = cardImageButton.image(for: .normal)
        
        let oldName = cardObject.value(forKey: "cardName") as! String
        let oldDesc = cardObject.value(forKey: "cardDescription") as! String
        let oldImage = UIImage(data: cardObject.value(forKey: "cardImage") as! Data)
        
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
        CoreDataHelper.editCard(card: cardObject as! Card, newName: cardName.text, newDescription: cardDescription.text, newImage: (cardImageButton.image(for: .normal)?.pngData()!)!)

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Creates and manages placeholder text, and character limits for card name and description textviews
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        
        if updatedText.isEmpty {
            if textView == cardName {
                textView.text = "Enter card name"
            } else if textView == cardDescription {
                textView.text = "Enter card description"
            } else {
                textView.text = "This should not appear. Oops."
            }
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            if textView == cardName {
                return numberOfChars <= 30
            } else if textView == cardDescription {
                return numberOfChars <= 500
            } else {
                print("Should not reach, character limits in textView")
                return true
            }
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    // Manages placeholder text for card name and description text views
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
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
