//
//  Passenger.swift
//  SouthwestTravelManager
//
//  Created by Colin Regan on 12/4/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import Foundation

struct Passenger {
    
    var firstName = ""
    var lastName = ""
    var accountNumber = ""
    
    var fullName: String {
        return firstName + lastName
    }
    
    private static let passengerNameKey = "Passenger Name"
    private static let firstNameKey = "First"
    private static let lastNameKey = "Last"
    private static let accountNumberKey = "Account Number"
    private static let accountHashKey = "Account #"
    
    // Uses weird NSUserDefaults schema for backwards compatibility with version 1.2.1
    static var defaultPassenger: Passenger {
        get {
            let name = NSUserDefaults.standardUserDefaults().objectForKey(passengerNameKey) as [String: String]?
            let account = NSUserDefaults.standardUserDefaults().objectForKey(accountNumberKey) as [String: String]?
            let firstName = name?[firstNameKey] ?? ""
            let lastName = name?[lastNameKey] ?? ""
            let accountNumber = account?[accountHashKey] ?? ""
            return Passenger(firstName: firstName, lastName: lastName, accountNumber: accountNumber)
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject([firstNameKey: newValue.firstName, lastNameKey: newValue.lastName], forKey: passengerNameKey)
            NSUserDefaults.standardUserDefaults().setObject([accountHashKey: newValue.accountNumber], forKey: accountNumberKey)
        }
    }
    
}
