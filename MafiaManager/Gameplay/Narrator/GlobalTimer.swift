//
//  Timer.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/16/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import Foundation

class GlobalTimer: NSObject {
    static let sharedTimer: GlobalTimer = {
        let timer = GlobalTimer()
        return timer
    }()
    
    var internalTimer: Timer?
    var timeLeft: Int?
    
    func startTimer(duration: Int) {
        if internalTimer != nil {
            internalTimer?.invalidate()
        }
        self.timeLeft = duration
        internalTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(timer: Timer) in
                self.timerTick()
        })
    }
    
    func resumeTimer() {
        if internalTimer != nil {
            internalTimer?.invalidate()
        }
        internalTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(timer: Timer) in
            self.timerTick()
        })
    }
    
    func pauseTimer() {
        guard internalTimer != nil else {
            print("No timer active, start the timer before you stop it.")
            return
        }
        internalTimer?.invalidate()
    }
    
    func stopTimer() {
        guard internalTimer != nil else {
            print("No timer active, start the timer before you stop it.")
            return
        }
        internalTimer?.invalidate()
        internalTimer = nil
        timeLeft = 0
    }
    
    @objc func timerTick(){
        timeLeft = timeLeft! - 1
        if timeLeft == 0 {
            stopTimer()
        }
        NotificationCenter.default.post(name: NSNotification.Name("timerTick"), object: nil, userInfo: ["timeLeft": timeLeft!])
    }
    
    func isRunning() -> Bool {
        return internalTimer != nil
    }
    
    func isPaused() -> Bool {
        return internalTimer != nil && !(internalTimer!.isValid)
    }
    
    func timeAsString() -> String {
        return String(format: "%02d:%02d", timeLeft!/60, timeLeft!%60)
    }
}
