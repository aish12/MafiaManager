//
//  EditDeckViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/5/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import CoreData
import Firebase

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
    
    @objc func finishedEditing() {
        
        var editedName = editDeckNameTextView.text!
        var editedDesc = editDeckDescriptionTextView.text!
        let editedImage = editDeckImagePickerButton.image(for: .normal)
        
        let oldName = editDeckObject.deckName!
        let oldDesc = editDeckObject.deckDescription!
        // If user presses done without changing
        if editedName == "" {
            editDeckNameTextView.text = oldName
            editedName = oldName
        }
        if editedDesc == "" {
            editDeckDescriptionTextView.text = oldDesc
            editedDesc = oldDesc
        }
        
        // Firebase
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
            
            //(UIApplication.shared.delegate as! AppDelegate).username = (value["name"] as? String) ?? "user"
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        // Core Data
        CoreDataHelper.editDeck(deck: editDeckObject as! Deck, newName: editedName, newDescription: editedDesc, newImage: (editedImage?.pngData())!)
        
        // Go back to the Deck detail with new edits in store
        // TODO: update with image param
        updateDetail?.updateDeckDetail(name: editDeckNameTextView.text, desc: editDeckDescriptionTextView.text)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editImagePickerButtonPressed(_ sender: UIButton) {
        self.editImagePicker.present(from: sender)

    }
    
    func didSelect(image: UIImage?) {
        self.editDeckImagePickerButton.setImage(image, for: .normal)
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
