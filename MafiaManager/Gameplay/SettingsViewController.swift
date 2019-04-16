//
//  SettingsViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/27/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the settings view controller

import UIKit
import Firebase

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var minutePicker: UIPickerView!
    @IBOutlet weak var secondPicker: UIPickerView!
    
    let minutePickerValues: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    let secondPickerValues: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minutePicker.dataSource = self
        minutePicker.delegate = self
        secondPicker.dataSource = self
        secondPicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // For both minute and second, they only have one component, always return 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Determine which picker is being used, then return the count of its data source
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(minutePicker){
            return minutePickerValues.count
        } else if pickerView.isEqual(secondPicker){
            return secondPickerValues.count
        } else {
            print("Failed Picker")
            return 0
        }
    }
    
    // Determine which picker is being used, then return the value at the given index/row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(minutePicker){
            return "\(minutePickerValues[row])"
        } else if pickerView.isEqual(secondPicker){
            return "\(secondPickerValues[row])"
        } else {
            print("Failed Picker")
            return ""
        }
    }
    
    
    @IBAction func onSignOutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Signed out successfully")
            //dismiss(animated: true, completion: nil)
        
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
                (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
            }
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
