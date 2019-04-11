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

protocol AddCardDelegate: class {
    func addCard(cardToAdd: NSManagedObject)
}

class CreateCardViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate {

    @IBOutlet weak var cardNameTextView: UITextView!
    @IBOutlet weak var cardDescriptionTextView: UITextView!
    @IBOutlet weak var cardImageButton: UIButton!
    weak var cardsViewControllerDelegate: AddCardDelegate?
    var deck: NSManagedObject?
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        cardNameTextView.text = "Enter card name"
        cardNameTextView.textColor = UIColor.lightGray
        cardNameTextView.becomeFirstResponder()
        cardNameTextView.selectedTextRange = cardNameTextView.textRange(from: cardNameTextView.beginningOfDocument, to: cardNameTextView.beginningOfDocument)
        cardNameTextView.delegate = self
        CoreGraphicsHelper.shadeTextViews(textView: cardNameTextView)
        
        cardDescriptionTextView.text = "Enter card description"
        cardDescriptionTextView.textColor = UIColor.lightGray
        cardDescriptionTextView.delegate = self
        CoreGraphicsHelper.shadeTextViews(textView: cardDescriptionTextView)
    }
    
    // When the done button is pressed, return to the previous VC,
    // the Deck Detail VC
    // Also save the card into core data
    @IBAction func doneButtonPressed(_ sender: Any) {
        if cardNameTextView.text == "Enter card name" || cardDescriptionTextView.text == "Enter card description" {
            let alert = UIAlertController(title: "Missing sections", message: "Please fill out any missing sections before continuing.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if let newName = cardNameTextView.text,
            let newDescription = cardDescriptionTextView.text,
            let image = cardImageButton.image(for: .normal) {
            let newImage = image.pngData()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let card = Card(context: context)
            card.setValue(newName, forKey: "cardName")
            card.setValue(newDescription, forKey: "cardDescription")
            card.setValue(newImage, forKey: "cardImage")
            card.deckForCard = deck as! Deck?
            storeCard(card: card, context: context)
            
            cardsViewControllerDelegate?.addCard(cardToAdd: card)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cardImagePickerButtonPressed(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    func didSelect(image: UIImage?) {
        self.cardImageButton.setImage(image, for: .normal)
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
    
    // Creates and manages placeholder text, and character limits for deck name and description textviews
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            if textView == cardNameTextView {
                textView.text = "Enter card name"
            } else if textView == cardDescriptionTextView {
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
            if textView == cardNameTextView {
                return numberOfChars <= 30
            } else if textView == cardDescriptionTextView {
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
    
    // Manages placeholder text for deck name and description text views
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
