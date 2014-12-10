//
//  Extensions.swift
//  Southwest Travel Manager
//
//  Created by Colin Regan on 10/22/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import Foundation
import UIKit
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

extension RLMResults {
    
    var intCount: Int {
        return Int(count)
    }

}

public func swiftArray<T, S: SequenceType>(collection: S) -> [T] {
    var array = [T]()
    for object in collection {
        array.append(object as T)
    }
    return array
}

extension RLMObject {
    
    var isNew: Bool {
        return realm == nil
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


extension Dictionary {
    
    init(collection: [Key], valueSelector:(Key) -> Value) {
        self.init()
        for item in collection {
            self[item] = valueSelector(item)
        }
    }
    
}


extension UIApplication {
    
    func openUntilSuccessful(urls: [NSURL]) -> Bool {
        if (urls.isEmpty) {
            return false
        }
        
        var array = urls
        // TODO: figure out why shift doesn't work here
        let url = array.removeAtIndex(0)
        if openURL(url) {
            return true
        } else {
            return openUntilSuccessful(array)
        }
    }
    
}

