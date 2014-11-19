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
    
    override func main() {
        
        let realm = RLMRealm.defaultRealm()
        println(realm)
        
        // TODO: feature -- add periodic notifications to use funds
        // TODO: feature -- reminder to cancel flights if not checked in
        
        // Check in alerts
        let allFlights = Flight.objectsWhere("checkInReminder == true && cancelled == false && (outboundDepartureDate > %@ OR (roundtrip == true && returnDepartureDate > %@))", NSDate(), NSDate()).arraySortedByProperty("outboundDepartureDate", ascending: true)
        let notifications = allFlights.swiftArray().map({ (f: Flight) -> [UILocalNotification] in
            return f.segments.map({ (s: Segment) -> UILocalNotification in
                return s.checkInReminder()
            })
        }).flattenAny()
        
        UIApplication.sharedApplication().scheduledLocalNotifications = notifications
    }
    
}

