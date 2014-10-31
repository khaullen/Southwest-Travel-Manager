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
    
    // MARK: View Model
    
    var location: String {
        return city + ", " + state
    }
    
    var timeZoneObject: NSTimeZone {
        return NSTimeZone(name: timeZone)!
    }
}
