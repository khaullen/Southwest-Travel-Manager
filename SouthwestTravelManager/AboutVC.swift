//
//  AboutVC.swift
//  SouthwestTravelManager
//
//  Created by Colin Regan on 12/3/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import Foundation

class AboutVC: UITableViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
