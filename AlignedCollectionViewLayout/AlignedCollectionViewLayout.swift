//
//  AlignedCollectionViewLayout.swift
//  AlignedCollectionViewLayout
//
//  Created by Sofya Avtsinova on 08.11.2024.
//

import Foundation
import UIKit

class AlignedCollectionViewLayout: UICollectionViewLayout {
    private let itemsCache: [[Size]]
    private let alignment: Alignment

    private var attributesCache: [UICollectionViewLayoutAttributes] = []

    public init(alignment: Alignment = .left, items: [[Size]]) {
        self.alignment = alignment
        self.itemsCache = items
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        alignment = .left
        itemsCache = []
        super.init(coder: aDecoder)
    }
    
    override public func prepare() {
        super.prepare()
        attributesCache.removeAll()
        setupCellLayout()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesCache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesCache[indexPath.item]
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: totalHeight)
    }
}

private extension AlignedCollectionViewLayout {
    var contentWidth: CGFloat {
        (collectionView?.frame.size.width ?? 0) - Constants.maxSpacing
    }
    
    var totalHeight: CGFloat {
        attributesCache.reduce(0.0, { $0 + $1.frame.height })
    }
    
    func setupCellLayout() {
        guard let collectionView else {
            return
        }

        var yOffset: CGFloat = 0
        var sequentialIndex = 0
        
        for (_, row) in itemsCache.enumerated() {
            let rowWidth = calculateRowWidth(for: row)
            var xOffset = calculateXOffset(for: rowWidth, in: collectionView)

            for (itemIndex, itemSize) in row.enumerated() {
                let indexPath = IndexPath(item: sequentialIndex + itemIndex, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let itemWidth = CGFloat(itemSize.rawValue) * contentWidth
                attributes.frame = CGRect(x: xOffset, 
                                          y: yOffset,
                                          width: itemWidth,
                                          height: Constants.itemHeight)

                attributesCache.append(attributes)
                xOffset += itemWidth + Constants.itemSpacing
            }
            
            yOffset += Constants.itemHeight + Constants.itemSpacing
            sequentialIndex += row.count
        }
    }
    
    func calculateRowWidth(for row: [Size]) -> CGFloat {
        row.reduce(0) { $0 + CGFloat($1.rawValue) * contentWidth } + CGFloat(row.count - 1) * Constants.itemSpacing
    }

    func calculateXOffset(for rowWidth: CGFloat, in collectionView: UICollectionView) -> CGFloat {
        switch alignment {
        case .left:
            return 0
        case .center:
            return (collectionView.frame.width - rowWidth) / 2
        case .right:
            return collectionView.frame.width - rowWidth
        }
    }
}
