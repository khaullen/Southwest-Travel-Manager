//
//  FlightVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/13/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class FlightVC: InputVC {

    @IBOutlet weak var roundtripSwitch: UISwitch!
    @IBOutlet weak var outboundTextField: UITextField!
    @IBOutlet weak var returnTextField: UITextField!
    @IBOutlet weak var checkInReminderSwitch: UISwitch!
    @IBOutlet weak var fundsUsedLabel: UILabel!
    
    @IBOutlet var outboundPicker: UIDatePicker!
    @IBOutlet var returnPicker: UIDatePicker!
    
    var flight: Flight = Flight() {
        didSet {
            navigationItem.leftBarButtonItem = nil
            navigationItem.title = Flight.flightStringForAirports(flight.airports)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let superBlock = flightDelegate.updateBlock
        flightDelegate.updateBlock = {
            [unowned self] delegate in
            superBlock?(delegate: delegate)
            let (origin, destination) = delegate.selectedAirports
            self.outboundPicker.timeZone = origin.timeZoneObject
            self.returnPicker.timeZone = destination.timeZoneObject
        }

        outboundTextField.inputView = outboundPicker
        returnTextField.inputView = returnPicker

        if (flight.realm != nil) {
            flightDelegate.selectAirports(flight.airports, inPicker: flightPicker)
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
        } else {
            let sinceReferenceDate = Int(NSDate.timeIntervalSinceReferenceDate())
            let fiveMinuteIntervals = sinceReferenceDate / (60 * 5)
            let nextInterval = NSDate(timeIntervalSinceReferenceDate: NSTimeInterval((fiveMinuteIntervals + 1) * (60 * 5)))
            outboundPicker.setDate(nextInterval, animated: false)
            outboundTextField.placeholder = outboundPicker.date.departureStringWithStyle(.MediumStyle, inTimeZone: outboundPicker.timeZone)
            returnPicker.setDate(nextInterval.dateByAddingTimeInterval(60 * 60 * 24), animated: false)
            returnTextField.placeholder = returnPicker.date.departureStringWithStyle(.MediumStyle, inTimeZone: returnPicker.timeZone)
        }
    }
    
    override func setObject(object: AnyObject) -> () {
        if let newFlight = object as? Flight {
            flight = newFlight
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
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (5, 0):
            flight.cancelFlight()
            delegate?.editor(self, didUpdateObject: flight)
            // TODO: feature -- add flight cancel workflow that navigates to new travel fund
        default:
            return
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        
        let fundSelectionVC = segue.destinationViewController as FundSelectionVC
        let fundDataSource = fundSelectionVC.tableView.dataSource as TravelFundSelectionDataSource
    }
    
    // MARK: IBActions
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        if (flight.realm != nil) {
            flight.realm.beginWriteTransaction()
        }
        
        flight.airports = flightDelegate.selectedAirports
        flight.confirmationCode = confirmationTextField.text
        flight.cost = Double(costTextField.amount)
        flight.travelFund.expirationDate = expirationPicker.date
        flight.roundtrip = roundtripSwitch.on
        flight.outboundDepartureDate = outboundPicker.date
        flight.returnDepartureDate = returnPicker.date
        flight.checkInReminder = checkInReminderSwitch.on
        // TODO: handle funds used
        flight.notes = notesTextField.text
        
        if (flight.realm != nil) {
            flight.realm.commitWriteTransaction()
            delegate?.editor(self, didUpdateObject: flight)
        } else {
            delegate?.editor(self, didCreateNewObject: flight)
        }
    }
    
    @IBAction func roundtripToggled(sender: UISwitch) {
        tableView.reloadData()
        if (!sender.on) {
            outboundPicker.maximumDate = nil
        }
    }

    @IBAction func outboundChanged(sender: AnyObject) {
        outboundTextField.text = outboundPicker.date.departureStringWithStyle(.MediumStyle, inTimeZone: outboundPicker.timeZone)
        returnPicker.minimumDate = outboundPicker.date
    }
    
    @IBAction func returnChanged(sender: AnyObject) {
        returnTextField.text = returnPicker.date.departureStringWithStyle(.MediumStyle, inTimeZone: returnPicker.timeZone)
        outboundPicker.maximumDate = returnPicker.date
    }
    
}
