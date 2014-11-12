//
//  NotificationManager.swift
//  SouthwestTravelManager
//
//  Created by Colin Regan on 11/12/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import Foundation
import Realm

class NotificationManager {
    
    class var sharedManager: NotificationManager {
        struct Static {
            static let instance: NotificationManager = NotificationManager()
        }
        return Static.instance
    }
    
    let token = RLMRealm.defaultRealm().addNotificationBlock { (note, realm) -> Void in
        println(realm)
    }
    
}

