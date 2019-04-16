//
//  TimerViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/27/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the timer's view controller

import UIKit
import Foundation

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var minutePicker: UIPickerView!
    @IBOutlet weak var secondPicker: UIPickerView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var timer: GlobalTimer = GlobalTimer.sharedTimer
    let minutePickerValues: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    let secondPickerValues: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if timer.isRunning() {
            updateCountdownLabel(timeLeft: timer.timeLeft!)
        } else {
            updateCountdownLabel(timeLeft: 0)
        }
        minutePicker.dataSource = self
        minutePicker.delegate = self
        secondPicker.dataSource = self
        secondPicker.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(timerTick), name: NSNotification.Name("timerTick"), object: nil)
        
    }
    
    @objc func timerTick(notification: Notification){
        let timeLeft = notification.userInfo!["timeLeft"] as! Int
        DispatchQueue.main.async {
            self.updateCountdownLabel(timeLeft: timeLeft)
        }
    }
    
    func updateCountdownLabel(timeLeft: Int){
        let minutesLeft = timeLeft / 60
        let secondsLeft = timeLeft % 60
        self.countdownLabel.text = String(format: "%02d:%02d", minutesLeft, secondsLeft)
    }
    
    @IBAction func onStartPressed(_ sender: UIButton) {
        let minutes: Int!
        let seconds: Int!
        var duration: Int = 0
        
        if timer.isPaused() {
            timer.resumeTimer()
        } else if !timer.isRunning() {
            minutes = self.minutePicker.selectedRow(inComponent: 0)
            seconds = self.secondPicker.selectedRow(inComponent: 0)
            duration = (minutes * 60) + seconds
            timer.startTimer(duration: duration)
            updateCountdownLabel(timeLeft: duration)
        }
    }
    
    @IBAction func onPausePressed(_ sender: Any) {
        if timer.isRunning() {
            timer.pauseTimer()
        }
    }
    
    @IBAction func onStopPressed(_ sender: Any) {
        if timer.isRunning() {
            timer.stopTimer()
            updateCountdownLabel(timeLeft: 0)
        }
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
}
