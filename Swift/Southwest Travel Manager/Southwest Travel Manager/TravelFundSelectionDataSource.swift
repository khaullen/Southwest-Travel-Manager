//
//  TravelFundSelectionDataSource.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/23/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class TravelFundSelectionDataSource: TravelFundListDataSource {
    
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
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("travelFundCell", forIndexPath: indexPath) as UITableViewCell
            cell.detailTextLabel?.text = "Remaining balance"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
