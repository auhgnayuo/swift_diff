import XCTest
@testable import Diff

final class DiffTests: XCTestCase {
  
    func testArray() {
        for _ in 0..<1000 {
            let left = generateRandomArray(base: 4)
            let right = generateRandomArray(base: 4)
            let diffs = left.diffTo(right)
            let patched = left.applyDiffs(diffs)
            XCTAssertTrue(defaultEquals(patched, right))
            print("array l:\(left) r:\(right) d:\(diffs)")
        }
    }
    
    func testDictionary() {
        for _ in 0..<1000 {
            let left = generateRandomArray(base: 4).enumerated().reduce(into: [Int: Int]()) { $0[$1.offset] = $1.element }
            let right = generateRandomArray(base: 4).enumerated().reduce(into: [Int: Int]()) { $0[$1.offset] = $1.element }
            let diffs = left.diffTo(right)
            let patched = left.applyDiffs(diffs)
            XCTAssertTrue(defaultEquals(patched, right))
            print("map l:\(left) r:\(right) d:\(diffs)")
        }
    }
}

func generateRandomArray(base: Int = 100) -> [Int] {
    let length = Int.random(in: 0..<base)
    return (0..<length).map { _ in Int.random(in: 0..<base) }
} 
