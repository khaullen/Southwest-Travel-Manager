//
//  FlightDelegate.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/15/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class FlightDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let allAirports = Airport.allObjects()
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Int(allAirports.count)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return (allAirports.objectAtIndex(UInt(row)) as Airport).airportCode
    }
}
