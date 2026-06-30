# Bit Formatter Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Base-2 text rendering of bit data for Swift — `Bit.Formatter` presents the bits of a fixed-width carrier as a `'0'`/`'1'` string, honoring bit order and optional grouping. Foundation-free, with zero platform dependencies.

---

## Quick Start

`Bit.Formatter` is a formatter style: a small value that describes how to render bit data as text. It conforms to the same `Formatter.Protocol` as every other style in the ecosystem, so it is reached through `.formatted(_:)`. Rendering bits as `0`/`1` glyphs is direct — there is no radix engine and no `Foundation`.

```swift
import Bit_Formatter_Primitives

let mask = Bit.Pattern<UInt8>.Mask(0b1011_0010)

mask.formatted(.base2)                                 // "10110010"  (MSB-first)
mask.formatted(.base2(order: .lsb))                    // "01001101"
mask.formatted(.base2.grouped(by: 4))                  // "1011 0010"
mask.formatted(.base2.grouped(by: 4, separator: "_"))  // "1011_0010"
```

Output is **fixed-width**: one glyph per carrier bit, leading zeros included, so the width follows the carrier — eight glyphs for `UInt8`, sixteen for `UInt16`. The bit order chooses which end comes first: `.msb` emits the most significant bit first (the human-readable convention), `.lsb` emits the least significant bit first. Grouping inserts a separator every *n* glyphs, counted from the start of the emitted stream.

Because `Bit.Formatter` is a `Formatter.Protocol` conformer, it composes with the generic `.formatted(_:)` entry point — any formatter whose input is a bit-pattern mask works through the same call site.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-bit-formatter-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Bit Formatter Primitives", package: "swift-bit-formatter-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

A single module, `Bit Formatter Primitives`, ships `Bit.Formatter` — base-2 rendering of `Bit.Pattern<Carrier>.Mask` — and its `.formatted(_:)` entry point.

Built on `Bit Pattern Primitives` (for `Bit.Pattern`, `Bit.Order`) and `Formatter Primitives` (for the `Formatter.Protocol` capability). Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
