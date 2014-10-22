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

    var travelFund: TravelFund = {
        var fund = TravelFund()
        fund.originalFlight = Flight(travelFund: fund)
        return fund
    }() {
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
