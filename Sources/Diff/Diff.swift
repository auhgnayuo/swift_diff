import Foundation

/// Abstract protocol for all diff operations.
/// Requires conversion to and from JSON-compatible dictionaries.
public protocol Diff {
    /// Converts the diff to a JSON-compatible dictionary.
    /// - Returns: A dictionary representing the diff operation.
    func toJson() -> [AnyHashable: Any]
}

extension Diff {
    /// Creates a Diff instance from a JSON dictionary.
    /// - Parameter json: The JSON dictionary containing diff information.
    /// - Returns: A Diff instance if the type is recognized, otherwise nil.
    static func fromJson(_ json: [AnyHashable : Any]) -> Diff? {
        guard let type = json["type"] as? String else { return nil }
        switch type {
        case "update": return Update(json)
        case "addition": return Addition(json)
        case "deletion": return Deletion(json)
        case "movement": return Movement(json)
        default: return nil
        }
    }
}

/// Represents an update operation in a diff.
/// - Parameters:
///   - key: The key of the value being updated.
///   - newValue: The new value to update to.
public struct Update: Diff, CustomStringConvertible {
    /// The key of the value being updated.
    public let key: Any
    /// The new value to update to.
    public let newValue: Any
    /// Initializes an Update with a key and new value.
    /// - Parameters:
    ///   - key: The key to update.
    ///   - newValue: The new value to set.
    public init(_ key: Any, _ newValue: Any) {
        self.key = key
        self.newValue = newValue
    }
    /// Initializes an Update from a JSON dictionary.
    /// - Parameter json: The JSON dictionary containing update information.
    public init?(_ json: [AnyHashable: Any]) {
        guard let key = json["key"], let newValue = json["newValue"] else { return nil }
        self.key = key
        self.newValue = newValue
    }
    /// Converts the update to a JSON-compatible dictionary.
    /// - Returns: A dictionary representing the update operation.
    public func toJson() -> [AnyHashable: Any] {
        ["type": "update", "key": key, "newValue": newValue]
    }
    /// A string representation of the update.
    public var description: String { "Update(\(key), \(newValue))" }
}

/// Represents an addition operation in a diff.
/// - Parameters:
///   - key: The key where the value is added.
///   - value: The value being added.
public struct Addition: Diff, CustomStringConvertible {
    /// The key where the value is added.
    public let key: Any
    /// The value being added.
    public let value: Any
    /// Initializes an Addition with a key and value.
    /// - Parameters:
    ///   - key: The key where the value is added.
    ///   - value: The value being added.
    public init(_ key: Any, _ value: Any) {
        self.key = key
        self.value = value
    }
    /// Initializes an Addition from a JSON dictionary.
    /// - Parameter json: The JSON dictionary containing addition information.
    public init?(_ json: [AnyHashable: Any]) {
        guard let key = json["key"], let value = json["value"] else { return nil }
        self.key = key
        self.value = value
    }
    /// Converts the addition to a JSON-compatible dictionary.
    /// - Returns: A dictionary representing the addition operation.
    public func toJson() -> [AnyHashable: Any] {
        ["type": "addition", "key": key, "value": value]
    }
    /// A string representation of the addition.
    public var description: String { "Addition(\(key), \(value))" }
}

/// Represents a deletion operation in a diff.
/// - Parameter key: The key of the value being deleted.
public struct Deletion: Diff, CustomStringConvertible {
    /// The key of the value being deleted.
    public let key: Any
    /// Initializes a Deletion with a key.
    /// - Parameter key: The key of the value being deleted.
    public init(_ key: Any) {
        self.key = key
    }
    /// Initializes a Deletion from a JSON dictionary.
    /// - Parameter json: The JSON dictionary containing deletion information.
    public init?(_ json: [AnyHashable: Any]) {
        guard let key = json["key"] else { return nil }
        self.key = key
    }
    /// Converts the deletion to a JSON-compatible dictionary.
    /// - Returns: A dictionary representing the deletion operation.
    public func toJson() -> [AnyHashable: Any] {
        ["type": "deletion", "key": key]
    }
    /// A string representation of the deletion.
    public var description: String { "Deletion(\(key))" }
}

/// Represents a movement operation in a diff (e.g., moving an element from one key/index to another).
/// - Parameters:
///   - oldKey: The original key or index of the element.
///   - newKey: The new key or index of the element.
public struct Movement: Diff, CustomStringConvertible {
    /// The original key or index of the element.
    public let oldKey: Any
    /// The new key or index of the element.
    public let newKey: Any
    /// Initializes a Movement with old and new keys.
    /// - Parameters:
    ///   - oldKey: The original key or index.
    ///   - newKey: The new key or index.
    public init(_ oldKey: Any, _ newKey: Any) {
        self.oldKey = oldKey
        self.newKey = newKey
    }
    /// Initializes a Movement from a JSON dictionary.
    /// - Parameter json: The JSON dictionary containing movement information.
    public init?(_ json: [AnyHashable: Any]) {
        guard let oldKey = json["oldKey"], let newKey = json["newKey"] else { return nil }
        self.oldKey = oldKey
        self.newKey = newKey
    }
    /// Converts the movement to a JSON-compatible dictionary.
    /// - Returns: A dictionary representing the movement operation.
    public func toJson() -> [AnyHashable: Any] {
        ["type": "movement", "oldKey": oldKey, "newKey": newKey]
    }
    /// A string representation of the movement.
    public var description: String { "Movement(\(oldKey), \(newKey))" }
}
