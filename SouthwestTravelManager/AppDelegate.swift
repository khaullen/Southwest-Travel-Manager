//
//  AppDelegate.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/2/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm
import Alamofire

// TODO: add analytics
// TODO: return to go next field
// TODO: electronic boarding pass management (QR code)
// TODO: pull down to do stuff

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let notificationManager = NotificationManager.sharedManager // initializes singleton

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Load Airports into database
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let bundleVersionKey = "LAST_VERSION_AIRPORT_LOAD"
            let lastVersionLoad = NSUserDefaults.standardUserDefaults().stringForKey(bundleVersionKey)
            
            // if no lastVersionLoad or lastVersionLoad is different than current version, load from bundle, then update NSUserDefaults
            if !(lastVersionLoad? == NSBundle.mainBundle().versionString) {
                let airportsPath = NSBundle.mainBundle().pathForResource("airports", ofType: "plist")
                let allAirports = NSArray(contentsOfFile: airportsPath!) as [[String: String]]
                // FIXME: there may be an issue with loading airports simultaneously from two different threads. first try fixing by updating Realm and checking the changelog, otherwise just serialize this instead of letting them run in parallel
                Airport.loadAirportsFromArray(allAirports)
                
                NSUserDefaults.standardUserDefaults().setObject(NSBundle.mainBundle().versionString, forKey: bundleVersionKey)
            }
            
            let networkFetchKey = "LAST_AIRPORT_FETCH"
            let lastFetchDate = NSUserDefaults.standardUserDefaults().objectForKey(networkFetchKey) as NSDate?
            
            // if lastFetchDate does not exist or lastFetchDate is older than x days old, load from network
            if !(lastFetchDate?.timeIntervalSinceNow > -60 * 60 * 24 * 3) {
                
                Alamofire.request(.GET, "https://raw.githubusercontent.com/khaullen/Southwest-Travel-Manager/swift/SouthwestTravelManager/airports.plist").responsePropertyList({ (_, _, data, _) -> Void in
                    if let airports = data as? [[String: String]] {
                        Airport.loadAirportsFromArray(airports)
                        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: networkFetchKey)
                    }
                })
            }
            
        }
        
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

