//
//  ListVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/2/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

protocol EditDelegate {
    
    func editor(editor: UIViewController, didCreateNewObject object: RLMObject) -> ()
    func editor(editor: UIViewController, didUpdateObject object: RLMObject) -> ()
    
}

class ListVC: UITableViewController, EditDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = tableView.dataSource as? ListDataSource
        dataSource?.setUpdateBlock {
            [unowned self] (_, _) in
            self.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        let inputViewController = (segue.destinationViewController as? InputVC) ?? (segue.destinationViewController as? UINavigationController)?.topViewController as? InputVC
        inputViewController?.delegate = self

        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)
            if let indexPath = indexPath {
                let dataSource = tableView.dataSource as? ListDataSource
                let object = dataSource?.objectAtIndexPath(indexPath)
                if let object = object {
                    inputViewController?.setObject(object)
                }
            }
        }
    }
    
    func editor(editor: UIViewController, didCreateNewObject object: RLMObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editor(editor: UIViewController, didUpdateObject object: RLMObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let dataSource = tableView.dataSource as? ListDataSource
        return dataSource?.objectAtIndexPath(indexPath) != nil
    }
    
    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject) -> Bool {
        return (NSStringFromSelector(action) == "copy:")
    }
    
    override func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
        if (NSStringFromSelector(action) == "copy:") {
            let dataSource = tableView.dataSource as? ListDataSource
            let object = dataSource?.objectAtIndexPath(indexPath)
            UIPasteboard.generalPasteboard().string = object?.copyString
        }
    }

}

