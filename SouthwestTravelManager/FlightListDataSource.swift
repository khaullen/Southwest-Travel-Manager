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
        array = [Flight.futureFlights]
    }
    
    func flightAtIndexPath(indexPath: NSIndexPath) -> Flight? {
        return objectAtIndexPath(indexPath) as? Flight
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(super.tableView(tableView, numberOfRowsInSection: section), 1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let flight = flightAtIndexPath(indexPath) {
            let cell = tableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = flight.origin.to(flight.destination, format: .CityState, roundtrip: flight.roundtrip)
            cell.detailTextLabel?.text = flight.outboundDepartureDate.departureStringWithStyle(.FullStyle, inTimeZone: flight.origin.timeZoneObject)
            return cell
        } else {
            return tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! UITableViewCell
        }
    }

}
