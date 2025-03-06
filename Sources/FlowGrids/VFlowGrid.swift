//
//  VFlowGrid.swift
//  swiftui-flow-grids
//
//  Created by zijievv on 05/03/2025.
//  Copyright © 2025 zijievv. All rights reserved.
//

import SwiftUI

@available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
public struct VFlowGrid: Layout {
    private let rowAlignment: HorizontalAlignment
    private let itemAlignment: VerticalAlignment
    private let rowSpacing: CGFloat
    private let itemSpacing: CGFloat

    public init(
        rowAlignment: HorizontalAlignment = .leading,
        itemAlignment: VerticalAlignment = .bottom,
        rowSpacing: CGFloat? = nil,
        itemSpacing: CGFloat? = nil
    ) {
        self.rowAlignment = rowAlignment
        self.itemAlignment = itemAlignment
        self.rowSpacing = rowSpacing ?? 8
        self.itemSpacing = itemSpacing ?? 8
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let flow: Flow = .calculate(
            maxWidth: proposal.replacingUnspecifiedDimensions().width,
            spacing: rowSpacing,
            itemSpacing: itemSpacing,
            subviews: subviews)
        return .init(width: proposal.width ?? flow.width, height: flow.height)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let flow: Flow = .calculate(maxWidth: bounds.width, spacing: rowSpacing, itemSpacing: itemSpacing, subviews: subviews)
        var y = bounds.minY
        var x: CGFloat
        for row in flow.rows {
            x = rowStartX(in: bounds, rowWidth: row.width)
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                let itemY = itemStartY(height: size.height, rowMinY: y, rowHeight: row.height)
                subviews[index].place(at: .init(x: x, y: itemY), proposal: .init(size))
                x += size.width + itemSpacing
            }
            y += row.height + rowSpacing
        }
    }

    private func rowStartX(in bounds: CGRect, rowWidth: CGFloat) -> CGFloat {
        switch rowAlignment {
        case .leading, .listRowSeparatorLeading:
            return bounds.minX
        case .trailing, .listRowSeparatorTrailing:
            return bounds.maxX - rowWidth
        case .center:
            return (bounds.maxX + bounds.minX - rowWidth) / 2
        default:
            assertionFailure("unknown horizontal alignment '\(rowAlignment)'")
            return (bounds.maxX + bounds.minX - rowWidth) / 2
        }
    }

    private func itemStartY(height: CGFloat, rowMinY: CGFloat, rowHeight: CGFloat) -> CGFloat {
        switch itemAlignment {
        case .top:
            return rowMinY
        case .bottom:
            return rowMinY + rowHeight - height
        case .center, .firstTextBaseline, .lastTextBaseline:
            return rowMinY + (rowHeight - height) / 2
        default:
            assertionFailure("unknown vertical alignment '\(itemAlignment)'")
            return rowMinY + (rowHeight - height) / 2
        }
    }

    private struct Flow {
        let width: CGFloat
        let height: CGFloat
        let rows: [Row]

        static func calculate(maxWidth: CGFloat, spacing: CGFloat, itemSpacing: CGFloat, subviews: Subviews) -> Self {
            var rows: [Row] = []
            var row: [Int] = []
            var rowHeight: CGFloat = 0
            var x: CGFloat = 0
            var y: CGFloat = 0
            var width: CGFloat = 0
            for (index, subview) in subviews.enumerated() {
                let size = subview.sizeThatFits(.unspecified)
                if !row.isEmpty && maxWidth < x + itemSpacing + size.width {
                    rows.append(.init(width: x, height: rowHeight, indices: row))
                    row = []
                    x = 0
                    y += (y == 0 ? rowHeight : rowHeight + spacing)
                    rowHeight = 0
                }
                row.append(index)
                x += (x == 0 ? size.width : size.width + itemSpacing)
                width = max(x, width)
                rowHeight = max(rowHeight, size.height)
            }
            if !row.isEmpty {
                rows.append(.init(width: x, height: rowHeight, indices: row))
                y += (y == 0 ? rowHeight : rowHeight + spacing)
            }
            return .init(width: width, height: y, rows: rows)
        }

        struct Row {
            let width: CGFloat
            let height: CGFloat
            let indices: [Int]
        }
    }
}

#if DEBUG
#Preview {
    VFlowGrid(rowAlignment: .leading, itemAlignment: .bottom, rowSpacing: 5, itemSpacing: 0) {
        Greetings.texts()
    }
    .frame(width: 200)
    .border(.primary)
    .padding()
}

enum Greetings {
    static func texts() -> some View {
        ForEach(greetings.components(separatedBy: .whitespacesAndNewlines).shuffled(), id: \.self) { greeting in
            Text(greeting)
                .font(fonts.randomElement()!)
                .border(Color.accentColor)
        }
    }

    private static let greetings = "Hi 你好 Bonjour Olá Привіт Привет Hallo 안녕 こんにちは Ciao Hola Γεια"

    private static let fonts: [Font] = [
        .largeTitle,
        .title,
        .title2,
        .title3,
        .headline,
        .subheadline,
        .body,
        .callout,
        .footnote,
        .caption,
        .caption2,
    ]
}
#endif
