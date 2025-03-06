//
//  HFlowGrid.swift
//  swiftui-flow-grids
//
//  Created by zijievv on 05/03/2025.
//  Copyright © 2025 zijievv. All rights reserved.
//

import SwiftUI

@available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
public struct HFlowGrid: Layout {
    private let colAlignment: VerticalAlignment
    private let itemAlignment: HorizontalAlignment
    private let colSpacing: CGFloat
    private let itemSpacing: CGFloat

    public init(
        columnAlignment: VerticalAlignment = .top,
        itemAlignment: HorizontalAlignment = .leading,
        columnSpacing: CGFloat? = nil,
        itemSpacing: CGFloat? = nil
    ) {
        self.colAlignment = columnAlignment
        self.itemAlignment = itemAlignment
        self.colSpacing = columnSpacing ?? 8
        self.itemSpacing = itemSpacing ?? 8
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let flow: Flow = .calculate(
            maxHeight: proposal.replacingUnspecifiedDimensions().height,
            spacing: colSpacing,
            itemSpacing: itemSpacing,
            subviews: subviews)
        return .init(width: flow.width, height: proposal.height ?? flow.height)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let flow: Flow = .calculate(maxHeight: bounds.height, spacing: colSpacing, itemSpacing: itemSpacing, subviews: subviews)
        var x = bounds.minX
        var y: CGFloat
        for col in flow.columns {
            y = colStartY(in: bounds, colHeight: col.height)
            for index in col.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                let itemX = itemStartX(width: size.width, colMinX: x, colWidth: col.width)
                subviews[index].place(at: .init(x: itemX, y: y), proposal: .init(size))
                y += size.height + itemSpacing
            }
            x += col.width + colSpacing
        }
    }

    private func colStartY(in bounds: CGRect, colHeight: CGFloat) -> CGFloat {
        switch colAlignment {
        case .top:
            return bounds.minY
        case .bottom:
            return bounds.maxY - colHeight
        case .center, .firstTextBaseline, .lastTextBaseline:
            return (bounds.maxY + bounds.minY - colHeight) / 2
        default:
            assertionFailure("unknown vertical alignment '\(colAlignment)'")
            return (bounds.maxY + bounds.minY - colHeight) / 2
        }
    }

    private func itemStartX(width: CGFloat, colMinX: CGFloat, colWidth: CGFloat) -> CGFloat {
        switch itemAlignment {
        case .leading, .listRowSeparatorLeading:
            return colMinX
        case .trailing, .listRowSeparatorTrailing:
            return colMinX + colWidth - width
        case .center:
            return colMinX + (colWidth - width) / 2
        default:
            assertionFailure("unknown horizontal alignment '\(itemAlignment)'")
            return colMinX + (colWidth - width) / 2
        }
    }

    private struct Flow {
        let width: CGFloat
        let height: CGFloat
        let columns: [Column]

        static func calculate(maxHeight: CGFloat, spacing: CGFloat, itemSpacing: CGFloat, subviews: Subviews) -> Self {
            var cols: [Column] = []
            var col: [Int] = []
            var colWidth: CGFloat = 0
            var x: CGFloat = 0
            var y: CGFloat = 0
            var height: CGFloat = 0
            for (index, subview) in subviews.enumerated() {
                let size = subview.sizeThatFits(.unspecified)
                if !col.isEmpty && maxHeight < y + itemSpacing + size.height {
                    cols.append(.init(width: colWidth, height: y, indices: col))
                    col = []
                    x += (x == 0 ? colWidth : colWidth + spacing)
                    y = 0
                    colWidth = 0
                }
                col.append(index)
                y += (y == 0 ? size.height : size.height + itemSpacing)
                height = max(y, height)
                colWidth = max(colWidth, size.width)
            }
            if !col.isEmpty {
                cols.append(.init(width: colWidth, height: y, indices: col))
                x += (x == 0 ? colWidth : colWidth + spacing)
            }
            return .init(width: x, height: height, columns: cols)
        }

        struct Column {
            let width: CGFloat
            let height:  CGFloat
            let indices: [Int]
        }
    }
}

#if DEBUG
#Preview {
    HFlowGrid(columnAlignment: .top, itemAlignment: .leading, columnSpacing: 5, itemSpacing: 0) {
        Greetings.texts()
    }
    .frame(height: 100)
    .border(.primary)
    .padding()
}
#endif
