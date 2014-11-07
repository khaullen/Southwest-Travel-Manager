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
    var orderedFunds: [TravelFund] {
        return selectedFunds.sortBy({ (first: TravelFund, second: TravelFund) -> Bool in
            return first.unusedTicket > second.unusedTicket || (first.unusedTicket == second.unusedTicket && first.expirationDate < second.expirationDate)
        })
    }
    
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
            let fund = travelFundAtIndexPath(indexPath)!
            cell.textLabel.text = availableBalanceForFund(fund).currencyValue
            cell.accessoryType = selectionStateForFund(fund) ? .Checkmark : .None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("travelFundCell", forIndexPath: indexPath) as UITableViewCell
            if let target = targetAmount {
                cell.textLabel.text = max(target - selectedFunds.map({ $0.balance }).reduce(0, +), 0).currencyValue
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
    // TODO: feature -- add "Create new fund" button to bottom
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            if let selected = travelFundAtIndexPath(indexPath) {
                toggleSelectionForFund(selected)
                tableView.reloadData()
            }
        }
    }
    
    // MARK: Custom logic
    
    func selectionStateForFund(fund: TravelFund) -> Bool {
        return contains(selectedFunds, fund)
    }
    
    func toggleSelectionForFund(fund: TravelFund) -> Bool {
        if (contains(selectedFunds, fund)) {
            selectedFunds.remove(fund)
            return false
        } else {
            selectedFunds.append(fund)
            return true
        }
    }
    
    func availableBalanceForFund(fund: TravelFund) -> Double {
        if let target = targetAmount {
            let fundIndex = orderedFunds.indexOf(fund)
            if let index = fundIndex {
                let remainingBalance = target - orderedFunds[0...index].map({ $0.balance }).reduce(0, +) + fund.balance
                return max(fund.balance - remainingBalance, 0)
            }
        }
        
        return contains(selectedFunds, fund) ? 0 : fund.balance
    }
    
}
