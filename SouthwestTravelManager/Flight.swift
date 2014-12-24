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
    dynamic var uuid = NSUUID().UUIDString
    
    override class func primaryKey() -> String {
        return "uuid"
    }

    override convenience init() {
        self.init(travelFund: TravelFund())
    }
    
    init(travelFund: TravelFund) {
        self.travelFund = travelFund
        super.init()
        travelFund.originalFlight = self
    }
    
    func useFunds(funds: [TravelFund: Double]) {
        // No support for modifying funds used after creation
        if persistedState == .New {
            for (fund, amountApplied) in funds {
                fund.balance -= amountApplied
                fund.unusedTicket = false
            }
            fundsUsed.addObjects(Array(funds.keys))
        }
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
    
}



extension Flight {
    
    struct Segment {
        
        let airportA: Airport
        let airportB: Airport
        let arrivalDate: NSDate
        let checkedIn: Bool
        let departureDate: NSDate
        let flightNumber: String
        
        // TODO: feature -- add custom sound (up to 30 seconds, aiff/wav)
        // afconvert /System/Library/Sounds/Submarine.aiff ~/Desktop/sub.caf -d ima4 -f caff -v
        
        func checkInReminder() -> UILocalNotification {
            let reminder = UILocalNotification()
            reminder.fireDate = departureDate.dateByAddingTimeInterval((-60 * 5) /* five minutes */ + (-60 * 60 * 24) /* and one day */)
            // NOTE: do not set timeZone attribute -- http://stackoverflow.com/questions/18424569/understanding-uilocalnotification-timezone
            reminder.alertBody = "Check in for \(airportA.to(airportB, format: .City, roundtrip: false))"
            reminder.alertAction = "Check In"
            reminder.soundName = UILocalNotificationDefaultSoundName
            
            return reminder
        }
        
    }
    
    var outboundSegment: Segment {
        return Segment(airportA: origin, airportB: destination, arrivalDate: outboundArrivalDate, checkedIn: outboundCheckedIn, departureDate: outboundDepartureDate, flightNumber: outboundFlightNumber)
    }
    
    var returnSegment: Segment? {
        return roundtrip ? Segment(airportA: destination, airportB: origin, arrivalDate: returnArrivalDate, checkedIn: returnCheckedIn, departureDate: returnDepartureDate, flightNumber: returnFlightNumber) : nil
    }
    
    var segments: [Segment] {
        if let returnSegment = returnSegment {
            return [outboundSegment, returnSegment]
        } else {
            return [outboundSegment]
        }
    }
    
}
