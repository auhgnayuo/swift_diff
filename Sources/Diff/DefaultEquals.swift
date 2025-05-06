import Foundation

// Provides a default equality comparison for various types, including optionals, dictionaries, arrays, strings, numbers, and objects.
public func defaultEquals(_ a: Any, _ b: Any) -> Bool {
    // Unwrap optionals for comparison
    let a = unwrapOptional(a)
    let b = unwrapOptional(b)

    // Handle NSNull cases
    if (a is NSNull) != (b is NSNull) {
        return false
    }
    if a is NSNull && b is NSNull {
        return true
    }
    
    // Compare dictionaries recursively
    if let dictA = a as? [String: Any], let dictB = b as? [String: Any] {
        guard Set(dictA.keys) == Set(dictB.keys) else {
            return false
        }
        for key in dictA.keys {
            guard let valA = dictA[key], let valB = dictB[key] else {
                return false
            }
            if !defaultEquals(valA, valB) {
                return false
            }
        }
        return true
    }
    // Compare arrays recursively
    if let arrA = a as? [Any], let arrB = b as? [Any] {
        guard arrA.count == arrB.count else {
            return false
        }
        for (aElem, bElem) in zip(arrA, arrB) {
            if !defaultEquals(aElem, bElem) {
                return false
            }
        }
        return true
    }
    // Compare strings
    if let strA = a as? String, let strB = b as? String {
        return strA == strB
    }
    // Compare booleans
    if let boolA = a as? Bool, let boolB = b as? Bool {
        return boolA == boolB
    }
    // Compare integers
    if let intA = a as? Int, let intB = b as? Int {
        return intA == intB
    }
    // Compare doubles with tolerance
    if let doubleA = a as? Double, let doubleB = b as? Double {
        return abs(doubleA - doubleB) < 1e-9
    }
    // Compare floats with tolerance
    if let floatA = a as? Float, let floatB = b as? Float {
        return abs(floatA - floatB) < 1e-6
    }
    // Compare NSNumber, handling boolean and numeric types
    if let numA = a as? NSNumber, let numB = b as? NSNumber {
        let isBoolA = CFGetTypeID(numA) == CFBooleanGetTypeID()
        let isBoolB = CFGetTypeID(numB) == CFBooleanGetTypeID()
        if isBoolA && isBoolB {
            return numA.boolValue == numB.boolValue
        } else if isBoolA || isBoolB {
            return false
        } else {
            let typeA = String(cString: numA.objCType)
            let typeB = String(cString: numB.objCType)
            guard typeA == typeB else { return false }
            return numA == numB
        }
    }
    // Compare NSObject using isEqual
    if let objA = a as? NSObject, let objB = b as? NSObject {
        return objA.isEqual(objB)
    }
    // Fallback: not equal
    return false
}

// Unwraps an optional value. If the value is nil, returns NSNull; otherwise, returns the unwrapped value.
private func unwrapOptional(_ any: Any) -> Any {
    let mirror = Mirror(reflecting: any)
    if mirror.displayStyle == .optional {
        if let child = mirror.children.first {
            return child.value
        } else {
            return NSNull()
        }
    }
    return any
}
