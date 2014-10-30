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
    var selectedFunds: [TravelFund] = []
    
    override init() {
        super.init()
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
            cell.accessoryType = contains(selectedFunds, travelFundAtIndexPath(indexPath)!) ? .Checkmark : .None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("travelFundCell", forIndexPath: indexPath) as UITableViewCell
            if let target = targetAmount {
                cell.textLabel.text = target.currencyValue
                cell.detailTextLabel?.text = "Remaining balance"
            } else {
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
            if let selected = travelFundAtIndexPath(indexPath) {
                // TODO: refactor after adding ExSwift
                if (contains(selectedFunds, selected)) {
                    var indexOfFund = -1
                    for (index, fund) in enumerate(selectedFunds) {
                        if (fund == selected) {
                            indexOfFund = index
                        }
                    }
                    selectedFunds.removeAtIndex(indexOfFund)
                } else {
                    selectedFunds.append(travelFundAtIndexPath(indexPath)!)
                }
                tableView.reloadData()
            }
        }
    }
    
}
