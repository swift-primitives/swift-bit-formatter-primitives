// Bit.Pattern.Mask+Bit.Formatter.swift
// Consumer entry points for base-2 formatting of bit patterns.

public import Bit_Pattern_Primitives
public import Formatter_Primitives

// MARK: - Bit.Pattern.Mask.formatted

extension Bit.Pattern.Mask {
    /// Renders this bit pattern as a base-2 string using the given formatter.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let mask = Bit.Pattern<UInt8>.Mask(0b1011_0010)
    /// mask.formatted(.base2)                  // "10110010"
    /// mask.formatted(.base2.grouped(by: 4))   // "1011 0010"
    /// ```
    ///
    /// - Parameter format: The base-2 formatter to apply.
    /// - Returns: The base-2 representation.
    @inlinable
    public func formatted(_ format: Bit.Formatter<Carrier>) -> String {
        format.format(self)
    }

    /// Renders this bit pattern using any formatter whose input is this mask type.
    ///
    /// Generic counterpart that lets user-defined
    /// `Formatter.Protocol<Bit.Pattern<Carrier>.Mask, _, Never>` conformers
    /// participate in the same call-site API.
    ///
    /// - Parameter format: A formatter whose input is `Bit.Pattern<Carrier>.Mask`.
    /// - Returns: The formatter's output.
    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter_Primitives.Formatter.`Protocol`, F.Input == Bit.Pattern<Carrier>.Mask, F.Failure == Never {
        format.format(self)
    }
}
