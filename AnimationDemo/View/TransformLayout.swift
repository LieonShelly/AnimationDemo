//
//  TransformLayout.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/7.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

open class FSPagerViewLayoutAttributes: UICollectionViewLayoutAttributes {

    open var position: CGFloat = 0
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? FSPagerViewLayoutAttributes else {
            return false
        }
        var isEqual = super.isEqual(object)
        isEqual = isEqual && (self.position == object.position)
        return isEqual
    }
    
    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! FSPagerViewLayoutAttributes
        copy.position = self.position
        return copy
    }
    
}


class BannerLayout: UICollectionViewLayout {
    public enum ScrollDirection: Int {
        case horizontal
        case vertical
    }
    open var scrollDirection: ScrollDirection = .horizontal
    open var minimumScale: CGFloat = 0.9
    open var minimumAlpha: CGFloat = 0.6
    internal var leadingSpacing: CGFloat = 0
    internal var itemSpacing: CGFloat = 0
    fileprivate var collectionViewSize: CGSize = .zero
    fileprivate var numberOfSections = 1
    fileprivate var numberOfItems = 0
    fileprivate var actualInteritemSpacing: CGFloat = 0
    /// item的真实大小
    internal var contentSize: CGSize = .zero
    fileprivate var actualItemSize: CGSize = .zero
    
    override func prepare() {
        guard let collectionView = self.collectionView else {
               return
        }
        let interSpacing: CGFloat = 5
        self.actualItemSize = CGSize(width: (UIScreen.main.bounds.width - interSpacing - interSpacing * 2) / 1.5, height: 300)
        self.actualInteritemSpacing = -10
        self.leadingSpacing = 15
        self.itemSpacing = self.actualItemSize.width + self.actualInteritemSpacing
        self.numberOfSections = collectionView.numberOfSections
        self.numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        self.contentSize = {
              let numberOfItems = self.numberOfItems*self.numberOfSections
              switch self.scrollDirection {
                  case .horizontal:
                      var contentSizeWidth: CGFloat = self.leadingSpacing*2 // Leading & trailing spacing
                      contentSizeWidth += CGFloat(numberOfItems-1) * self.actualInteritemSpacing // Interitem spacing
                      contentSizeWidth += CGFloat(numberOfItems) * self.actualItemSize.width // Item sizes
                      let contentSize = CGSize(width: contentSizeWidth, height: collectionView.frame.height)
                      return contentSize
                  case .vertical:
                      var contentSizeHeight: CGFloat = self.leadingSpacing*2 // Leading & trailing spacing
                      contentSizeHeight += CGFloat(numberOfItems-1)*self.actualInteritemSpacing // Interitem spacing
                      contentSizeHeight += CGFloat(numberOfItems)*self.actualItemSize.height // Item sizes
                      let contentSize = CGSize(width: collectionView.frame.width, height: contentSizeHeight)
                      return contentSize
              }
          }()
//        adjustCollectionViewBounds()
    }
    
    internal func forceInvalidate() {
        self.invalidateLayout()
    }
    
    override open var collectionViewContentSize: CGSize {
        return self.contentSize
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       var layoutAttributes = [UICollectionViewLayoutAttributes]()
       guard self.itemSpacing > 0, !rect.isEmpty else {
           return layoutAttributes
       }
        let rect = rect.intersection(CGRect(origin: .zero, size: self.contentSize))
       guard !rect.isEmpty else {
           return layoutAttributes
       }
       let numberOfItemsBefore = self.scrollDirection == .horizontal ? max(Int((rect.minX-self.leadingSpacing)/self.itemSpacing),0) : max(Int((rect.minY-self.leadingSpacing)/self.itemSpacing),0)
       let startPosition = self.leadingSpacing + CGFloat(numberOfItemsBefore)*self.itemSpacing
       let startIndex = numberOfItemsBefore
       var itemIndex = startIndex
       
       var origin = startPosition
       let maxPosition = min(rect.maxX, self.collectionView!.contentSize.width - self.actualItemSize.width - self.leadingSpacing)
       while origin - maxPosition <= max(CGFloat(100.0) * .ulpOfOne * abs(origin + maxPosition), .leastNonzeroMagnitude) {
            let indexPath = IndexPath(item: itemIndex % self.numberOfItems, section: itemIndex / self.numberOfItems)
            let attributes = self.layoutAttributesForItem(at: indexPath) as! FSPagerViewLayoutAttributes
            let ruler = collectionView!.bounds.origin.x + actualItemSize.width * 0.5 + abs(self.actualInteritemSpacing)
        
            attributes.position = (attributes.center.x - ruler)/self.itemSpacing
            attributes.zIndex = Int(self.numberOfItems) - Int(attributes.position)
            let position = attributes.position
            let scale = max(1 - (1-self.minimumScale) * abs(position), self.minimumScale)
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            attributes.transform = transform
        
//            let alpha = (self.minimumAlpha + (1-abs(position))*(1-self.minimumAlpha))
//            attributes.alpha = alpha
            let zIndex = (1-abs(position)) * 10
            attributes.zIndex = Int(zIndex)

            layoutAttributes.append(attributes)
            itemIndex += 1
            origin += self.itemSpacing

       }
       return layoutAttributes
       
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = FSPagerViewLayoutAttributes(forCellWith: indexPath)
        attributes.indexPath = indexPath
        let frame = self.frame(for: indexPath)
        let center = CGPoint(x: frame.midX, y: frame.midY)
        attributes.center = center
        attributes.size = self.actualItemSize
        return attributes
    }
    
