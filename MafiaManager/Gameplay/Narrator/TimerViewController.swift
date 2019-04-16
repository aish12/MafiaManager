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
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var pickerStackView: UIStackView!
    
    let maxMinuteValue: Int = 15
    let maxSecondValue: Int = 59
    var timer: GlobalTimer = GlobalTimer.sharedTimer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPickerOrCountdown()
        minutePicker.dataSource = self
        minutePicker.delegate = self
        secondPicker.dataSource = self
        secondPicker.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(timerTick), name: NSNotification.Name("timerTick"), object: nil)
        
    }
    
    func showPickerOrCountdown(){
        if timer.isRunning() {
            updateCountdownLabel(timeLeft: timer.timeLeft!)
            countdownLabel.isHidden = false
            pickerStackView.isHidden = true
//            minutePicker.isHidden = true
//            secondPicker.isHidden = true
            
        } else {
            countdownLabel.isHidden = true
            pickerStackView.isHidden = false
//            minutePicker.isHidden = false
//            secondPicker.isHidden = false
        }
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
            showPickerOrCountdown()
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
            showPickerOrCountdown()
        }
    }
    
    // For both minute and second, they only have one component, always return 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
}
