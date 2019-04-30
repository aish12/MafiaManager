//
//  HelperFunctions.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/25/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import Foundation


class HelperFunctions: NSObject {

    static var userName: String?
    
    static func convertToString (dateString: String, formatIn : String, formatOut : String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        dateFormater.dateFormat = formatIn
        let date = dateFormater.date(from: dateString)
        
        dateFormater.timeZone = NSTimeZone.system
        
        dateFormater.dateFormat = formatOut
        let timeStr = dateFormater.string(from: date!)
        return timeStr
    }
}
