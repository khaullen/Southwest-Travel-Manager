//
//  Airport.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/13/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class Airport: RLMObject {
    dynamic var airportCode = ""
    dynamic var city = ""
    dynamic var state = ""
    dynamic var timeZone = ""
    
    override class func primaryKey() -> String {
        return "airportCode"
    }
    
    // MARK: Utility methods
    
    // TODO: should replace airports instead of just adding missing ones so that discontinued ones are removed
    class func loadAirportsFromArray(_ array: [[String: String]]) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let realm = RLMRealm.default()
            for airportDict in array {
                realm?.transaction({ () -> Void in
                    Airport.createOrUpdate(in: realm, with: airportDict)
                    return
                })
            }
        }
    }
    
    // MARK: View Model
    
    var location: String {
        return city + ", " + state
    }
    
    var timeZoneObject: TimeZone {
        return TimeZone(name: timeZone)!
    }
    
    enum StringFormat {
        case city
        case cityState
    }

    func to(_ destination: Airport, format: StringFormat, roundtrip: Bool) -> String {
        let arrow = roundtrip ? " ⇄ " : " → "
        switch format {
        case .city: return city + arrow + destination.city
        case .cityState: return location + arrow + destination.location
        }
    }
}
