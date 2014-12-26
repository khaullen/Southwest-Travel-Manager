//
//  AppDelegate.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/2/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

// TODO: add analytics
// TODO: return to go next field
// TODO: electronic boarding pass management (QR code)
// TODO: pull down to do stuff

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let notificationManager = NotificationManager.sharedManager // initializes singleton

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let airportsPath = NSBundle.mainBundle().pathForResource("airports", ofType: "plist")
            let allAirports = NSArray(contentsOfFile: airportsPath!)
            
            let realm = RLMRealm.defaultRealm()
            // FIXME: shouldn't need to re-add all flights on each launch
            // TODO: pull airports.plist from a server
            allAirports?.enumerateObjectsUsingBlock { (airportDict, index, stop) -> Void in
                realm.transactionWithBlock({ () -> Void in
                    Airport.createOrUpdateInRealm(realm, withObject: airportDict)
                    return
                })
            }
        })
        
        // TODO: add check in action
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Badge | .Sound | .Alert, categories: nil))
        
        let a: UILocalNotification? = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification
        println("Launched with notification: \(a)")

        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        // TODO: do something if these notifications are not sufficient
        println(notificationSettings)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // TODO: route to relevant view controller
        println(notification)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

