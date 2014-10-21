//
//  FlightListDataSource.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/20/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class FlightListDataSource: ListDataSource, DataSourceProtocol {
    
    var array = Flight.allObjects().arraySortedByProperty("outboundDepartureDate", ascending: true)
    var token: RLMNotificationToken?
    
    func flightAtIndexPath(indexPath: NSIndexPath) -> Flight? {
        // TODO: validate indexPath, return nil if not valid
        return array.objectAtIndex(UInt(indexPath.row)) as? Flight
    }
    
    // MARK: DataSourceProtocol
    
    func setUpdateBlock(block: RLMNotificationBlock) -> () {
        token = RLMRealm.defaultRealm().addNotificationBlock(block)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(array?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as UITableViewCell
        let flight = array?.objectAtIndex(UInt(indexPath.row)) as Flight
        cell.textLabel?.text = flight.origin.location + " -> " + flight.destination.location
        cell.detailTextLabel?.text = Flight.fullDepartureStringForDate(flight.outboundDepartureDate)
        
        return cell
    }

}
