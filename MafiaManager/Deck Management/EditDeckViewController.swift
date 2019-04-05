//
//  EditDeckViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/5/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class EditDeckViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var editDeckNameTextView: UITextView!
    @IBOutlet weak var editDeckDescriptionTextView: UITextView!
    @IBOutlet weak var editDeckImagePickerButton: UIButton!
    
    var editName: String!
    var editDescription: String!
    var editImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editDeckNameTextView.text = self.editName
        //editDeckNameTextView.textColor = UIColor.lightGray
        editDeckNameTextView.becomeFirstResponder()
        editDeckNameTextView.selectedTextRange = editDeckNameTextView.textRange(from: editDeckNameTextView.endOfDocument, to: editDeckNameTextView.endOfDocument)
        editDeckNameTextView.delegate = self
        editDeckNameTextView.layer.shadowOpacity = 0.4
        editDeckNameTextView.layer.shadowColor = UIColor.lightGray.cgColor
        editDeckNameTextView.layer.shadowOffset = CGSize(width: 3, height: 3)
        editDeckNameTextView.layer.shadowRadius = 5
        editDeckNameTextView.layer.cornerRadius = 5
        editDeckNameTextView.layer.masksToBounds = false
        
        editDeckDescriptionTextView.text = self.editDescription
        //editDeckDescriptionTextView.textColor = UIColor.lightGray
        editDeckDescriptionTextView.delegate = self
        editDeckDescriptionTextView.layer.shadowOpacity = 0.4
        editDeckDescriptionTextView.layer.shadowOffset = CGSize(width: 3, height: 3)
        editDeckDescriptionTextView.layer.shadowColor = UIColor.lightGray.cgColor
        editDeckDescriptionTextView.layer.shadowRadius = 5
        editDeckDescriptionTextView.layer.cornerRadius = 5
        editDeckDescriptionTextView.layer.masksToBounds = false
    }
    
    
    func didSelect(image: UIImage?) {
        self.editDeckImagePickerButton.setImage(image, for: .normal)
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
            if textView == editDeckNameTextView {
                textView.text = "Enter deck name"
            } else if textView == editDeckDescriptionTextView {
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
            if textView == editDeckNameTextView {
                return numberOfChars <= 30
            } else if textView == editDeckDescriptionTextView {
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
                textView.selectedTextRange = textView.textRange(from: textView.endOfDocument, to: textView.endOfDocument)
            }
        }
    }
}
