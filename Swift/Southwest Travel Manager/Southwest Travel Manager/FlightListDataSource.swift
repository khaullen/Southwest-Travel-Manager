//
//  FlightListDataSource.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/20/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class FlightListDataSource: NSObject, DataSourceProtocol {
    
    var array = Flight.allObjects().arraySortedByProperty("outboundDepartureDate", ascending: true)
    let token: RLMNotificationToken = RLMNotificationToken()
    
    override init() {
        super.init()
        token = RLMRealm.defaultRealm().addNotificationBlock { [unowned self] (note, realm) -> Void in
            self.updateBlock!()
        }
    }
    
    func flightAtIndexPath(indexPath: NSIndexPath) -> Flight? {
        // TODO: validate indexPath, return nil if not valid
        return array.objectAtIndex(UInt(indexPath.row)) as? Flight
    }
    
    func reloadData() {
        array = Flight.allObjects().arraySortedByProperty("outboundDepartureDate", ascending: true)
    }
    
    // MARK: DataSourceProtocol
    
    var updateBlock: (() -> ())?
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(array?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as UITableViewCell
        let flight = array?.objectAtIndex(UInt(indexPath.row)) as Flight
        cell.textLabel?.text = flight.origin.airportCode
        cell.detailTextLabel?.text = flight.outboundDepartureDate.description
        
        return cell
    }

}
