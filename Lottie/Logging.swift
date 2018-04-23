//
//  Logging.swift
//  Lottie_iOS
//
//  Created by Russell Tan on 4/23/18.
//  Copyright © 2018 Airbnb. All rights reserved.
//

import Foundation

class Logging {
    static var StartTime : NSDate?
    static func Log(message: String) {
        print(message)
    }
    
    static func LogTime(message: String) {
        let endTime = NSDate()
        if StartTime != nil {
            let timeInterval: Double = endTime.timeIntervalSince(StartTime! as Date)
            print("\(message) , \(timeInterval)")
        }
        StartTime = nil
    }
}
