//
//  ConfirmationDelegate.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/16/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import UIKit

class ConfirmationDelegate: NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let proposedChange = ((textField.text ?? String()) as NSString).replacingCharacters(in: range, with: string)
        return proposedChange.characters.count <= 6
    }
    
}
