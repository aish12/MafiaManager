//
//  CardViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/5/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import CoreData

class CardViewController: UIViewController, ImagePickerDelegate {

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

        //  Creates an image picker for user to select deck image
        self.editImagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.cardName.text = cardObject.value(forKey: "cardName") as? String
        self.cardDescription.text = cardObject.value(forKey: "cardDescription") as? String
        self.cardImageButton.setImage(UIImage(data: cardObject.value(forKey: "cardImage") as! Data), for: .normal)
        
        cardName.text = cardObject.value(forKey: "cardName") as? String
        //editDeckNameTextView.textColor = UIColor.lightGray
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
        //editDeckDescriptionTextView.textColor = UIColor.lightGray
        //cardDescription.delegate = self
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
    }
    
    @objc func endEditState() {
        inEditMode = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Just set the editDeckObject
        cardObject.setValue(cardName.text, forKey: "cardName")
        cardObject.setValue(cardDescription.text, forKey: "cardDescription")
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

}
