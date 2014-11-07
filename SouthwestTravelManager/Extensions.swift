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
    
    func swiftArray<T>() -> [T] {
        var array = [T]()
        for object in self {
            array.append(object as T)
        }
        return array
    }

}

extension RLMObject: Equatable {}

public func ==(lhs: RLMObject, rhs: RLMObject) -> Bool {
    return lhs.isEqualToObject(rhs)
}


extension Double {
    
    var currencyValue: String? {
        return currencyFormatter.stringFromNumber(self)
    }
    
}

private let currencyFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    return formatter
}()


extension Bool: Comparable {}

public func <(lhs: Bool, rhs: Bool) -> Bool {
    return !lhs && rhs
}

extension NSDate: Comparable {}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqualToDate(rhs)
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

// Note: tried extending Array to add this functionality, but can't enforce that generic Elements be Hashable
// TODO: turn this into a generic convenience initializer on Dictionary
func makeDictionary <Element> (collection: Array<Element>) -> [Element: Double] {
    var result: [Element: Double] = [:]
    for item in collection {
        result[item] = 0
    }
    return result
}

