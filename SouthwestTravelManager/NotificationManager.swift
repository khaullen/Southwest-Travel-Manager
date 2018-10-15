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
    
    let operationQueue: OperationQueue
    let token: RLMNotificationToken
    
    init() {
        let queue = OperationQueue()
        token = RLMRealm.default().addNotificationBlock { (_, _) in
            // FIXME: Excessive jobs added to queue on launch, likely due to Airport job
            let operation = LocalNotificationOperation()
            queue.addOperation(operation)
        }
        operationQueue = queue
    }
    
}


class LocalNotificationOperation: Operation {
    
    override func main() {
        
        // Needed to refetch realm in background thread
        _ = RLMRealm.default()
        
        // TODO: add periodic notifications to use funds
        // TODO: reminder to cancel flights if not checked in
        
        // Check in alerts
        let allFlights = Flight.futureFlights.objectsWhere("checkInReminder == true")
        // FIXME: shouldn't need swiftArray since allFlights is a sequence type
        let notifications = swiftArray(allFlights).map({ (f: Flight) -> [UILocalNotification] in
            return f.segments.map({ (s: Flight.Segment) -> UILocalNotification in
                return s.checkInReminder()
            })
        }).joined()
        
        UIApplication.shared.scheduledLocalNotifications = Array(notifications)
        print(UIApplication.shared.scheduledLocalNotifications ?? [])
    }
    
}

