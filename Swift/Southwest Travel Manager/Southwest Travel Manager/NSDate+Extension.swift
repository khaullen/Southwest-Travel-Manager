//
//  NSDate+Extension.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/22/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import Foundation

extension NSDate {
    
    var mediumDepartureString: String {
        return mediumDepartureDateFormatter.stringFromDate(self)
    }
    
    var fullDepartureString: String {
        return fullDepartureDateFormatter.stringFromDate(self)
    }

}

private let mediumDepartureDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter
    }()

private let fullDepartureDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .FullStyle
    formatter.timeStyle = .ShortStyle
    return formatter
    }()
