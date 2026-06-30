// Bit.Formatter.swift
// Base-2 text rendering of bit data.

public import Bit_Pattern_Primitives
public import Formatter_Primitives

extension Bit {
    /// Formatter that renders bit data as a base-2 (binary) string.
    ///
    /// `Bit.Formatter` conforms to
    /// `Formatter.Protocol<Bit.Pattern<Carrier>.Mask, String, Never>`, letting it
    /// participate in the generic `.formatted(_:)` API alongside other formatters.
    /// It walks the bits of a fixed-width carrier and emits a `'0'` or `'1'`
    /// glyph per bit — rendering bits as glyphs is direct, so no radix engine is
    /// involved. Output is **fixed-width**: exactly one glyph per carrier bit,
    /// leading zeros included, so an 8-bit carrier always yields eight glyphs.
    ///
    /// The bit ``Bit/Order`` controls significance order: `.msb` emits the most
    /// significant bit first (the human-readable convention), `.lsb` emits the
    /// least significant bit first.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let mask = Bit.Pattern<UInt8>.Mask(0b1011_0010)
    ///
    /// mask.formatted(.base2)                            // "10110010"  (MSB-first)
    /// mask.formatted(.base2(order: .lsb))              // "01001101"
    /// mask.formatted(.base2.grouped(by: 4))            // "1011 0010"
    /// mask.formatted(.base2.grouped(by: 4, separator: "_"))  // "1011_0010"
    /// ```
    ///
    /// - Parameter Carrier: The fixed-width unsigned integer whose bits are rendered.
    public struct Formatter<Carrier>: Sendable, Formatter_Primitives.Formatter.`Protocol`
    where Carrier: FixedWidthInteger & UnsignedInteger & Sendable {
        /// The significance order in which bits are emitted.
        @usableFromInline
        let order: Bit.Order

        /// Glyphs per group, or `nil` for ungrouped output.
        @usableFromInline
        let group: Int?

        /// The string inserted between groups when ``group`` is set.
        @usableFromInline
        let separator: String

        /// Creates a base-2 bit formatter.
        ///
        /// - Parameters:
        ///   - order: The significance order in which bits are emitted. Default `.msb`.
        ///   - group: Glyphs per group, or `nil` for ungrouped output. Must be
        ///     positive when non-`nil`. Default `nil`.
        ///   - separator: The string inserted between groups. Default `" "`.
        @inlinable
        public init(order: Bit.Order = .msb, group: Int? = nil, separator: String = " ") {
            precondition(group.map { $0 > 0 } ?? true, "group size must be positive")
            self.order = order
            self.group = group
            self.separator = separator
        }
    }
}

// MARK: - Formatter.Protocol

extension Bit.Formatter {
    /// The value this formatter accepts: a bit pattern in the carrier ring.
    public typealias Input = Bit.Pattern<Carrier>.Mask

    /// The value this formatter produces: the base-2 string.
    public typealias Output = String

    /// The error this formatter can raise: `Never` — base-2 rendering cannot fail.
    public typealias Failure = Never

    /// Renders a bit pattern as its base-2 string.
    ///
    /// Emits one `'0'`/`'1'` glyph per carrier bit in ``order`` significance order,
    /// inserting ``separator`` between every ``group`` glyphs when grouping is set.
    /// Grouping counts glyphs from the start of the emitted stream.
    ///
    /// - Parameter value: The bit pattern to render.
    /// - Returns: The fixed-width base-2 representation.
    @inlinable
    public func format(_ value: Input) -> String {
        let width = Carrier.bitWidth
        let bits = value.underlying

        var output = ""
        output.reserveCapacity(width + (group.map { width / $0 } ?? 0))

        for step in 0..<width {
            if let group, step != 0, step.isMultiple(of: group) {
                output += separator
            }

            let position: Int
            switch order {
            case .msb: position = width - 1 - step
            case .lsb: position = step
            }

            output.append((bits >> position) & 1 == 1 ? "1" : "0")
        }

        return output
    }
}

// MARK: - Styles

extension Bit.Formatter {
    /// Base-2 rendering, most-significant-bit first, ungrouped.
    ///
    /// The human-readable default: `Bit.Pattern<UInt8>.Mask(0b1011_0010)` renders
    /// as `"10110010"`.
    @inlinable
    public static var base2: Self { Self(order: .msb) }

    /// Base-2 rendering in the given significance order, ungrouped.
    ///
    /// - Parameter order: The significance order in which bits are emitted.
    /// - Returns: A base-2 formatter using `order`.
    @inlinable
    public static func base2(order: Bit.Order) -> Self { Self(order: order) }

    /// Returns a copy of this formatter that inserts a separator between groups.
    ///
    /// Grouping counts glyphs from the start of the emitted stream, so
    /// `.base2.grouped(by: 4)` renders `0b1011_0010` as `"1011 0010"`.
    ///
    /// - Parameters:
    ///   - size: Glyphs per group. Must be positive.
    ///   - separator: The string inserted between groups. Default `" "`.
    /// - Returns: A grouped variant of this formatter.
    @inlinable
    public func grouped(by size: Int, separator: String = " ") -> Self {
        Self(order: order, group: size, separator: separator)
    }
}
