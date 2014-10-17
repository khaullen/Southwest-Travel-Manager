//
//  FirstViewController.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/2/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

protocol CreationProtocol {
    
    func creator(creator: UIViewController, didCreateNewFlight flight: Flight) -> ()
    
}

class FirstViewController: UITableViewController, CreationProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        let destination = (segue.destinationViewController as UINavigationController).topViewController as NewFlightVC
        destination.delegate = self
    }
    
    func creator(creator: UIViewController, didCreateNewFlight flight: Flight) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

