//
//  FirstViewController.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/2/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

protocol CreationProtocol {
    
    func creator(creator: UIViewController, didCreateNewFlight flight: Flight) -> ()
    
}

class FirstViewController: UITableViewController, CreationProtocol {
    
    var array: RLMArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(array?.count ?? 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as UITableViewCell
        let flight = array?.objectAtIndex(UInt(indexPath.row)) as Flight
        cell.textLabel?.text = flight.origin.airportCode
        cell.detailTextLabel?.text = flight.outboundDepartureDate.description
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        let destination = (segue.destinationViewController as UINavigationController).topViewController as NewFlightVC
        destination.delegate = self
    }
    
    func creator(creator: UIViewController, didCreateNewFlight flight: Flight) {
        dismissViewControllerAnimated(true, completion: nil)
        
        let realm = RLMRealm.defaultRealm()
        realm.transactionWithBlock { () -> Void in
            realm.addObject(flight)
        }
        
        reloadData()
    }
    
    func reloadData() {
        array = Flight.allObjects().arraySortedByProperty("outboundDepartureDate", ascending: true)
        tableView.reloadData()
    }

}

