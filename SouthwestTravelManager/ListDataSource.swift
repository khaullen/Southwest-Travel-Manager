//
//  ListDataSource.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/21/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class ListDataSource: NSObject, UITableViewDataSource {
    
    var array: [RLMResults] = []
    var token: RLMNotificationToken?
    
    func setUpdateBlock(block: RLMNotificationBlock) -> () {
        token = RLMRealm.defaultRealm().addNotificationBlock(block)
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> RLMObject? {
        if (array[indexPath.section].intCount > indexPath.row) {
            return (array[indexPath.section][UInt(indexPath.row)] as! RLMObject)
        } else {
            return nil
        }
    }
    
    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array[section].intCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
