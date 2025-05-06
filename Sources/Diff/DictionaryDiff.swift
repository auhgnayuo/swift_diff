import Foundation

// Extension to Dictionary providing diffing and patching utilities.
public extension Dictionary {
    /// Computes the diff required to transform the current dictionary into another dictionary.
    /// - Parameters:
    ///   - other: The target dictionary to compare against.
    ///   - equals: A function to determine equality between values. Defaults to `defaultEquals`.
    /// - Returns: An array of `Diff` objects representing the changes.
    func diffTo(_ other: [Key: Value], equals: (_ a: Value, _ b: Value) -> Bool = defaultEquals) -> [Diff] {
        var diffs: [Diff] = []
        // Collect all unique keys from both dictionaries
        let allKeys = Set(self.keys).union(other.keys)
        for key in allKeys {
            let hasSelf = self[key] != nil
            let hasOther = other[key] != nil
            switch (hasSelf, hasOther) {
            case (true, false):
                // Key exists in self but not in other: deletion
                diffs.append(Deletion(key))
            case (false, true):
                // Key exists in other but not in self: addition
                diffs.append(Addition(key, other[key]!))
            case (true, true):
                // Key exists in both: check for update
                if !equals(self[key]!, other[key]!) {
                    diffs.append(Update(key, other[key]!))
                }
            default:
                break
            }
        }
        return diffs
    }
    
    /// Computes the diff required to transform another dictionary into the current dictionary.
    /// - Parameters:
    ///   - other: The source dictionary to compare from.
    ///   - equals: A function to determine equality between values. Defaults to `defaultEquals`.
    /// - Returns: An array of `Diff` objects representing the changes.
    func diffFrom(_ other: [Key: Value], equals: (_ a: Value, _ b: Value) -> Bool = defaultEquals) -> [Diff] {
        return other.diffTo(self, equals: equals)
    }
    
    /// Applies a sequence of diffs to the current dictionary, returning a new dictionary with the changes applied.
    /// - Parameter diffs: An array of `Diff` objects to apply.
    /// - Returns: A new dictionary with the diffs applied.
    func applyDiffs(_ diffs: [Diff]) -> [Key: Value] {
        var result = self
        for diff in diffs {
            if let add = diff as? Addition, let key = add.key as? Key, let value = add.value as? Value {
                // Apply addition
                result[key] = value
            } else if let del = diff as? Deletion, let key = del.key as? Key {
                // Apply deletion
                result.removeValue(forKey: key)
            } else if let upd = diff as? Update, let key = upd.key as? Key, let value = upd.newValue as? Value {
                // Apply update
                result[key] = value
            }
        }
        return result
    }
} 
