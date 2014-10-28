//
//  Flight.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/10/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class Flight: RLMObject {
    dynamic var bookingDate = NSDate()
    dynamic var cancelled = false
    dynamic var checkInReminder = false
    dynamic var confirmationCode = ""
    dynamic var cost = 0.0
    dynamic var destination = Airport()
    dynamic var fareType = ""
    dynamic var fundsUsed = RLMArray(objectClassName: TravelFund.className())
    dynamic var notes = ""
    dynamic var origin = Airport()
    dynamic var outboundArrivalDate = NSDate()
    dynamic var outboundCheckedIn = false
    dynamic var outboundDepartureDate = NSDate()
    dynamic var outboundFlightNumber = ""
    dynamic var pointsEarned = 0
    dynamic var returnArrivalDate = NSDate()
    dynamic var returnCheckedIn = false
    dynamic var returnDepartureDate = NSDate()
    dynamic var returnFlightNumber = ""
    dynamic var roundtrip = false
    dynamic var ticketNumber = ""
    dynamic var travelFund: TravelFund
    
    override convenience init() {
        self.init(travelFund: TravelFund())
    }
    
    init(travelFund: TravelFund) {
        self.travelFund = travelFund
        super.init()
        travelFund.originalFlight = self
    }
    
    func cancelFlight() {
        if let realm = realm {
            realm.transactionWithBlock({ () -> Void in
                self.cancelled = true
                self.checkInReminder = false
                self.travelFund.balance = self.cost
                self.travelFund.notes = self.notes
            })
        }
    }
    
    // MARK: View Model
    
    var airports: (Airport, Airport) {
        get {
            return (origin, destination)
        }
        set {
            (origin!, destination!) = newValue
        }
    }
    
    class func flightStringForAirports(airports: (Airport, Airport)) -> String {
        let (origin, destination) = airports
        return origin.airportCode + " -> " + destination.airportCode
    }
    
}
