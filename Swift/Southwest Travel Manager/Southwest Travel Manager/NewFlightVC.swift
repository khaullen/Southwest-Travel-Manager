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
    
    let flightDelegate = FlightDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flightPicker = UIPickerView()
        flightPicker.delegate = flightDelegate
        flightPicker.dataSource = flightDelegate
        flightTextField.inputView = flightPicker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    @IBAction func roundtripToggled(sender: UISwitch) {
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hideReturn = section == 1 ? Int(!roundtripSwitch.on) : 0
        return super.tableView(tableView, numberOfRowsInSection: section) - hideReturn
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
