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
            let (origin, destination) = delegate.selectedAirports
            self.flightTextField.text = origin.to(destination, format: .City, roundtrip: false)
        }
        
        // TODO: feature -- default airport automatically set in picker and placeholder
        expirationTextField.inputView = expirationPicker
        expirationPicker.setDate(NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 365), animated: false)
        expirationTextField.placeholder = TravelFund.expirationStringForDate(expirationPicker.date)
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func expirationChanged(sender: AnyObject) {
        expirationTextField.text = TravelFund.expirationStringForDate(expirationPicker.date)
    }

}
