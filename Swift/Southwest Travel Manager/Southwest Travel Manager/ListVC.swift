//
//  ListVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/2/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

protocol EditProtocol {
    
    func editor(editor: UIViewController, didCreateNewFlight flight: Flight) -> ()
    func editor(editor: UIViewController, didUpdateFlight flight: Flight) -> ()
    
}

class ListVC: UITableViewController, EditProtocol {
    
    var array: RLMArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(array?.count ?? 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as UITableViewCell
        let flight = array?.objectAtIndex(UInt(indexPath.row)) as Flight
        cell.textLabel?.text = flight.origin.airportCode
        cell.detailTextLabel?.text = flight.outboundDepartureDate.description
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        let flightVC = (segue.destinationViewController as? FlightVC) ?? (segue.destinationViewController as? UINavigationController)?.topViewController as? FlightVC
        flightVC?.delegate = self

        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)
            if let row = indexPath?.row {
                let flight = array?.objectAtIndex(UInt(row)) as Flight
                flightVC?.flight = flight
                flightVC?.navigationItem.leftBarButtonItem = nil
                flightVC?.navigationItem.title = flight.origin.airportCode
            }
        }
    }
    
    func editor(editor: UIViewController, didCreateNewFlight flight: Flight) {
        dismissViewControllerAnimated(true, completion: nil)
        
        let realm = RLMRealm.defaultRealm()
        realm.transactionWithBlock { () -> Void in
            realm.addObject(flight)
        }
        
        reloadData()
    }
    
    func editor(editor: UIViewController, didUpdateFlight flight: Flight) {
        navigationController?.popViewControllerAnimated(true)
        reloadData()
    }

    func reloadData() {
        array = Flight.allObjects().arraySortedByProperty("outboundDepartureDate", ascending: true)
        tableView.reloadData()
    }

}

