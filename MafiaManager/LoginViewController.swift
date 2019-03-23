//
//  LoginViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 3/21/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let signUpSegueIdentifier = "signUpSegueIdentifier"
    let loadingWelcomeSegueIdentifier = "loadingWelcomeSegueIdentifier"

    @IBOutlet weak var mafiaImage: UIImageView!
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func onLogInButtonPressed(_ sender: Any) {
        
        guard
            let email = emailTextfield.text,
            let password = passwordTextfield.text,
            email.count > 0,
            password.count > 0
            else {
                return
            }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(
                    title: "Sign In Failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Mafia icon should appear
        mafiaImage.image = UIImage(named: "MafiaIcon")
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
