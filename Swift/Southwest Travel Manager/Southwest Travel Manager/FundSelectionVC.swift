//
//  FundSelectionVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/23/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class FundSelectionVC: UITableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView(tableView, didChangeSelectionState: true, forRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView(tableView, didChangeSelectionState: false, forRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didChangeSelectionState selected: Bool, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = selected ? .Checkmark : .None
        }
    }

}
