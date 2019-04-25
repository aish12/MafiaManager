//
//  LoginViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 3/21/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the login view controller

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let signUpSegueIdentifier = "signUpSegueIdentifier"

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var mafiaImage: UIImageView!
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginSignupStackView: UIStackView!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Mafia icon should appear
        mafiaImage.image = UIImage(named: "MafiaIcon")
        passwordTextfield.isSecureTextEntry = true
        
        
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        
        CoreGraphicsHelper.colorButtons(button: loginButton, color: CoreGraphicsHelper.navyBlueColor)
        CoreGraphicsHelper.colorButtons(button: signUpButton, color: CoreGraphicsHelper.navyBlueColor)
        
        // After signing in
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.emailTextfield.text = nil
                self.passwordTextfield.text = nil
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        mafiaImage.frame.size = CGSize(width: 0, height: 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func onLogInButtonPressed(_ sender: Any) {
        login()
    }
    
    func login() {
        // Check valid inputs
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
                // There is an error
                let alert = UIAlertController(
                    title: "Sign In Failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            } else {
                // Otherwise, can transition to the welcome view
                let homeView = self.storyboard?.instantiateViewController(withIdentifier: "loadingWelcomeIdentifier") as! LoadingWelcomeViewController
                self.present(homeView, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        login()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame!.origin.y
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            let keyboardShow: Bool!
            if endFrameY >= UIScreen.main.bounds.size.height {
                print("keyboard hide")
                keyboardShow = false
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                print("keyboard show")
                keyboardShow = true
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            print("size:", mafiaImage.frame.size)
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            if keyboardShow {
                                self.mafiaImage?.isHidden = true
                                self.imageHeightConstraint?.constant = 0.0
                            } else {
                                self.mafiaImage?.isHidden = false
                                self.imageHeightConstraint?.constant = 176.0
                            }
                            self.view.layoutIfNeeded() },
                           completion: nil)
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
