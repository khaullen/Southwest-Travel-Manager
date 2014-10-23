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
        // TODO: feature -- show used funds, expired funds
        array = [TravelFund.objectsWhere("balance > 0 && expirationDate > %@", NSDate()).arraySortedByProperty("expirationDate", ascending: true)]
    }
    
    func travelFundAtIndexPath(indexPath: NSIndexPath) -> TravelFund? {
        return objectAtIndexPath(indexPath) as? TravelFund
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("travelFundCell", forIndexPath: indexPath) as UITableViewCell
        let travelFund = array?[indexPath.section].objectAtIndex(UInt(indexPath.row)) as TravelFund
        cell.textLabel?.text = travelFund.balance.currencyValue
        if let confirmationCode = travelFund.originalFlight?.confirmationCode {
            cell.detailTextLabel?.text = confirmationCode + " (" + NSDateFormatter.localizedStringFromDate(travelFund.expirationDate, dateStyle: .ShortStyle, timeStyle: .NoStyle) + ")"
        }
        
        return cell
    }
}
