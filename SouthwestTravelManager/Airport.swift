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
    
    class func loadAirportsFromArray(array: [[String: String]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let realm = RLMRealm.defaultRealm()
            for airportDict in array {
                realm.transactionWithBlock({ () -> Void in
                    Airport.createOrUpdateInRealm(realm, withObject: airportDict)
                    return
                })
            }
        }
    }
    
    // MARK: View Model
    
    var location: String {
        return city + ", " + state
    }
    
    var timeZoneObject: NSTimeZone {
        return NSTimeZone(name: timeZone)!
    }
    
    enum StringFormat {
        case City
        case CityState
    }

    func to(destination: Airport, format: StringFormat, roundtrip: Bool) -> String {
        let arrow = roundtrip ? " ⇄ " : " → "
        switch format {
        case .City: return city + arrow + destination.city
        case .CityState: return location + arrow + destination.city
        }
    }
}
