//
//  TravelFundListDataSource.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/21/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class TravelFundListDataSource: ListDataSource {
    
    override init() {
        super.init()
        array = TravelFund.allObjects().arraySortedByProperty("expirationDate", ascending: true)
    }
    
    func travelFundAtIndexPath(indexPath: NSIndexPath) -> TravelFund? {
        return objectAtIndexPath(indexPath) as? TravelFund
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("travelFundCell", forIndexPath: indexPath) as UITableViewCell
        let travelFund = array?.objectAtIndex(UInt(indexPath.row)) as TravelFund
        cell.textLabel?.text = travelFund.originalFlight?.confirmationCode
        cell.detailTextLabel?.text = travelFund.balance.description
        
        return cell
    }
}
