//
//  ConfirmationDelegate.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/16/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class ConfirmationDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let proposedChange = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return countElements(proposedChange) <= 6
    }
    
}
