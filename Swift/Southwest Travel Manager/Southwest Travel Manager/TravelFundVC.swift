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
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
