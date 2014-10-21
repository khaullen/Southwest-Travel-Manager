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
    
    func editor(editor: UIViewController, didCreateNewFlight flight: Flight) -> ()
    func editor(editor: UIViewController, didUpdateFlight flight: Flight) -> ()
    
}

@objc protocol DataSourceProtocol: UITableViewDataSource {
    
    func setUpdateBlock(block: RLMNotificationBlock) -> ()

}

class ListVC: UITableViewController, EditDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = tableView.dataSource as? DataSourceProtocol
        dataSource?.setUpdateBlock {
            [unowned self] (_, _) in
            self.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        let flightVC = (segue.destinationViewController as? FlightVC) ?? (segue.destinationViewController as? UINavigationController)?.topViewController as? FlightVC
        flightVC?.delegate = self

        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)
            if let indexPath = indexPath {
                let flight = (tableView.dataSource as FlightListDataSource).flightAtIndexPath(indexPath)
                if let flight = flight {
                    flightVC?.flight = flight
                    flightVC?.navigationItem.leftBarButtonItem = nil
                    flightVC?.navigationItem.title = Flight.flightStringForAirports(flight.airports)
                }
            }
        }
    }
    
    func editor(editor: UIViewController, didCreateNewFlight flight: Flight) {
        dismissViewControllerAnimated(true, completion: nil)
        
        let realm = RLMRealm.defaultRealm()
        realm.transactionWithBlock { () -> Void in
            realm.addObject(flight)
        }
    }
    
    func editor(editor: UIViewController, didUpdateFlight flight: Flight) {
        navigationController?.popViewControllerAnimated(true)
    }

}

