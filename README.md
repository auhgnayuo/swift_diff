# Diff (Swift)

A cross-language library for calculating and applying diffs (changes) between collections (arrays, dictionaries). It provides a unified interface to generate minimal change sets (additions, deletions, updates, movements) and efficiently transform collections.

## Features
- Compute minimal diffs between two collections (arrays, dictionaries)
- Apply diffs (patch) to collections
- Supports additions, deletions, updates, and movements
- Simple, extensible, and consistent API

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

## API

- `Diff`: Abstract base type for all diff operations.
- `Update`: Represents an update operation.
- `Addition`: Represents an addition operation.
- `Deletion`: Represents a deletion operation.
- `Movement`: Represents a movement operation.

## Running Tests

```sh
swift test
```

## License
MIT 