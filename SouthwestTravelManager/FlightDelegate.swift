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
    var updateBlock: ((delegate: FlightDelegate) -> ())?
    
    var selectedAirports: (Airport, Airport) {
        didSet {
            updateBlock?(delegate: self)
        }
    }
    
    override init() {
        selectedAirports = (allAirports.firstObject() as Airport, allAirports.firstObject() as Airport)
    }
    
    func selectAirports(airports: (Airport, Airport), inPicker picker: UIPickerView) -> () {
        selectedAirports = airports
        let (origin, destination) = airports
        picker.selectRow(Int(allAirports.indexOfObject(origin)), inComponent: 0, animated: false)
        picker.selectRow(Int(allAirports.indexOfObject(destination)), inComponent: 1, animated: false)
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
    }
    
    @IBAction func editingDidBegin(sender: UITextField) {
        updateBlock?(delegate: self)
    }
}
