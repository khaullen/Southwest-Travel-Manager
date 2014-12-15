//
//  TravelFundVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/21/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit
import Realm

class TravelFundVC: InputVC {

    @IBOutlet weak var unusedTicketSwitch: UISwitch!

    var travelFund: TravelFund = TravelFund() {
        didSet {
            navigationItem.leftBarButtonItem = nil
            navigationItem.title = travelFund.originalFlight?.confirmationCode
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!travelFund.isNew) {
            if let flight = travelFund.originalFlight {
                flightDelegate.selectAirports(flight.airports, inPicker: flightPicker)
                confirmationTextField.text = flight.confirmationCode
            }
            costTextField.amount = travelFund.balance
            expirationPicker.setDate(travelFund.expirationDate, animated: false)
            unusedTicketSwitch.on = travelFund.unusedTicket
            notesTextField.text = travelFund.notes
            
            expirationChanged(expirationPicker)
        }
    }
    
    override func setObject(object: AnyObject) -> () {
        if let newTravelFund = object as? TravelFund {
            travelFund = newTravelFund
        }
    }
    
    // MARK: Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let hideSection = (travelFund.isNew)
        return super.numberOfSectionsInTableView(tableView) - Int(hideSection)
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (3, 0):
            let alertController = UIAlertController(title: nil, message: nil, cell: tableView.cellForRowAtIndexPath(indexPath)!)
            alertController.addAction(UIAlertAction(title: "Delete Fund", style: .Destructive, handler: { (alert: UIAlertAction!) -> Void in
                if let realm = self.travelFund.realm {
                    realm.transactionWithBlock({ () -> Void in
                        realm.deleteObject(self.travelFund)
                    })
                }
                self.delegate?.editor(self, didUpdateObject: self.travelFund)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(alertController, animated: true, completion: nil)
        default:
            return
        }
    }
    
    // MARK: IBActions
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        travelFund.originalFlight?.airports = flightDelegate.selectedAirports
        travelFund.originalFlight?.confirmationCode = confirmationTextField.text
        travelFund.balance = Double(costTextField.amount)
        travelFund.expirationDate = expirationPicker.date
        travelFund.unusedTicket = unusedTicketSwitch.on
        travelFund.notes = notesTextField.text
        
        if (!travelFund.isNew) {
            delegate?.editor(self, didUpdateObject: travelFund)
        } else {
            delegate?.editor(self, didCreateNewObject: travelFund)
        }
        
        realm.addOrUpdateObject(travelFund)
        realm.commitWriteTransaction()
    }
    
}
