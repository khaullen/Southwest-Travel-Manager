//
//  TravelFundListDataSource.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/21/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class TravelFundListDataSource: NSObject, DataSourceProtocol {
    var array = TravelFund.allObjects().arraySortedByProperty("expirationDate", ascending: true)
    var token: RLMNotificationToken?
    
    func travelFundAtIndexPath(indexPath: NSIndexPath) -> TravelFund? {
        // TODO: validate indexPath, return nil if not valid
        return array.objectAtIndex(UInt(indexPath.row)) as? TravelFund
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
        let cell = tableView.dequeueReusableCellWithIdentifier("travelFundCell", forIndexPath: indexPath) as UITableViewCell
        let travelFund = array?.objectAtIndex(UInt(indexPath.row)) as TravelFund
        cell.textLabel?.text = travelFund.originalFlight?.confirmationCode
        cell.detailTextLabel?.text = travelFund.balance.description
        
        return cell
    }
}
