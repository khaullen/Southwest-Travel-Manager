//
//  FlightVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/13/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class FlightVC: UITableViewController {

    @IBOutlet weak var flightTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var costTextField: TSCurrencyTextField!
    @IBOutlet weak var expirationTextField: UITextField!
    @IBOutlet weak var roundtripSwitch: UISwitch!
    @IBOutlet weak var outboundTextField: UITextField!
    @IBOutlet weak var returnTextField: UITextField!
    @IBOutlet weak var checkInReminderSwitch: UISwitch!
    @IBOutlet weak var fundsUsedLabel: UILabel!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet var flightDelegate: FlightDelegate!
    @IBOutlet var flightPicker: UIPickerView!
    @IBOutlet var expirationPicker: UIDatePicker!
    @IBOutlet var outboundPicker: UIDatePicker!
    @IBOutlet var returnPicker: UIDatePicker!
    
    var delegate: EditDelegate?
    var flight = Flight()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flightTextField.inputView = flightPicker
        flightDelegate.updateBlock = {
            [unowned self] delegate in
            self.flightTextField.text = Flight.flightStringForAirports(delegate.selectedAirports)
        }
        
        expirationTextField.inputView = expirationPicker
        outboundTextField.inputView = outboundPicker
        returnTextField.inputView = returnPicker

        if (flight.realm != nil) {
            flightDelegate.selectedAirports = flight.airports
            // TODO: set flights in flightPicker as well
            confirmationTextField.text = flight.confirmationCode
            costTextField.amount = flight.cost
            expirationPicker.setDate(flight.travelFund.expirationDate, animated: false)
            roundtripSwitch.setOn(flight.roundtrip, animated: false)
            outboundPicker.setDate(flight.outboundDepartureDate, animated: false)
            returnPicker.setDate(flight.returnDepartureDate, animated: false)
            checkInReminderSwitch.setOn(flight.checkInReminder, animated: false)
            // TODO: set funds used label
            notesTextField.text = flight.notes
            
            expirationChanged(expirationPicker)
            roundtripToggled(roundtripSwitch)
            outboundChanged(outboundPicker)
            returnChanged(returnPicker)
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let hideSection = (flight.realm == nil)
        return super.numberOfSectionsInTableView(tableView) - Int(hideSection)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hideRow = section == 1 && !roundtripSwitch.on
        return super.tableView(tableView, numberOfRowsInSection: section) - Int(hideRow)
    }

    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        if (flight.realm != nil) {
            flight.realm.beginWriteTransaction()
        }
        
        flight.airports = flightDelegate.selectedAirports
        flight.confirmationCode = confirmationTextField.text
        flight.cost = costTextField.amount
        flight.travelFund.expirationDate = expirationPicker.date
        flight.roundtrip = roundtripSwitch.on
        flight.outboundDepartureDate = outboundPicker.date
        flight.returnDepartureDate = returnPicker.date
        flight.checkInReminder = checkInReminderSwitch.on
        // TODO: handle funds used
        flight.notes = notesTextField.text
        
        if (flight.realm != nil) {
            flight.realm.commitWriteTransaction()
            delegate?.editor(self, didUpdateFlight: flight)
        } else {
            delegate?.editor(self, didCreateNewFlight: flight)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func expirationChanged(sender: UIDatePicker) {
        expirationTextField.text = TravelFund.expirationStringForDate(sender.date)
    }
    
    @IBAction func roundtripToggled(sender: UISwitch) {
        tableView.reloadData()
        if (!sender.on) {
            outboundPicker.maximumDate = nil
        }
    }

    @IBAction func outboundChanged(sender: UIDatePicker) {
        outboundTextField.text = Flight.departureStringForDate(sender.date)
        returnPicker.minimumDate = sender.date
    }
    
    @IBAction func returnChanged(sender: UIDatePicker) {
        returnTextField.text = Flight.departureStringForDate(sender.date)
        outboundPicker.maximumDate = sender.date
    }
}
