//
//  NewDeckViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Manages the view for creating a new deck
import UIKit
import CoreData
import CoreGraphics
import Firebase

protocol AddDeckDelegate: class {
    func addDeck(deckToAdd: NSManagedObject)
}
class NewDeckViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate {
    @IBOutlet weak var deckNameTextView: UITextView!
    @IBOutlet weak var deckDetailTextView: UITextView!
    @IBOutlet weak var deckImagePickerButton: UIButton!
    weak var decksViewControllerDelegate: AddDeckDelegate?
    var imagePicker: ImagePicker!
    
    //  Set placeholder text for name and description entry
    //  On load have focus on name entry
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Creates an image picker for user to select deck image
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        deckNameTextView.text = "Enter deck name"
        deckNameTextView.textColor = UIColor.lightGray
        deckNameTextView.becomeFirstResponder()
        deckNameTextView.selectedTextRange = deckNameTextView.textRange(from: deckNameTextView.beginningOfDocument, to: deckNameTextView.beginningOfDocument)
        deckNameTextView.delegate = self
        CoreGraphicsHelper.shadeTextViews(textView: deckNameTextView)
        
        deckDetailTextView.text = "Enter deck description"
        deckDetailTextView.textColor = UIColor.lightGray
        deckDetailTextView.delegate = self
        CoreGraphicsHelper.shadeTextViews(textView: deckDetailTextView)
    }
    
    //  When user taps imagePicker, let them select from camera roll
    @IBAction func imagePickerButtonPressed(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    // When user selects an image from camera roll, display it over the imagePicker
    func didSelect(image: UIImage?) {
        self.deckImagePickerButton.setImage(image, for: .normal)
    }
    
    // When the done button is pressed, the "new deck" view is popped
    // So the user returns to the Decks view
    // Also makes sure not to leave any sections missing
    @IBAction func doneButtonPressed(_ sender: Any) {
        if deckNameTextView.text == "Enter deck name" || deckDetailTextView.text == "Enter deck description" {
            let alert = UIAlertController(title: "Missing sections", message: "Please fill out any missing sections before continuing.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if let newName = deckNameTextView.text,
            let newDescription = deckDetailTextView.text,
            let image = deckImagePickerButton.image(for: .normal) {
            let newImage = image.pngData()
            
            
            // Firebase
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            //ref.child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["\(newName)":"deck name"])
            ref.child("users").child(Auth.auth().currentUser!.uid).child("deckName:\(newName)").setValue(["deckDescription":newDescription])
            // Store the data of newImage
            let strBase64 = newImage!.base64EncodedString(options: .lineLength64Characters)
            print(strBase64)
            ref.child("users").child(Auth.auth().currentUser!.uid).child("deckName:\(newName)").updateChildValues(["deckImage":strBase64])
            
            
            // Core Data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let deck = NSEntityDescription.insertNewObject(forEntityName: "Deck", into: context)
            deck.setValue(newName, forKey: "deckName")
            deck.setValue(newDescription, forKey: "deckDescription")
            deck.setValue(newImage, forKey: "deckImage")
            storeDeck(deck: deck, context: context)
            decksViewControllerDelegate?.addDeck(deckToAdd: deck)

        }
        navigationController?.popViewController(animated: true)
    }
    
    func storeDeck(deck: NSManagedObject, context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Successfully saved deck")
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
            if textView == deckNameTextView {
                textView.text = "Enter deck name"
            } else if textView == deckDetailTextView {
                textView.text = "Enter deck description"
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
            if textView == deckNameTextView {
                return numberOfChars <= 30
            } else if textView == deckDetailTextView {
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
