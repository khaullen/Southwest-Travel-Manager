//
//  Extensions.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/22/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import Foundation
import Realm

extension NSDate {
    
    func departureStringWithStyle(style: NSDateFormatterStyle, inTimeZone timeZone: NSTimeZone?) -> String {
        departureDateFormatter.dateStyle = style
        departureDateFormatter.timeZone = timeZone
        return departureDateFormatter.stringFromDate(self)
    }

}

private let departureDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .ShortStyle
    return formatter
}()

extension RLMArray {
    
    var intCount: Int {
        return Int(count)
    }

}

