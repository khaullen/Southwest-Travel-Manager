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
    var selectedFunds: [Bool] = []
    
    override init() {
        super.init()
        let realmArray = array?[0]
        selectedFunds = Array(count: Int(realmArray?.count ?? 0), repeatedValue: false)
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
            cell.accessoryType = selectedFunds[indexPath.row] ? .Checkmark : .None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("travelFundCell", forIndexPath: indexPath) as UITableViewCell
            if let target = targetAmount {
                cell.detailTextLabel?.text = "Remaining balance"
            } else {
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
            selectedFunds[indexPath.row] = !selectedFunds[indexPath.row]
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
}
