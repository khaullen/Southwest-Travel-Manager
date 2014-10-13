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
}
