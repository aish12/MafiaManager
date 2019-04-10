//
//  TimerViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/27/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the timer's view controller

import UIKit

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var minutePicker: UIPickerView!
    @IBOutlet weak var secondPicker: UIPickerView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var timerStarted: Bool = false
    var paused: Bool = false
    var timeLeft: Int = 0
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        timerStarted = false
        self.countdownLabel.text = "00:00"
        TimerManager.stop()
        timeLeft = 0
    }
    
    @IBAction func onStartPressed(_ sender: UIButton) {
        let minute: Int!
        let second: Int!
        var duration: Int = 0
        
        if !timerStarted {
            minute = self.minutePicker.selectedRow(inComponent: 0)
            second = self.secondPicker.selectedRow(inComponent: 0)
            duration = (minute * 60) + second
            timerStarted = true
            
            if timeLeft > 0 {
                duration = timeLeft - 1
            }
            
            TimerManager.timeString = { time, ends in
                if ends == false {
                    self.countdownLabel.text = time
                }
            }
            TimerManager.start(withSeconds: duration)
        } else if paused {
            paused = false
            if timeLeft > 0 {
                duration = timeLeft - 1
            }
            
            TimerManager.timeString = { time, ends in
                if ends == false {
                    self.countdownLabel.text = time
                }
            }
            TimerManager.start(withSeconds: duration)
        }
    }
    
    @IBAction func onPausePressed(_ sender: Any) {
        if timerStarted {
            timeLeft = TimerManager.stop()
            paused = true
        }
    }
    
    @IBAction func onStopPressed(_ sender: Any) {
        timerStarted = false
        self.countdownLabel.text = "00:00"
        TimerManager.stop()
        timeLeft = 0
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
