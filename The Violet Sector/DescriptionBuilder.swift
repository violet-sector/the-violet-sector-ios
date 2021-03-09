// Created by João Santos for project The Violet Sector.

import SwiftUI

@_functionBuilder struct DescriptionBuilder {
    static func buildBlock() -> EmptyView {
        return EmptyView()
    }

    static func buildBlock<C0: DescriptionItemProtocol>(_ d0: C0) -> C0 {
        return d0
    }

    static func buildBlock<C0: DescriptionItemProtocol, C1: DescriptionItemProtocol>(_ d0: C0, _ d1: C1) -> TupleView<(C0, C1)> {
        return TupleView((d0, d1))
    }

    static func buildBlock<C0: DescriptionItemProtocol, C1: DescriptionItemProtocol, C2: DescriptionItemProtocol>(_ d0: C0, _ d1: C1, _ d2: C2) -> TupleView<(C0, C1, C2)> {
        return TupleView((d0, d1, d2))
    }

    static func buildBlock<C0: DescriptionItemProtocol, C1: DescriptionItemProtocol, C2: DescriptionItemProtocol, C3: DescriptionItemProtocol>(_ d0: C0, _ d1: C1, _ d2: C2, _ d3: C3) -> TupleView<(C0, C1, C2, C3)> {
        return TupleView((d0, d1, d2, d3))
    }

    static func buildBlock<C0: DescriptionItemProtocol, C1: DescriptionItemProtocol, C2: DescriptionItemProtocol, C3: DescriptionItemProtocol, C4: DescriptionItemProtocol>(_ d0: C0, _ d1: C1, _ d2: C2, _ d3: C3, _ d4: C4) -> TupleView<(C0, C1, C2, C3, C4)> {
        return TupleView((d0, d1, d2, d3, d4))
    }

    static func buildBlock<C0: DescriptionItemProtocol, C1: DescriptionItemProtocol, C2: DescriptionItemProtocol, C3: DescriptionItemProtocol, C4: DescriptionItemProtocol, C5: DescriptionItemProtocol>(_ d0: C0, _ d1: C1, _ d2: C2, _ d3: C3, _ d4: C4, _ d5: C5) -> TupleView<(C0, C1, C2, C3, C4, C5)> {
        return TupleView((d0, d1, d2, d3, d4, d5))
    }

    static func buildBlock<C0: DescriptionItemProtocol, C1: DescriptionItemProtocol, C2: DescriptionItemProtocol, C3: DescriptionItemProtocol, C4: DescriptionItemProtocol, C5: DescriptionItemProtocol, C6: DescriptionItemProtocol>(_ d0: C0, _ d1: C1, _ d2: C2, _ d3: C3, _ d4: C4, _ d5: C5, _ d6: C6) -> TupleView<(C0, C1, C2, C3, C4, C5, C6)> {
        return TupleView((d0, d1, d2, d3, d4, d5, d6))
    }

    static func buildBlock<C0: DescriptionItemProtocol, C1: DescriptionItemProtocol, C2: DescriptionItemProtocol, C3: DescriptionItemProtocol, C4: DescriptionItemProtocol, C5: DescriptionItemProtocol, C6: DescriptionItemProtocol, C7: DescriptionItemProtocol>(_ d0: C0, _ d1: C1, _ d2: C2, _ d3: C3, _ d4: C4, _ d5: C5, _ d6: C6, _ d7: C7) -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        return TupleView((d0, d1, d2, d3, d4, d5, d6, d7))
    }

    static func buildBlock<C0: DescriptionItemProtocol, C1: DescriptionItemProtocol, C2: DescriptionItemProtocol, C3: DescriptionItemProtocol, C4: DescriptionItemProtocol, C5: DescriptionItemProtocol, C6: DescriptionItemProtocol, C7: DescriptionItemProtocol, C8: DescriptionItemProtocol>(_ d0: C0, _ d1: C1, _ d2: C2, _ d3: C3, _ d4: C4, _ d5: C5, _ d6: C6, _ d7: C7, _ d8: C8) -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        return TupleView((d0, d1, d2, d3, d4, d5, d6, d7, d8))
    }

    static func buildBlock<C0: DescriptionItemProtocol, C1: DescriptionItemProtocol, C2: DescriptionItemProtocol, C3: DescriptionItemProtocol, C4: DescriptionItemProtocol, C5: DescriptionItemProtocol, C6: DescriptionItemProtocol, C7: DescriptionItemProtocol, C8: DescriptionItemProtocol, C9: DescriptionItemProtocol>(_ d0: C0, _ d1: C1, _ d2: C2, _ d3: C3, _ d4: C4, _ d5: C5, _ d6: C6, _ d7: C7, _ d8: C8, _ d9: C9) -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        return TupleView((d0, d1, d2, d3, d4, d5, d6, d7, d8, d9))
    }

    static func buildIf<Content: DescriptionItemProtocol>(_ content: Content?) -> Content? {
        return content
    }
}

