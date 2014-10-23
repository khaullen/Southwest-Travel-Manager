//
//  TravelFundVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/21/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

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
        
        if (travelFund.realm != nil) {
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
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let hideSection = (travelFund.realm == nil)
        return super.numberOfSectionsInTableView(tableView) - Int(hideSection)
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (3, 0):
            if let realm = travelFund.realm {
                realm.transactionWithBlock({ () -> Void in
                    realm.deleteObject(self.travelFund)
                })
            }
            delegate?.editor(self, didUpdateObject: travelFund)
        default:
            return
        }
    }
    
    // MARK: IBActions
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        if (travelFund.realm != nil) {
            travelFund.realm.beginWriteTransaction()
        }
        
        travelFund.originalFlight?.airports = flightDelegate.selectedAirports
        travelFund.originalFlight?.confirmationCode = confirmationTextField.text
        travelFund.balance = costTextField.amount
        travelFund.expirationDate = expirationPicker.date
        travelFund.unusedTicket = unusedTicketSwitch.on
        travelFund.notes = notesTextField.text
        
        if (travelFund.realm != nil) {
            travelFund.realm.commitWriteTransaction()
            delegate?.editor(self, didUpdateObject: travelFund)
        } else {
            delegate?.editor(self, didCreateNewObject: travelFund)
        }
    }
    
}
