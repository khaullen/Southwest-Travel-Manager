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
    
    var showSummary = true
    
    override init() {
        super.init()
        // TODO: show used funds, expired funds
        array = [TravelFund.objectsWhere("balance > 0 && expirationDate > %@", NSDate()).sortedResultsUsingProperty("expirationDate", ascending: true)]
    }
    
    func travelFundAtIndexPath(indexPath: NSIndexPath) -> TravelFund? {
        return objectAtIndexPath(indexPath) as? TravelFund
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let superRows = super.tableView(tableView, numberOfRowsInSection: section)
        let showSummaryRow = (section == 0) && showSummary
        return superRows + Int(showSummaryRow)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let travelFund = travelFundAtIndexPath(indexPath) {
            let cell = tableView.dequeueReusableCellWithIdentifier("travelFundCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = travelFund.balance.currencyValue
            if let confirmationCode = travelFund.originalFlight?.confirmationCode {
                cell.detailTextLabel?.text = confirmationCode + " (" + NSDateFormatter.localizedStringFromDate(travelFund.expirationDate, dateStyle: .ShortStyle, timeStyle: .NoStyle) + ")"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("summaryCell", forIndexPath: indexPath) as UITableViewCell
            let subarray = array[indexPath.section]
            let sumOfFunds = map(subarray, { ($0 as TravelFund).balance }).reduce(0, +)
            let count = subarray.count
            cell.textLabel?.text = String(subarray.count) + " Fund" + (count > 1 ? "s, " : ", ") + (sumOfFunds.currencyValue ?? "")
            return cell
        }
    }
}
