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

extension Date {
    
    func departureStringWithStyle(_ style: DateFormatter.Style, inTimeZone timeZone: TimeZone?) -> String {
        departureDateFormatter.dateStyle = style
        departureDateFormatter.timeZone = timeZone
        return departureDateFormatter.string(from: self)
    }

}

private let departureDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

extension RLMResults {
    
    var intCount: Int {
        return Int(count)
    }

}

// FIXME: shouldn't need T, should be able to use Generator type
public func swiftArray<T, S: Sequence>(_ collection: S) -> [T] {
    var array = [T]()
    for object in collection {
        array.append(object as! T)
    }
    return array
}

extension RLMObject {
    
    enum PersistedState {
        case new
        case existing
    }
    
    var persistedState: PersistedState {
        return realm == nil ? .new : .existing
    }
    
    var copyString: String? {
        return nil
    }
    
}

extension RLMObject: Equatable {}

public func ==(lhs: RLMObject, rhs: RLMObject) -> Bool {
    return lhs.isEqual(to: rhs)
}


extension Double {
    
    var currencyValue: String? {
        return currencyFormatter.string(from: NSNumber(self))
    }
    
}

private let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
}()


extension Bool: Comparable {}

public func <(lhs: Bool, rhs: Bool) -> Bool {
    return !lhs && rhs
}

extension Date: Comparable {}

public func ==(lhs: Date, rhs: Date) -> Bool {
    return (lhs == rhs)
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
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
    
    @discardableResult func openUntilSuccessful(_ urls: [URL]) -> Bool {
        if (urls.isEmpty) {
            return false
        }
        
        var array = urls
        // FIXME: figure out why shift doesn't work here
        let url = array.remove(at: 0)
        if openURL(url) {
            return true
        } else {
            return openUntilSuccessful(array)
        }
    }
    
}

extension UIDevice {
    
    var machineName: String {
        let systemInfo = UnsafeMutablePointer<utsname>.allocate(capacity: 1)
        uname(systemInfo);
        var machine = systemInfo.pointee.machine
        systemInfo.deinitialize()
        return ""
        // FIXME:
//        return NSString(CString: machine, encoding: NSString.defaultCStringEncoding())
    }
    
}

extension Bundle {
    
    var versionString: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
}

extension UIAlertController {
    
    /// Convenience initializer for creating an ActionSheet style alert controller that will display properly over a UITableViewCell
    convenience init(title: String?, message: String?, cell: UITableViewCell) {
        self.init(title: title, message: message, preferredStyle: .actionSheet)
        popoverPresentationController?.sourceView = cell
        popoverPresentationController?.sourceRect = cell.bounds
    }
    
}

