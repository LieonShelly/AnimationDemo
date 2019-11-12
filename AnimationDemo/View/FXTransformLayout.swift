//
//  TransformLayout.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/7.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

open class FXPagerViewLayoutAttributes: UICollectionViewLayoutAttributes {

    open var position: CGFloat = 0
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? FXPagerViewLayoutAttributes else {
            return false
        }
        var isEqual = super.isEqual(object)
        isEqual = isEqual && (self.position == object.position)
        return isEqual
    }
    
    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! FXPagerViewLayoutAttributes
        copy.position = self.position
        return copy
    }
    
}


class FXBannerLayout: UICollectionViewLayout {
    public enum ScrollDirection: Int {
        case horizontal
        case vertical
    }
    open var scrollDirection: ScrollDirection = .horizontal
    open var minimumScale: CGFloat = 0.9
    open var minimumAlpha: CGFloat = 0.6
    internal var leadingSpacing: CGFloat = 0
    internal var itemSpacing: CGFloat = 0 {
        didSet {
            debugPrint("itemSpacing:\(itemSpacing)")
        }
    }
    fileprivate var collectionViewSize: CGSize = .zero
    fileprivate var numberOfSections = 1
    fileprivate var numberOfItems = 0
    fileprivate var actualInteritemSpacing: CGFloat = 0
    /// item的真实大小
    internal var contentSize: CGSize = .zero
    fileprivate var actualItemSize: CGSize = .zero
    fileprivate weak var pagerView: FXBannerView? {
        return self.collectionView?.superview?.superview as? FXBannerView
    }

    override func prepare() {
        guard let collectionView = self.collectionView, let pagerView = self.pagerView else {
               return
        }
        self.actualItemSize = pagerView.itemSize
        self.actualInteritemSpacing =  pagerView.interitemSpacing
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
         //FIXME:滑动范围要调大点，具体好大还没要算出来
        return CGSize(width: self.contentSize.width + actualItemSize.width * 0.5 + abs(self.actualInteritemSpacing),
                      height: self.contentSize.height)
//        return self.contentSize
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
        let maxPosition = min(rect.maxX, self.contentSize.width - self.actualItemSize.width - self.leadingSpacing)
       while origin - maxPosition <= max(CGFloat(100.0) * .ulpOfOne * abs(origin + maxPosition), .leastNonzeroMagnitude) {
            let indexPath = IndexPath(item: itemIndex % self.numberOfItems, section: itemIndex / self.numberOfItems)
            let attributes = self.layoutAttributesForItem(at: indexPath) as! FXPagerViewLayoutAttributes
        
            let ruler = collectionView!.bounds.origin.x + actualItemSize.width * 0.5 + abs(self.actualInteritemSpacing)
        
            attributes.position = (attributes.center.x - ruler)/self.itemSpacing
            attributes.zIndex = Int(self.numberOfItems) - Int(attributes.position)
            let position = attributes.position
            let scale = max(1 - (1 - self.minimumScale) * abs(position), self.minimumScale)
            print("scale:\(scale) - position:\(position)")
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            attributes.transform = transform
            let zIndex = (1-abs(position)) * 10
            attributes.zIndex = Int(zIndex)
        
//            let alpha = (self.minimumAlpha + (1-abs(position))*(1-self.minimumAlpha))
//            attributes.alpha = alpha

            layoutAttributes.append(attributes)
            itemIndex += 1
            origin += self.itemSpacing

       }
       return layoutAttributes
       
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = FXPagerViewLayoutAttributes(forCellWith: indexPath)
        attributes.indexPath = indexPath
        let frame = self.frame(for: indexPath)
        let center = CGPoint(x: frame.midX, y: frame.midY)
        attributes.center = center
        attributes.size = self.actualItemSize
        return attributes
    }
    
    internal func frame(for indexPath: IndexPath) -> CGRect {
       let numberOfItems = self.numberOfItems * indexPath.section + indexPath.item
       let originX: CGFloat = {
           if self.scrollDirection == .vertical {
               return (self.collectionView!.frame.width-self.actualItemSize.width)*0.5
           }
          return leadingSpacing + CGFloat(numberOfItems) * (self.itemSpacing)
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
        guard let collectionView = self.collectionView, let bannerView = self.pagerView  else {
           return
        }
        let currentIndex = bannerView.currentIndex
        let newIndexPath = IndexPath(item: currentIndex, section: 0)
        let contentOffset = self.contentOffset(for: newIndexPath)
        let newBounds = CGRect(origin: contentOffset, size: collectionView.frame.size)
        print("newBounds:\(newBounds)")
        collectionView.bounds = newBounds
    }
    
    internal func contentOffset(for indexPath: IndexPath) -> CGPoint {
         let origin = self.frame(for: indexPath).origin
         guard let _ = self.collectionView else {
             return origin
         }
         let contentOffsetX: CGFloat = {
             if self.scrollDirection == .vertical {
                 return 0
             }
             let contentOffsetX = origin.x - actualItemSize.width * 0.1
             return contentOffsetX
         }()
         let contentOffsetY: CGFloat = {
             if self.scrollDirection == .horizontal {
                 return 0
             }
             let contentOffsetY = origin.y
             return contentOffsetY
         }()
         let contentOffset = CGPoint(x: contentOffsetX, y: contentOffsetY)
         return contentOffset
     }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }
        let oldproposedContentOffset = proposedContentOffset
       var proposedContentOffset = proposedContentOffset
       func calculateTargetOffset(by proposedOffset: CGFloat, boundedOffset: CGFloat) -> CGFloat {
            let unitDis = itemSpacing
            let index = proposedOffset / unitDis
            return round(index) * unitDis - actualItemSize.width * 0.1 * 0.5
        }
       let proposedContentOffsetX: CGFloat = {
            if self.scrollDirection == .vertical {
               return proposedContentOffset.x
            }
            let boundedOffset = self.contentSize.width - self.itemSpacing
            return calculateTargetOffset(by: proposedContentOffset.x, boundedOffset: boundedOffset)
       }()
       let proposedContentOffsetY: CGFloat = {
           if self.scrollDirection == .horizontal {
               return proposedContentOffset.y
           }
           let boundedOffset = self.contentSize.height - self.itemSpacing
           return calculateTargetOffset(by: proposedContentOffset.y, boundedOffset: boundedOffset)
       }()
       proposedContentOffset = CGPoint(x: proposedContentOffsetX, y: proposedContentOffsetY)
       return proposedContentOffset
    }
}
