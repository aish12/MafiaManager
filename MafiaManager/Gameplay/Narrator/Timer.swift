//
//  Timer.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/10/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import Foundation
import UIKit

class TimerManager: NSObject {
    
    static var timer: Timer?
    static private var seconds = 0
    static var timeString: ((_ value: String?, _ ends: Bool) -> Void)?
    
    static func start(withSeconds: Int) {
        // For some reason, doesn't start at the time clicked
        seconds = withSeconds
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(TimerManager.update), userInfo: nil, repeats: true)
        
        let value = getString(from: TimeInterval(seconds))
        timeString?(value, false)
    }
    
    @objc static func update() {
        if seconds == 0 {
            timer?.invalidate()
            timeString?(nil, true)
        } else {
            seconds -= 1
            let value = getString(from: TimeInterval(seconds))
            timeString?(value, false)
        }
    }
    
    static func stop() -> Int {
        timer?.invalidate()
        timeString?(nil, true)
        return seconds
    }
    
    static private func getString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes,seconds)
    }
    
    static func destroy() -> Void {
        timer?.invalidate()
        timer = nil
    }
    
}
