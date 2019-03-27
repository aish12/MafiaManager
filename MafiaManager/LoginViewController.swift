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
                let alert = UIAlertController(
                    title: "Empty Fields",
                    message: "Please fill in the required fields",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
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
            } else {
                let homeView = self.storyboard?.instantiateViewController(withIdentifier: "loadingWelcomeIdentifier") as! LoadingWelcomeViewController
                self.present(homeView, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Mafia icon should appear
        mafiaImage.image = UIImage(named: "MafiaIcon")
        passwordTextfield.isSecureTextEntry = true
        
        // After signing in
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.emailTextfield.text = nil
                self.passwordTextfield.text = nil
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
