//
//  EditDeckViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/5/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  View Controller where users can edit an existing deck
import UIKit
import CoreData
import Firebase

// Delegate to update a deck's details
protocol updateDeckDetailDelegate:class {
    func updateDeckDetail(name: String, desc: String)
}

class EditDeckViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var editDeckNameTextView: UITextView!
    @IBOutlet weak var editDeckDescriptionTextView: UITextView!
    @IBOutlet weak var editDeckImagePickerButton: UIButton!
    
    weak var updateDetail: updateDeckDetailDelegate?
    var editDeckObject: Deck!
    var editImagePicker: ImagePicker!
    
    //  Set placeholder text for name and description entry
    //  On load have focus on name entry
    override func viewDidLoad() {
        super.viewDidLoad()

        //  Creates an image picker for user to select deck image
        self.editImagePicker = ImagePicker(presentationController: self, delegate: self)
        
        editDeckImagePickerButton.setImage(UIImage(data: editDeckObject.value(forKey: "deckImage") as! Data), for: .normal)
        
        editDeckNameTextView.text = editDeckObject.value(forKey: "deckName") as? String
        editDeckNameTextView.placeholder = "Enter deck name"
        editDeckNameTextView.becomeFirstResponder()
        editDeckNameTextView.selectedTextRange = editDeckNameTextView.textRange(from: editDeckNameTextView.endOfDocument, to: editDeckNameTextView.endOfDocument)
        CoreGraphicsHelper.shadeTextViews(textView: editDeckNameTextView)
        
        editDeckDescriptionTextView.text = editDeckObject.value(forKey: "deckDescription") as? String
        editDeckDescriptionTextView.placeholder = "Enter deck description"
        CoreGraphicsHelper.shadeTextViews(textView: editDeckDescriptionTextView)
        
        // Add done button to finish editing
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishedEditing))
        
    }
    
    // If the image picker button is pressed, present the image picker
    @IBAction func editImagePickerButtonPressed(_ sender: UIButton) {
        self.editImagePicker.present(from: sender)

    }
    
    // When a new image is selected change the image for the deck image button
    func didSelect(image: UIImage?) {
        self.editDeckImagePickerButton.setImage(image, for: .normal)
    }
    
    // Extracts the new name, description, and image from the edit view and inserts them into core data and firebase
    @objc func finishedEditing() {
        
        var editedName = editDeckNameTextView.text!
        var editedDesc = editDeckDescriptionTextView.text!
        let editedImage = editDeckImagePickerButton.image(for: .normal)
        
        let oldName = editDeckObject.deckName!
        let oldDesc = editDeckObject.deckDescription!
        // If user presses done without changing
        if editedName == "" {
            editDeckNameTextView.setText(newText: oldName)
            editedName = oldName
        }
        if editedDesc == "" {
            editDeckDescriptionTextView.setText(newText: oldDesc)
            editedDesc = oldDesc
        }
        
        // Adds deck changes to Firebase
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(oldName)").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! NSDictionary
            
            // Delete the old deck's name node
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(oldName)").removeValue()
            // Create a node with the edited deck name
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(editedName)").setValue(value)
            
            // Change the description
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(editedName)").updateChildValues(["deckDescription":editedDesc])
            // Change the images
            let editImageData = editedImage!.pngData()
            let strBase64 = editImageData!.base64EncodedString(options: .lineLength64Characters)
            ref.child("users").child(Auth.auth().currentUser!.uid).child("decks").child("deckName:\(editedName)").updateChildValues(["deckImage":strBase64])
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        // Adds deck changes to CoreData
        CoreDataHelper.editDeck(deck: editDeckObject!, newName: editedName, newDescription: editedDesc, newImage: (editedImage?.pngData())!)
        
        // Go back to the Deck detail with new edits in store
        updateDetail?.updateDeckDetail(name: editDeckNameTextView.text, desc: editDeckDescriptionTextView.text)
        navigationController?.popViewController(animated: true)
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
