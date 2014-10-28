//
//  TravelFundSelectionDataSource.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/23/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class TravelFundSelectionDataSource: TravelFundListDataSource, UITableViewDelegate {
    
    var targetAmount: Double?
    var fundSelectionState: [Bool] = []
    
    override init() {
        super.init()
        let realmArray = array?[0]
        fundSelectionState = Array(count: Int(realmArray?.count ?? 0), repeatedValue: false)
        showSummary = false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return super.tableView(tableView, numberOfRowsInSection: section)
        case 1: return 1
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            cell.accessoryType = fundSelectionState[indexPath.row] ? .Checkmark : .None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("travelFundCell", forIndexPath: indexPath) as UITableViewCell
            if let target = targetAmount {
                cell.textLabel.text = target.currencyValue
                cell.detailTextLabel?.text = "Remaining balance"
            } else {
                var realmArray = array?[0]
                var selectedFunds = [TravelFund]()
                for (index, selected) in enumerate(fundSelectionState) {
                    if (selected) {
                        selectedFunds.append(realmArray?.objectAtIndex(UInt(index)) as TravelFund)
                    }
                }
                cell.textLabel.text = selectedFunds.map({ $0.balance }).reduce(0, +).currencyValue
                cell.detailTextLabel?.text = "Total selected funds"
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            fundSelectionState[indexPath.row] = !fundSelectionState[indexPath.row]
            tableView.reloadData()
        }
    }
    
}
