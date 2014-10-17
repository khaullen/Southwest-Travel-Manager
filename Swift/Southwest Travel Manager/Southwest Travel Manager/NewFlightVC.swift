//
//  NewFlightVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/13/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class NewFlightVC: UITableViewController {

    @IBOutlet weak var flightTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
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
    
    var delegate: CreationProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flightTextField.inputView = flightPicker
        flightDelegate.updateBlock = {
            [unowned self] delegate in
            let (origin, destination) = delegate.selectedAirports
            self.flightTextField.text = origin.airportCode + " - " + destination.airportCode
        }
        
        expirationTextField.inputView = expirationPicker
        outboundTextField.inputView = outboundPicker
        returnTextField.inputView = returnPicker
    }

    // MARK: - Table view data source

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
        let flight = Flight()
        let (origin, destination) = flightDelegate.selectedAirports
        flight.origin = origin
        flight.destination = destination
        flight.confirmationCode = confirmationTextField.text
        // TODO: flight.cost = 0
        // TODO: create fund for expiration
        flight.roundtrip = roundtripSwitch.on
        flight.outboundDepartureDate = outboundPicker.date
        flight.returnDepartureDate = returnPicker.date
        flight.checkInReminder = checkInReminderSwitch.on
        // TODO: handle funds used
        flight.notes = notesTextField.text
        
        delegate?.creator(self, didCreateNewFlight: flight)
    }
    
    // MARK: IBActions
    
    @IBAction func expirationChanged(sender: UIDatePicker) {
        expirationTextField.text = sender.date.description
    }
    
    @IBAction func roundtripToggled(sender: UISwitch) {
        tableView.reloadData()
    }

    @IBAction func outboundChanged(sender: UIDatePicker) {
        outboundTextField.text = sender.date.description
        returnPicker.minimumDate = sender.date
    }
    
    @IBAction func returnChanged(sender: UIDatePicker) {
        returnTextField.text = sender.date.description
        outboundPicker.maximumDate = sender.date
    }
}
