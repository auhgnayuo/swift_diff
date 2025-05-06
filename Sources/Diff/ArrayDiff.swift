import Foundation

// Extension to Array providing diffing and patching utilities.
public extension Array {
    /// Computes the diff required to transform the current array into another array.
    /// - Parameters:
    ///   - other: The target array to compare against.
    ///   - equals: A function to determine equality between elements. Defaults to `defaultEquals`.
    /// - Returns: An array of `Diff` objects representing the changes.
    func diffTo(_ other: [Element], equals: (_ a: Element, _ b: Element) -> Bool = defaultEquals) -> [Diff] {
        var diffs: [Diff] = []
        var tmpLeft = self
        // Iterate through the target array
        for j in 0..<other.count {
            var ii: Int? = nil
            // Search for a matching element in the remaining part of tmpLeft
            for i in j..<tmpLeft.count {
                if equals(other[j], tmpLeft[i]) {
                    ii = i
                    break
                }
            }
            if ii == nil {
                // Element not found: addition
                tmpLeft.insert(other[j], at: j)
                diffs.append(Addition(j, other[j]))
            } else {
                if ii == j { continue }
                // Element found but at a different position: movement
                let val = tmpLeft.remove(at: ii!)
                tmpLeft.insert(val, at: j)
                diffs.append(Movement(ii!, j))
            }
        }
        // Handle deletions for extra elements
        for j in stride(from: tmpLeft.count - 1, through: other.count, by: -1) {
            diffs.append(Deletion(j))
        }
        return diffs
    }
    
    /// Computes the diff required to transform another array into the current array.
    /// - Parameters:
    ///   - other: The source array to compare from.
    ///   - equals: A function to determine equality between elements. Defaults to `defaultEquals`.
    /// - Returns: An array of `Diff` objects representing the changes.
    func diffFrom(_ other: [Element], equals: (_ a: Element, _ b: Element) -> Bool = defaultEquals) -> [Diff] {
        return other.diffTo(self, equals: equals)
    }
    
    /// Applies a sequence of diffs to the current array, returning a new array with the changes applied.
    /// - Parameter diffs: An array of `Diff` objects to apply.
    /// - Returns: A new array with the diffs applied.
    func applyDiffs(_ diffs: [Diff]) -> [Element] {
        var right = self
        for diff in diffs {
            if let add = diff as? Addition, let idx = add.key as? Int, let value = add.value as? Element {
                // Apply addition
                right.insert(value, at: idx)
            } else if let del = diff as? Deletion, let idx = del.key as? Int {
                // Apply deletion
                right.remove(at: idx)
            } else if let mov = diff as? Movement {
                // Apply movement
                let val = right.remove(at: mov.oldKey as! Int)
                right.insert(val, at: mov.newKey as! Int)
            }
        }
        return right
    }
} 
