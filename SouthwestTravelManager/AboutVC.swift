//
//  AboutVC.swift
//  SouthwestTravelManager
//
//  Created by Colin Regan on 12/3/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import Foundation

class AboutVC: UITableViewController {
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
