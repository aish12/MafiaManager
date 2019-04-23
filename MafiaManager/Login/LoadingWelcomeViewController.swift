//
//  LoadingWelcomeViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 3/21/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the "Welcome User" View Controller

import UIKit
import Firebase

class LoadingWelcomeViewController: UIViewController {
    
    let DecksViewController = "DecksViewControllerIdentifier"
    
    @IBOutlet weak var mafiaUserImage: UIImageView!
    @IBOutlet weak var usersNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mafiaUserImage.image = UIImage(named: "WelcomeLoadingPicture")
    
        // Clear data first so theres no duplicate downloading from Firebase
        CoreDataHelper.clearAllData()
    
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! NSDictionary
            self.usersNameLabel.text = value["Name"] as? String
            
            // Check if has deck names
            if (snapshot.hasChild("decks")) {
                // it exists! So do core data logic by setting up the decks child in Firebase
                // Get a snapshot for the decks
                CoreFirebaseHelper.getAllData()
            } else{
                // does not exist
            }
 
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Transitions after a few seconds to the first VC (deck management)
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "tabBarSegueIdentifier") as! TabBarViewController
            self.present(homeView, animated: true, completion: nil)
        }
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
