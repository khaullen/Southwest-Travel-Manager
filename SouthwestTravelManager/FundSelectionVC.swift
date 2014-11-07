//
//  FundSelectionVC.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/23/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class FundSelectionVC: UITableViewController {
    
    @IBOutlet var fundSelectionDataSource: TravelFundSelectionDataSource!
    var delegate: FundSelectionDelegate?

    @IBAction func doneTapped(sender: UIBarButtonItem) {
        // TODO: fix me
        delegate?.fundSelector(self, didSelectTravelFunds: makeDictionary(fundSelectionDataSource.selectedFunds))
    }
    
}
