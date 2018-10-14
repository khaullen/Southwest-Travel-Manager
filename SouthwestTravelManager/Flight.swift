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
    dynamic var bookingDate = Date()
    dynamic var cancelled = false
    dynamic var checkInReminder = false
    dynamic var confirmationCode = ""
    dynamic var cost = 0.0
    dynamic var destination = Airport()
    dynamic var fareType = ""
    dynamic var fundsUsed = RLMArray(objectClassName: TravelFund.className())
    dynamic var notes = ""
    dynamic var origin = Airport()
    dynamic var outboundArrivalDate = Date()
    dynamic var outboundCheckedIn = false
    dynamic var outboundDepartureDate = Date()
    dynamic var outboundFlightNumber = ""
    dynamic var pointsEarned = 0
    dynamic var returnArrivalDate = Date()
    dynamic var returnCheckedIn = false
    dynamic var returnDepartureDate = Date()
    dynamic var returnFlightNumber = ""
    dynamic var roundtrip = false
    dynamic var ticketNumber = ""
    dynamic var travelFund: TravelFund
    dynamic var uuid = UUID().uuidString
    
    var checkInURL: URL {
        // TODO: request name if not available
        let passenger = Passenger.defaultPassenger
        return URL(string: "https://www.southwest.com/flight/retrieveCheckinDoc.html?forceNewSession=yes&firstName=" + passenger.firstName.uppercased() + "&lastName=" + passenger.lastName.uppercased() + "&confirmationNumber=" + confirmationCode)!
    }
    
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
    
    func useFunds(_ funds: [TravelFund: Double]) {
        // No support for modifying funds used after creation
        if persistedState == .new {
            for (fund, amountApplied) in funds {
                fund.balance -= amountApplied
                fund.unusedTicket = false
            }
            fundsUsed?.addObjects(Array(funds.keys) as NSFastEnumeration)
        }
    }
    
    func checkIn() {
        UIApplication.shared.openURL(checkInURL)
        // TODO: mark segment as checked in?
    }
    
    func cancelFlight() {
        if let realm = realm {
            realm.transaction({ () -> Void in
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
            return (origin!, destination!)
        }
        set {
            (origin!, destination!) = newValue
        }
    }
    
    override var copyString: String? {
        return confirmationCode
    }
    
    // MARK: Queries
    
    class var futureFlights: RLMResults {
        return Flight.objectsWhere("cancelled == false && (outboundDepartureDate > %@ OR (roundtrip == true && returnDepartureDate > %@))", Date(), Date()).sortedResultsUsingProperty("outboundDepartureDate", ascending: true)
    }
    
}



extension Flight {
    
    struct Segment {
        
        let airportA: Airport
        let airportB: Airport
        let arrivalDate: Date
        let checkedIn: Bool
        let departureDate: Date
        let flightNumber: String
        
        var checkInAvailable: Bool {
            return !checkedIn && departureDate.timeIntervalSinceNow < 60 * 60 * 24 /* one day */ && departureDate.timeIntervalSinceNow > 0
        }
        
        func checkInReminder() -> UILocalNotification {
            let reminder = UILocalNotification()
            reminder.fireDate = departureDate.addingTimeInterval((-60 * 5) /* five minutes */ + (-60 * 60 * 24) /* and one day */)
            // NOTE: do not set timeZone attribute -- http://stackoverflow.com/questions/18424569/understanding-uilocalnotification-timezone
            reminder.alertBody = "Check in for \(airportA.to(airportB, format: .city, roundtrip: false))"
            reminder.alertAction = "Check In"
            reminder.soundName = "Radar.aiff"
            
            return reminder
        }
        
    }
    
    var outboundSegment: Segment {
        return Segment(airportA: origin!, airportB: destination!, arrivalDate: outboundArrivalDate, checkedIn: outboundCheckedIn, departureDate: outboundDepartureDate, flightNumber: outboundFlightNumber)
    }
    
    var returnSegment: Segment? {
        return roundtrip ? Segment(airportA: destination!, airportB: origin!, arrivalDate: returnArrivalDate, checkedIn: returnCheckedIn, departureDate: returnDepartureDate, flightNumber: returnFlightNumber) : nil
    }
    
    var segments: [Segment] {
        if let returnSegment = returnSegment {
            return [outboundSegment, returnSegment]
        } else {
            return [outboundSegment]
        }
    }
    
}
