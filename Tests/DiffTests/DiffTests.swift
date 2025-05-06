import XCTest
@testable import Diff

final class DiffTests: XCTestCase {
    /// Generates a random JSON value (Int, Double, String, Bool, NSNull, Array, Dictionary) with arbitrary nesting.
    /// - Parameter depth: Controls the maximum nesting depth.
    func generateRandomJSON(depth: Int = 2) -> Any {
        if depth <= 0 {
            // Primitive types
            let primitives: [() -> Any] = [
                { Int.random(in: -1000...1000) },
                { Double.random(in: -1000...1000) },
                { Bool.random() },
                { UUID().uuidString },
                { NSNull() }
            ]
            return primitives.randomElement()!()
        }
        let type = Int.random(in: 0...5)
        switch type {
        case 0: // Int
            return Int.random(in: -1000...1000)
        case 1: // Double
            return Double.random(in: -1000...1000)
        case 2: // String
            return UUID().uuidString
        case 3: // Bool
            return Bool.random()
        case 4: // Array
            let count = Int.random(in: 0...4)
            return (0..<count).map { _ in generateRandomJSON(depth: depth - 1) }
        case 5: // Dictionary
            let count = Int.random(in: 0...4)
            var dict = [String: Any]()
            for _ in 0..<count {
                let key = UUID().uuidString
                dict[key] = generateRandomJSON(depth: depth - 1)
            }
            return dict
        default:
            return NSNull()
        }
    }

    /// Tests diff and patch operations for random JSON arrays.
    func testRandomJSONArrayDiff() {
        for _ in 0..<1000 {
            let left = (0..<Int.random(in: 0...4)).map { _ in generateRandomJSON(depth: 2) }
            let right = (0..<Int.random(in: 0...4)).map { _ in generateRandomJSON(depth: 2) }
            let diffs = left.diffTo(right, equals: defaultEquals)
            let patched = left.applyDiffs(diffs)
            print("Array left: \(left)\nArray right: \(right)\nDiffs: \(diffs)\n")
            XCTAssertTrue(defaultEquals(patched, right), "Failed for array diff.\nl: \(left)\nr: \(right)\nd: \(diffs)")
        }
    }

    /// Tests diff and patch operations for random JSON dictionaries.
    func testRandomJSONDictionaryDiff() {
        for _ in 0..<1000 {
            var left = [String: Any]()
            var right = [String: Any]()
            for _ in 0..<Int.random(in: 0...4) {
                left[UUID().uuidString] = generateRandomJSON(depth: 2)
            }
            for _ in 0..<Int.random(in: 0...4) {
                right[UUID().uuidString] = generateRandomJSON(depth: 2)
            }
            let diffs = left.diffTo(right, equals: defaultEquals)
            let patched = left.applyDiffs(diffs)
            print("Dict left: \(left)\nDict right: \(right)\nDiffs: \(diffs)\n")
            XCTAssertTrue(defaultEquals(patched, right), "Failed for dict diff.\nl: \(left)\nr: \(right)\nd: \(diffs)")
        }
    }
}