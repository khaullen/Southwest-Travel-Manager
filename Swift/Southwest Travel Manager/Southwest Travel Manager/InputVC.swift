//
//  InputVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/21/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class InputVC: UITableViewController {

    @IBOutlet weak var flightTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var costTextField: TSCurrencyTextField!
    @IBOutlet weak var expirationTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!

    @IBOutlet var flightDelegate: FlightDelegate!
    @IBOutlet var flightPicker: UIPickerView!
    @IBOutlet var expirationPicker: UIDatePicker!

    var delegate: EditDelegate?
    
    func setObject(object: AnyObject) -> () {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        flightTextField.inputView = flightPicker
        flightDelegate.updateBlock = {
            [unowned self] delegate in
            self.flightTextField.text = Flight.flightStringForAirports(delegate.selectedAirports)
        }
        
        expirationTextField.inputView = expirationPicker
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func expirationChanged(sender: AnyObject) {
        expirationTextField.text = TravelFund.expirationStringForDate(expirationPicker.date)
    }

}
