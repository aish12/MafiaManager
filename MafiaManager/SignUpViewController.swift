//
//  SignUpViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 3/21/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    let signInSegueIdentifier = "signInSegueIdentifier"
    
    @IBOutlet weak var mafiaImage: UIImageView!
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    
    @IBAction func onRegisterButtonPressed(_ sender: Any) {
        // Check if input is valid
        guard
            let name = nameTextfield.text,
            let email = emailTextfield.text,
            let password = passwordTextfield.text,
            let confirmPassword = confirmPasswordTextfield.text,
            name.count > 0,
            email.count > 0,
            password.count > 0,
            confirmPassword.count > 0
            else {
                let alert = UIAlertController(
                    title: "Empty Fields",
                    message: "Please fill in the required fields",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        guard password == confirmPassword
            else {
                let alert = UIAlertController(
                    title: "Passwords do not match",
                    message: "Please confirm your password",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        // Sign up logic
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { user, error in
            if error == nil && user != nil {
                // Confirm success
                let alert = UIAlertController(
                    title: "Registration Success",
                    message: "You can now sign in",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            } else if error != nil && user == nil {
                let alert = UIAlertController(
                    title: "Sign Up Failed",
                    message: error!.localizedDescription,
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
        
        // After signing up
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                // Switch to the welcome screen and clear fields
                self.nameTextfield.text = nil
                self.emailTextfield.text = nil
                self.passwordTextfield.text = nil
                self.confirmPasswordTextfield.text = nil
            }
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