    internal func frame(for indexPath: IndexPath) -> CGRect {
       let numberOfItems = self.numberOfItems*indexPath.section + indexPath.item
       let originX: CGFloat = {
           if self.scrollDirection == .vertical {
               return (self.collectionView!.frame.width-self.actualItemSize.width)*0.5
           }
           return self.leadingSpacing + CGFloat(numberOfItems)*self.itemSpacing
       }()
       let originY: CGFloat = {
           if self.scrollDirection == .horizontal {
               return (self.collectionView!.frame.height-self.actualItemSize.height)*0.5
           }
           return self.leadingSpacing + CGFloat(numberOfItems)*self.itemSpacing
       }()
       let origin = CGPoint(x: originX, y: originY)
       let frame = CGRect(origin: origin, size: self.actualItemSize)
       return frame
    }
    
    fileprivate func adjustCollectionViewBounds() {
           guard let collectionView = self.collectionView else {
               return
           }
           let currentIndex = 0
           let newIndexPath = IndexPath(item: currentIndex, section: 0)
           let contentOffset = self.contentOffset(for: newIndexPath)
           let newBounds = CGRect(origin: contentOffset, size: collectionView.frame.size)
           collectionView.bounds = newBounds
       }
    
    internal func contentOffset(for indexPath: IndexPath) -> CGPoint {
         let origin = self.frame(for: indexPath).origin
         guard let collectionView = self.collectionView else {
             return origin
         }
         let contentOffsetX: CGFloat = {
             if self.scrollDirection == .vertical {
                 return 0
             }
             let contentOffsetX = origin.x - (collectionView.frame.width*0.5 - self.actualItemSize.width*0.5)
             return contentOffsetX
         }()
         let contentOffsetY: CGFloat = {
             if self.scrollDirection == .horizontal {
                 return 0
             }
             let contentOffsetY = origin.y - (collectionView.frame.height*0.5 - self.actualItemSize.height*0.5)
             return contentOffsetY
         }()
         let contentOffset = CGPoint(x: contentOffsetX, y: contentOffsetY)
         return contentOffset
     }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }
       var proposedContentOffset = proposedContentOffset
       
       func calculateTargetOffset(by proposedOffset: CGFloat, boundedOffset: CGFloat) -> CGFloat {
            var targetOffset: CGFloat
            let vector: CGFloat = velocity.x >= 0 ? 1.0 : -1.0
            let offsetRatio = (actualItemSize.width * 0.5 + abs(self.actualInteritemSpacing)) * 0.5 / collectionView.bounds.width
            targetOffset = round(proposedOffset / self.itemSpacing + offsetRatio * vector) * self.itemSpacing // Ceil by 0.15, rather than 0.5
            targetOffset = max(0, targetOffset)
            targetOffset = min(boundedOffset, targetOffset)
            return targetOffset
        }
       let proposedContentOffsetX: CGFloat = {
           if self.scrollDirection == .vertical {
               return proposedContentOffset.x
           }
           let boundedOffset = collectionView.contentSize.width - self.itemSpacing
           return calculateTargetOffset(by: proposedContentOffset.x, boundedOffset: boundedOffset)
       }()
       let proposedContentOffsetY: CGFloat = {
           if self.scrollDirection == .horizontal {
               return proposedContentOffset.y
           }
           let boundedOffset = collectionView.contentSize.height - self.itemSpacing
           return calculateTargetOffset(by: proposedContentOffset.y, boundedOffset: boundedOffset)
       }()
       proposedContentOffset = CGPoint(x: proposedContentOffsetX, y: proposedContentOffsetY)
       return proposedContentOffset
    }
}
