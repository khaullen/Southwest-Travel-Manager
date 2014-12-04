//
//  AboutVC.swift
//  SouthwestTravelManager
//
//  Created by Colin Regan on 12/3/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import Foundation

class AboutVC: UITableViewController {
    
    var user: Passenger {
        get {
            return Passenger(firstName: firstNameTextField.text, lastName: lastNameTextField.text, accountNumber: accountNumberTextField.text)
        }
        set {
            firstNameTextField.text = newValue.firstName
            lastNameTextField.text = newValue.lastName
            accountNumberTextField.text = newValue.accountNumber
        }
    }
    
    @IBOutlet weak var versionCell: UITableViewCell!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionCell.detailTextLabel?.text = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        user = Passenger.defaultPassenger
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        Passenger.defaultPassenger = user
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
