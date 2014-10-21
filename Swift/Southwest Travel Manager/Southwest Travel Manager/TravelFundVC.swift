//
//  TravelFundVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/21/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class TravelFundVC: UITableViewController {

    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var balanceTextField: TSCurrencyTextField!
    @IBOutlet weak var expirationTextField: UITextField!
    @IBOutlet weak var flightTextField: UITextField!
    @IBOutlet weak var unusedTicketSwitch: UISwitch!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet var expirationPicker: UIDatePicker!
    @IBOutlet var flightDelegate: FlightDelegate!
    @IBOutlet var flightPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBActions

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
    
    }
    
    @IBAction func expirationChanged(sender: UIDatePicker) {
    
    }
}
