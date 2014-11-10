//
//  TravelFund.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/13/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class TravelFund: RLMObject {
    dynamic var balance = 0.0
    dynamic var expirationDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 365)
    dynamic var notes = ""
    dynamic var originalFlight: Flight?
    dynamic var unusedTicket = true
    dynamic var uuid = NSUUID().UUIDString
    
    override class func primaryKey() -> String {
        return "uuid"
    }
    
    override init() {
        super.init()
        self.originalFlight = Flight(travelFund: self)
        self.originalFlight?.cancelled = true
    }

    // MARK: View Model
    
    class func expirationStringForDate(date: NSDate) -> String {
        return expirationDateFormatter.stringFromDate(date)
    }
    
}

private let expirationDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    return formatter
}()


// Allows TravelFunds to be used as keys within dictionaries
extension TravelFund: Hashable {
    
    // TODO: fix this hack
    override var hashValue: Int {
        return Int(expirationDate.timeIntervalSinceReferenceDate)
    }
    
}

// For some reason, the == function is not inherited from RLMObject
func ==(lhs: TravelFund, rhs: TravelFund) -> Bool {
    return lhs.isEqualToObject(rhs)
}

