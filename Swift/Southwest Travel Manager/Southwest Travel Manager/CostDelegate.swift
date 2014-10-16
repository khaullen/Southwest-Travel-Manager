//
//  CostDelegate.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/16/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class CostDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.text = "$0.00"
        return false
    }
    
}
