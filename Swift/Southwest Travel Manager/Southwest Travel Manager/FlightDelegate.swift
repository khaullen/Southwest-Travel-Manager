//
//  FlightDelegate.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/15/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class FlightDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
}
