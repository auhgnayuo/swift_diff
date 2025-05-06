# Diff

A Swift library for calculating and applying diffs (changes) between arrays and dictionaries. It provides a unified interface to generate minimal change sets (additions, deletions, updates, movements) and apply them to transform collections efficiently.

## Features
- Compute minimal diffs between two arrays or dictionaries
- Apply diffs (patch) to arrays or dictionaries
- Supports additions, deletions, updates, and movements
- Simple API and extensible design

## Installation
Add this to your `Package.swift`:

```swift
.package(url: "https://github.com/auhgnayuo/swift_diff.git", from: "1.0.0")
```

Then add the dependency to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: ["Diff"]
)
```

## Usage

### Diff and Patch Arrays
```swift
import Diff

let left = [1, 2, 3]
let right = [2, 3, 4]

// Calculate the diff
let diffs = left.diffTo(right)
print(diffs) // [Deletion(0), Addition(2, 4)]

// Apply the diff
let patched = left.applyDiffs(diffs)
print(patched) // [2, 3, 4]
```

### Diff and Patch Dictionaries
```swift
import Diff

let left = ["a": 1, "b": 2]
let right = ["a": 1, "b": 3, "c": 4]

// Calculate the diff
let diffs = left.diffTo(right)
print(diffs) // [Update(b, 3), Addition(c, 4)]

// Apply the diff
let patched = left.applyDiffs(diffs)
print(patched) // ["a": 1, "b": 3, "c": 4]
```

## License
MIT 