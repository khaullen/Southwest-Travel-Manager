//
//  NotificationManager.swift
//  SouthwestTravelManager
//
//  Created by Colin Regan on 11/12/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import Foundation
import UIKit
import Realm

class NotificationManager {
    
    class var sharedManager: NotificationManager {
        struct Static {
            static let instance: NotificationManager = NotificationManager()
        }
        return Static.instance
    }
    
    let operationQueue: NSOperationQueue
    let token: RLMNotificationToken
    
    init() {
        let queue = NSOperationQueue()
        token = RLMRealm.defaultRealm().addNotificationBlock { (_, _) in
            let operation = LocalNotificationOperation()
            queue.addOperation(operation)
        }
        operationQueue = queue
    }
    
}


class LocalNotificationOperation: NSOperation {
    
    let realm: RLMRealm
    
    init(realm: RLMRealm) {
        self.realm = realm
        super.init()
    }
    
    override convenience init() {
        self.init(realm: RLMRealm.defaultRealm())
    }
    
    override func main() {
        
        // Needed to refetch realm in background thread
        let backgroundRealm = RLMRealm(path: realm.path)
        
        // TODO: feature -- add periodic notifications to use funds
        // TODO: feature -- reminder to cancel flights if not checked in
        
        // Check in alerts
        let predicate = "checkInReminder == true && cancelled == false && (outboundDepartureDate > %@ OR (roundtrip == true && returnDepartureDate > %@))"
        let allFlights = Flight.objectsInRealm(backgroundRealm, predicate, NSDate(), NSDate()).sortedResultsUsingProperty("outboundDepartureDate", ascending: true)
        let notifications = swiftArray(allFlights).map({ (f: Flight) -> [UILocalNotification] in
            return f.segments.map({ (s: Flight.Segment) -> UILocalNotification in
                return s.checkInReminder()
            })
        }).flattenAny()
        
        UIApplication.sharedApplication().scheduledLocalNotifications = notifications
        println(UIApplication.sharedApplication().scheduledLocalNotifications)
    }
    
}

