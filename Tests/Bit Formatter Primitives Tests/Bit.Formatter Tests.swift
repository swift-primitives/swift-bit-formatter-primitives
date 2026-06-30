import Testing

@testable import Bit_Formatter_Primitives

// MARK: - Bit.Formatter — Base2 (MSB)

@Suite
struct `Bit.Formatter - Base2 MSB` {

    @Test
    func `Renders eight bits most-significant-first`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b1011_0010)
        #expect(mask.formatted(.base2) == "10110010")
    }

    @Test
    func `Emits leading zeros to full carrier width`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b0000_0101)
        #expect(mask.formatted(.base2) == "00000101")
    }

    @Test
    func `Zero renders all zeros at full width`() {
        let mask = Bit.Pattern<UInt8>.Mask(0)
        #expect(mask.formatted(.base2) == "00000000")
    }

    @Test
    func `All ones render all ones at full width`() {
        let mask = Bit.Pattern<UInt8>.Mask(.max)
        #expect(mask.formatted(.base2) == "11111111")
    }

    @Test
    func `Width tracks the carrier`() {
        let mask = Bit.Pattern<UInt16>.Mask(0b1)
        #expect(mask.formatted(.base2).count == 16)
        #expect(mask.formatted(.base2) == "0000000000000001")
    }
}

// MARK: - Bit.Formatter — Order

@Suite
struct `Bit.Formatter - Order` {

    @Test
    func `LSB order reverses the glyph stream`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b1011_0010)
        #expect(mask.formatted(.base2(order: .lsb)) == "01001101")
    }

    @Test
    func `MSB and LSB are reverses of each other`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b1100_0001)
        let msb = mask.formatted(.base2(order: .msb))
        let lsb = mask.formatted(.base2(order: .lsb))
        #expect(String(msb.reversed()) == lsb)
    }

    @Test
    func `Palindromic pattern is order-invariant`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b1111_1111)
        #expect(mask.formatted(.base2(order: .msb)) == mask.formatted(.base2(order: .lsb)))
    }
}

// MARK: - Bit.Formatter — Grouping

@Suite
struct `Bit.Formatter - Grouping` {

    @Test
    func `Nibble grouping inserts a space every four glyphs`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b1011_0010)
        #expect(mask.formatted(.base2.grouped(by: 4)) == "1011 0010")
    }

    @Test
    func `Custom separator is honored`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b1011_0010)
        #expect(mask.formatted(.base2.grouped(by: 4, separator: "_")) == "1011_0010")
    }

    @Test
    func `Grouping counts from the start of the emitted stream under LSB`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b1011_0010)
        #expect(mask.formatted(.base2(order: .lsb).grouped(by: 4)) == "0100 1101")
    }

    @Test
    func `Group size equal to width yields no separator`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b1011_0010)
        #expect(mask.formatted(.base2.grouped(by: 8)) == "10110010")
    }

    @Test
    func `Group size larger than width yields no separator`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b1011_0010)
        #expect(mask.formatted(.base2.grouped(by: 16)) == "10110010")
    }

    @Test
    func `Single-glyph groups separate every bit`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b1010_0000)
        #expect(mask.formatted(.base2.grouped(by: 1)) == "1 0 1 0 0 0 0 0")
    }
}

// MARK: - Bit.Formatter — Formatter.Protocol conformance

@Suite
struct `Bit.Formatter - Formatter.Protocol conformance` {

    @Test
    func `format() method renders directly`() {
        let style: Bit.Formatter<UInt8> = .base2
        #expect(style.format(Bit.Pattern<UInt8>.Mask(0b0000_1111)) == "00001111")
    }

    @Test
    func `Works via the generic formatted overload`() {
        let mask = Bit.Pattern<UInt8>.Mask(0b0000_0001)
        // Generic path: any Formatter.Protocol<Bit.Pattern<UInt8>.Mask, _, Never>.
        #expect(mask.formatted(Bit.Formatter<UInt8>.base2) == "00000001")
    }
}
