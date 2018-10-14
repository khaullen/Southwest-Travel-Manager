////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import Realm

extension RLMObject {
    // Swift query convenience functions
    public class func objectsWhere(_ predicateFormat: String, _ args: CVarArg...) -> RLMResults {
        return objectsWhere(predicateFormat, args: getVaList(args))
    }

    public class func objectsInRealm(_ realm: RLMRealm, _ predicateFormat: String, _ args: CVarArg...) -> RLMResults {
        return objects(in: realm, where: predicateFormat, args: getVaList(args))
    }
}

extension RLMArray: Sequence {
    // Support Sequence-style enumeration
    public func generate() -> GeneratorOf<RLMObject> {
        var i: UInt  = 0

        return GeneratorOf<RLMObject> {
            if (i >= self.count) {
                return .None
            } else {
                return self[i++] as? RLMObject
            }
        }
    }

    // Swift query convenience functions
    public func indexOfObjectWhere(_ predicateFormat: String, _ args: CVarArg...) -> UInt {
        return index(ofObjectWhere: predicateFormat, args: getVaList(args))
    }

    public func objectsWhere(_ predicateFormat: String, _ args: CVarArg...) -> RLMResults {
        return objectsWhere(predicateFormat, args: getVaList(args))
    }
}

extension RLMResults: Sequence {
    // Support Sequence-style enumeration
    public func generate() -> GeneratorOf<RLMObject> {
        var i: UInt  = 0

        return GeneratorOf<RLMObject> {
            if (i >= self.count) {
                return .None
            } else {
                return self[i++] as? RLMObject
            }
        }
    }

    // Swift query convenience functions
    public func indexOfObjectWhere(_ predicateFormat: String, _ args: CVarArg...) -> UInt {
        return index(ofObjectWhere: predicateFormat, args: getVaList(args))
    }

    public func objectsWhere(_ predicateFormat: String, _ args: CVarArg...) -> RLMResults {
        return objectsWhere(predicateFormat, args: getVaList(args))
    }
}
