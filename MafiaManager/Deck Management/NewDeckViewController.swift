//
//  NewDeckViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Manages the view for creating a new deck
import UIKit

class NewDeckViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate {
    @IBOutlet weak var deckNameTextView: UITextView!
    @IBOutlet weak var deckDetailTextView: UITextView!
    @IBOutlet weak var deckImagePickerButton: UIButton!
    
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
        deckNameTextView.layer.shadowOpacity = 0.4
        deckNameTextView.layer.shadowColor = UIColor.lightGray.cgColor
        deckNameTextView.layer.shadowOffset = CGSize(width: 3, height: 3)
        deckNameTextView.layer.shadowRadius = 5
        deckNameTextView.layer.cornerRadius = 5
        deckNameTextView.layer.masksToBounds = false
        
        deckDetailTextView.text = "Enter deck description"
        deckDetailTextView.textColor = UIColor.lightGray
        deckDetailTextView.delegate = self
        deckDetailTextView.layer.shadowOpacity = 0.4
        deckDetailTextView.layer.shadowOffset = CGSize(width: 3, height: 3)
        deckDetailTextView.layer.shadowColor = UIColor.lightGray.cgColor
        deckDetailTextView.layer.shadowRadius = 5
        deckDetailTextView.layer.cornerRadius = 5
        deckDetailTextView.layer.masksToBounds = false
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
    @IBAction func doneButtonPressed(_ sender: Any) {
        if let newName = deckNameTextView.text,
            let newDescription = deckDetailTextView.text {
            
        }
        navigationController?.popViewController(animated: true)
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

}
