//
//  SouthwestTravelManagerTests.swift
//  SouthwestTravelManagerTests
//
//  Created by Colin Regan on 10/2/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import XCTest
import Realm

class SouthwestTravelManagerTests: XCTestCase {
    
    let testRealm = RLMRealm.inMemoryRealm(withIdentifier: "test")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        testRealm?.transaction { () -> Void in
            self.testRealm?.deleteAllObjects()
        }
        super.tearDown()
    }
    
    func testCheckInReminders() {
        let testFlight = Flight()
        testFlight.checkInReminder = true
        testFlight.destination = Airport.eastCoastAirport()
        testFlight.origin = Airport.westCoastAirport()
        testFlight.roundtrip = true
        
        let dayAfterTomorrow = Date(timeIntervalSinceNow: 60 * 60 * 24 * 2)
        testFlight.outboundDepartureDate = dayAfterTomorrow
        testFlight.returnDepartureDate = dayAfterTomorrow.addingTimeInterval(60 * 60 * 24)
        
        testRealm?.transaction { () -> Void in
            self.testRealm?.add(testFlight)
        }
        
        XCTAssertEqualWithAccuracy(testFlight.outboundSegment.checkInReminder().fireDate!.timeIntervalSinceReferenceDate, dayAfterTomorrow.dateByAddingTimeInterval(-60 * 60 * 24 + -60 * 5).timeIntervalSinceReferenceDate, 1, "Should be 24 hours and 5 minutes before departure")
        XCTAssertEqualWithAccuracy(testFlight.returnSegment!.checkInReminder().fireDate!.timeIntervalSinceReferenceDate, testFlight.returnDepartureDate.dateByAddingTimeInterval(-60 * 60 * 24 + -60 * 5).timeIntervalSinceReferenceDate, 1, "Should be 24 hours and 5 minutes before departure")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension Airport {
    
    class func westCoastAirport() -> Airport {
        let a = Airport()
        a?.airportCode = "SFO"
        a?.city = "San Francisco"
        a?.state = "CA"
        a?.timeZone = "America/Los_Angeles"
        
        return a!
    }
    
    class func eastCoastAirport() -> Airport {
        let a = Airport()
        a?.airportCode = "JFK"
        a?.city = "New York"
        a?.state = "NY"
        a?.timeZone = "America/New_York"
        
        return a!
    }
    
}
