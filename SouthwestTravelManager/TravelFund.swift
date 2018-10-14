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
    dynamic var expirationDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 365)
    dynamic var notes = ""
    dynamic var originalFlight: Flight?
    dynamic var unusedTicket = true
    dynamic var uuid = UUID().uuidString
    
    override class func primaryKey() -> String {
        return "uuid"
    }
    
    override init() {
        super.init()
        self.originalFlight = Flight(travelFund: self)
        self.originalFlight?.cancelled = true
    }

    // MARK: View Model
    
    class func expirationStringForDate(_ date: Date) -> String {
        return expirationDateFormatter.string(from: date)
    }
    
    override var copyString: String? {
        return originalFlight?.confirmationCode
    }

}

private let expirationDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}()


// Allows TravelFunds to be used as keys within dictionaries
extension TravelFund: Hashable {
    
    override var hashValue: Int {
        return uuid.hashValue
    }
    
}

// For some reason, the == function is not inherited from RLMObject
func ==(lhs: TravelFund, rhs: TravelFund) -> Bool {
    return lhs.isEqual(to: rhs)
}

