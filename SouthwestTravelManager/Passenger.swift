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
    
    fileprivate static let passengerNameKey = "Passenger Name"
    fileprivate static let firstNameKey = "First"
    fileprivate static let lastNameKey = "Last"
    fileprivate static let accountNumberKey = "Account Number"
    fileprivate static let accountHashKey = "Account #"
    
    // Uses weird NSUserDefaults schema for backwards compatibility with version 1.2.1
    static var defaultPassenger: Passenger {
        get {
            let name = UserDefaults.standard.object(forKey: passengerNameKey) as! [String: String]?
            let account = UserDefaults.standard.object(forKey: accountNumberKey) as! [String: String]?
            let firstName = name?[firstNameKey] ?? ""
            let lastName = name?[lastNameKey] ?? ""
            let accountNumber = account?[accountHashKey] ?? ""
            return Passenger(firstName: firstName, lastName: lastName, accountNumber: accountNumber)
        }
        set {
            UserDefaults.standard.set([firstNameKey: newValue.firstName, lastNameKey: newValue.lastName], forKey: passengerNameKey)
            UserDefaults.standard.set([accountHashKey: newValue.accountNumber], forKey: accountNumberKey)
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                UserDefaults.standard.synchronize()
                return
            })
        }
    }
    
}
