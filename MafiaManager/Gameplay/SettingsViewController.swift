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
    @IBOutlet weak var mutedSwitch: UISwitch!
    
    let maxMinuteValue: Int = 15
    let maxSecondValue: Int = 59
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minutePicker.dataSource = self
        minutePicker.delegate = self
        secondPicker.dataSource = self
        secondPicker.delegate = self
        // Do any additional setup after loading the view.
        setTimerToDefault()
    }
    
    // For both minute and second, they only have one component, always return 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func setTimerToDefault() {
        let defaultTimerLength = UserDefaults.standard.integer(forKey: "defaultTimerLength")
        let defaultMinuteValue = defaultTimerLength / 60
        let defaultSecondValue = defaultTimerLength % 60
        minutePicker.selectRow(defaultMinuteValue, inComponent: 0, animated: true)
        secondPicker.selectRow(defaultSecondValue, inComponent: 0, animated: true)
    }
    
    // Determine which picker is being used, then return the count of its data source
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(minutePicker){
            return maxMinuteValue + 1
        } else if pickerView.isEqual(secondPicker){
            return maxSecondValue + 1
        } else {
            print("Failed Picker")
            return 0
        }
    }
    
    // Determine which picker is being used, then return the value at the given index/row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaultTimerLength: Int = (minutePicker.selectedRow(inComponent: 0) * 60) + secondPicker.selectedRow(inComponent: 0)
        UserDefaults.standard.set(defaultTimerLength, forKey: "defaultTimerLength")
    }
    
    @IBAction func mutedSwitchPressed(_ sender: Any) {
        UserDefaults.standard.set(mutedSwitch.isOn, forKey: "muted")
    }
    
    @IBAction func onSignOutPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Log out?", message: "Do you want to log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
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
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
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
