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

class CardViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate {

    @IBOutlet weak var cardName: UITextView!
    @IBOutlet weak var cardDescription: UITextView!
    @IBOutlet weak var cardImageButton: UIButton!
    
    var inEditMode: Bool = false
    
    weak var cardsCollectionView: UICollectionView?
    var cardIPath: NSIndexPath?
    var cardObject: NSManagedObject = NSManagedObject()
    
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
        cardName.layer.shadowOpacity = 0.4
        cardName.layer.shadowColor = UIColor.lightGray.cgColor
        cardName.layer.shadowOffset = CGSize(width: 3, height: 3)
        cardName.layer.shadowRadius = 5
        cardName.layer.cornerRadius = 5
        cardName.layer.masksToBounds = false
        
        cardDescription.text = cardObject.value(forKey: "cardDescription") as? String
        cardDescription.layer.shadowOpacity = 0.4
        cardDescription.layer.shadowOffset = CGSize(width: 3, height: 3)
        cardDescription.layer.shadowColor = UIColor.lightGray.cgColor
        cardDescription.layer.shadowRadius = 5
        cardDescription.layer.cornerRadius = 5
        cardDescription.layer.masksToBounds = false
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Just set the card object
        
        // Don't change if they didn't have anything in the text:
        if cardName.text != "Enter card name" {
            cardObject.setValue(cardName.text, forKey: "cardName")
        } else {
            // On done, have the text still show in text view
            cardName.text = (cardObject.value(forKey: "cardName") as! String)
        }
        
        if cardDescription.text != "Enter card description" {
            cardObject.setValue(cardDescription.text, forKey: "cardDescription")
        } else {
            // On done, have the text still show in text view
            cardName.text = (cardObject.value(forKey: "cardDescription") as! String)
        }
        
        let cardImage = cardImageButton.image(for: .normal)
        cardObject.setValue(cardImage?.pngData(), forKey: "cardImage")
        
        // Commit the changes
        do {
            try context.save()
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
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
    
}
