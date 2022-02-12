//
//  AspectVGrid.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-01.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var aspectRatio: CGFloat
    var minimumColumns: Int = 1
    var content: (Item) -> ItemView
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let width: CGFloat = widthThatFits(itemCount: items.count,
                                                   in: geometry.size,
                                                   itemAspectRatio: aspectRatio,
                                                   minimumColumns: minimumColumns)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
            }
            Spacer(minLength: 0)
        }
    }
}

// Factored this logic out to clean up the body var
private func adaptiveGridItem(width: CGFloat) -> GridItem {
    var gridItem = GridItem(.adaptive(minimum: width))
    gridItem.spacing = 0
    return gridItem
}

// Find the maximum width that allows the Items to all fit in the provided space while maintaining the aspect ratio
private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat, minimumColumns: Int) -> CGFloat {
    var columnCount = minimumColumns
    var rowCount = (itemCount + (columnCount - 1)) / columnCount
    repeat {
        let itemWidth = size.width / CGFloat(columnCount)
        let itemHeight = itemWidth / itemAspectRatio
        if itemHeight * CGFloat(rowCount) < size.height {
            break
        }
        columnCount += 1
        rowCount = (itemCount + (columnCount - 1)) / columnCount
    } while (columnCount < itemCount)
    if columnCount > itemCount {
        columnCount = itemCount
    }
    return floor(size.width / CGFloat(columnCount))
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
