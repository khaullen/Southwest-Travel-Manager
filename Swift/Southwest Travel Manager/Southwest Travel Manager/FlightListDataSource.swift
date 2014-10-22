//
//  FlightListDataSource.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/20/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class FlightListDataSource: ListDataSource {
    
    override init() {
        super.init()
        array = Flight.allObjects().arraySortedByProperty("outboundDepartureDate", ascending: true)
    }
    
    func flightAtIndexPath(indexPath: NSIndexPath) -> Flight? {
        return objectAtIndexPath(indexPath) as? Flight
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as UITableViewCell
        let flight = array?.objectAtIndex(UInt(indexPath.row)) as Flight
        cell.textLabel?.text = flight.origin.location + " -> " + flight.destination.location
        cell.detailTextLabel?.text = flight.outboundDepartureDate.fullDepartureString
        
        return cell
    }

}
