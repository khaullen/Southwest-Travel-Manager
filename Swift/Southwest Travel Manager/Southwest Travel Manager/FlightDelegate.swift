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
    var selectedAirports: (Airport, Airport)
    var updateBlock: ((delegate: FlightDelegate) -> ())?
    
    override init() {
        selectedAirports = (allAirports.firstObject() as Airport, allAirports.firstObject() as Airport)
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Int(allAirports.count)
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return (allAirports.objectAtIndex(UInt(row)) as Airport).airportCode
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedAirports = (allAirports[UInt(pickerView.selectedRowInComponent(0))] as Airport, allAirports[UInt(pickerView.selectedRowInComponent(1))] as Airport)
        if let block = updateBlock {
            block(delegate: self)
        }
    }
}
