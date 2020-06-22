//
//  CycleLayout.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/21.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation


class CycleLayout: UICollectionViewLayout {
    private var itemCount = 0
    private var itemSize = CGSize(width: 100, height: 100)
    private var itemXSpacing: CGFloat = 20
    private var itemAndSpacingWidth: CGFloat {
        return itemSize.width + itemXSpacing
    }
    private var arcRadius: CGFloat = 500// Radius of the circle that the cells will arc over.
    private var contentWidth: CGFloat {
        let totalItemAndSpacingWidth = CGFloat(itemCount) * itemAndSpacingWidth
        return totalItemAndSpacingWidth
    }
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var adjustedLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    private let insetWidth: CGFloat = 16000
    private var hasSetInitialContentOffsetOnce = false
    private var leadingOffsetX: CGFloat {
        return insetWidth
    }
    private var traillingOffsetX: CGFloat {
        return collectionViewContentSize.width - insetWidth
    }
    
    override class var invalidationContextClass: AnyClass {
        return LoopLayoutInvalidationContext.self
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        itemCount = collectionView.numberOfItems(inSection: 0)
        if layoutAttributes.isEmpty {
            var cureentX: CGFloat = leadingOffsetX
            layoutAttributes = []

            let radius = min(collectionView.frame.width, collectionView.frame.height)
            let center = CGPoint(x: collectionView.bounds.width * 0.5, y: collectionView.bounds.height * 0.5)
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.size = itemSize
                
                let xCenter = cureentX + (itemSize.width / 2)
                let yCenter = collectionView.bounds.maxY / 2
                attributes.center = CGPoint(x: xCenter, y: yCenter)
                layoutAttributes.append(attributes)
                cureentX += itemSize.width + itemXSpacing
                
                let x = center.x + CGFloat(cosf(2 * Float.pi / Float(itemCount) * Float(item))) * (radius - itemSize.width * 0.5)
                let y = center.y + CGFloat(cosf(2 * Float.pi / Float(itemCount) * Float(item))) * (radius - itemSize.width * 0.5)
                attributes.center = CGPoint(x: x, y: y)
                layoutAttributes.append(attributes)
            }
        }
       
        guard itemCount > 0 else {
            return
        }
        setInitalContentOffsetIfRequired()
        
        let normalizedContentOffset = collectionView.contentOffset.x - leadingOffsetX
        
        let nearstContentIndex = Int(normalizedContentOffset / itemAndSpacingWidth)
        let nearstItemIndex = Int(nearstContentIndex) % itemCount
        
        let multiple = (nearstContentIndex - nearstItemIndex) / itemCount
        
        adjustedLayoutAttributes = layoutAttributes.copy().shift(distance: nearstItemIndex)
        let firstAttribute = adjustedLayoutAttributes[0]
        var currentX = firstAttribute.center.x
        currentX += contentWidth * CGFloat(multiple)
        
        for attributes in adjustedLayoutAttributes {
            attributes.center = CGPoint(x: currentX, y: attributes.center.y)
            currentX += itemAndSpacingWidth
//            adjustAttributes(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
           return adjustedLayoutAttributes.filter({ rect.intersects($0.frame)})
       }
    
    override var collectionViewContentSize: CGSize {
        let totalInsetWidth = insetWidth * 2
        let totalContentWidth = totalInsetWidth + contentWidth
        return CGSize(width: totalContentWidth, height: 0)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
         for attributes in adjustedLayoutAttributes where attributes.indexPath == indexPath {
             return attributes
         }
         return nil
     }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let collectionView = collectionView else {
            return context
        }
        if collectionView.contentOffset.x > traillingOffsetX {
            let offset = CGPoint(x: -contentWidth, y: 0)
            context.contentOffsetAdjustment = offset
        } else if collectionView.contentOffset.x <= leadingOffsetX {
            let offset = CGPoint(x: contentWidth, y: 0)
            context.contentOffsetAdjustment = offset
        }
        return context
    }

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        guard let loopContext = context as? LoopLayoutInvalidationContext else {
            assertionFailure("Unexpected invalidation context type: \(context)")
            super.invalidateLayout(with: context)
            return
        }
        // Re-ask the delegate for centered indexpath if we ever reload data
        if loopContext.invalidateEverything || loopContext.invalidateDataSourceCounts || loopContext.accessibilityDidChange {
            layoutAttributes = []
            adjustedLayoutAttributes = []
            hasSetInitialContentOffsetOnce = false
        }

        super.invalidateLayout(with: loopContext)
    }

    private func adjustAttributes(_ attributes: UICollectionViewLayoutAttributes) {
        guard let collectionView = collectionView else {
            return
        }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let activeArcDistance = (visibleRect.width + itemSize.width) / 2
        let distanceFromCenter = abs(visibleRect.midX - attributes.center.x)
        var transform: CATransform3D = CATransform3DIdentity
        if distanceFromCenter < activeArcDistance {
            let yTranslation = arcRadius - sqrt((arcRadius * arcRadius) - (distanceFromCenter * distanceFromCenter))
            transform = CATransform3DMakeTranslation(0, yTranslation, 0)
        }
         attributes.transform3D = transform
    }
    
    private func initialContentOffset() -> CGPoint? {
        guard let collectionView = collectionView, itemCount > 0 else {
            return nil
        }
        let firstIndexPath = IndexPath(item: 0, section: 0)
        let attributes = layoutAttributes[firstIndexPath.item]
        let initialContentOffsetX: CGFloat = contentWidth
        let centeredOffsetX = (attributes.center.x + initialContentOffsetX) - collectionView.frame.width / 2
        let contentOffsetAdjustment = CGPoint(x: centeredOffsetX, y: 0)
        return contentOffsetAdjustment
    }
    
    private func setInitalContentOffsetIfRequired() {
        guard !hasSetInitialContentOffsetOnce, let cv = collectionView, let initialContentOffset = initialContentOffset() else { return }
        
        // We only do this once, unless the user calls reload data and invalidates everything.
        hasSetInitialContentOffsetOnce = true
        
        cv.setContentOffset(initialContentOffset, animated: false)
    }
}

// Example: [1,2,3,4,5].shift(distance: 3) -> [4,5,1,2,3]
extension Array {
    func shift(distance: Int = 1) -> [Element] {
        let offsetIndex = distance >= 0 ?
            self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
            self.index(endIndex, offsetBy: distance, limitedBy: startIndex)

        guard let index = offsetIndex else { return self }
        // Note: Broken apart as the type checked was taking 500ms to compile
        let endRange = index..<endIndex
        let endOfArray = self[endRange]

        let startRange = startIndex..<index
        let startOfArray = self[startRange]
        return Array(endOfArray + startOfArray)
    }

    mutating func shiftInPlace(withDistance distance: Int = 1) {
        self = shift(distance: distance)
    }
}


class LoopLayoutInvalidationContext: UICollectionViewLayoutInvalidationContext {
    var boundsSizeDidChange: Bool = false
    var accessibilityDidChange: Bool = false
}

extension Collection where Element: UICollectionViewLayoutAttributes {
    func copy<T: UICollectionViewLayoutAttributes>() -> [T] {
        return self.map { $0.copyAttributes() }
    }
}

extension UICollectionViewLayoutAttributes {
    func copyAttributes<T: UICollectionViewLayoutAttributes>() -> T {
        guard let copy = self.copy() as? T else {
            fatalError()
        }
        return copy
    }
}
