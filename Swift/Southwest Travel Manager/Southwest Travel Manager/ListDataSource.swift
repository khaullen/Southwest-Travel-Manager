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
    
    var array: RLMArray?
    var token: RLMNotificationToken?
    
    func setUpdateBlock(block: RLMNotificationBlock) -> () {
        token = RLMRealm.defaultRealm().addNotificationBlock(block)
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> RLMObject {
        // TODO: validate indexPath, return nil if not valid
        return array?.objectAtIndex(UInt(indexPath.row)) as RLMObject
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(array?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
