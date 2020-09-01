//
//  WheelLayout.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import VideoToolbox

class WheelCollectionLayoutAttributes: UICollectionViewLayoutAttributes {
    var angle: CGFloat = 0
    var anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let attribute = super.copy(with: zone) as? WheelCollectionLayoutAttributes else {
            return WheelCollectionLayoutAttributes()
        }
        attribute.anchorPoint = anchorPoint
        attribute.angle = angle
        return attribute
    }
}

class WheelLayout: UICollectionViewLayout {
    fileprivate var radius: CGFloat = 500
    fileprivate var itemSize: CGSize = CGSize(width: 133, height: 173)
    fileprivate var anglePerItem: CGFloat = 20
    fileprivate var attributes: [WheelCollectionLayoutAttributes] = []
    
    override init() {
        super.init()
        anglePerItem = atan(itemSize.width / radius)
    }
    
    override func prepare() {
        super.prepare()
        attributes.removeAll()
        guard let collectionView = collectionView else {
            return
        }
        let itemCount = collectionView.numberOfItems(inSection: 0)
        guard itemCount > 0 else {
            return
        }
        // 获取总的旋转角度
        let angleAtExtreme = CGFloat((itemCount - 1)) * anglePerItem
        // 随着UICollectionView的移动，第0个cell初始时的角度
        let angle = -1 * angleAtExtreme * collectionView.contentOffset.x / (collectionView.contentSize.width - collectionView.bounds.width)
        // 当前的屏幕中心的的坐标
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        let anchorPointY = ((itemSize.width / 2) + radius) / itemSize.height
        for item in 0..<itemCount {
            let attribute = WheelCollectionLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            attribute.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            attribute.size = itemSize
            attribute.center = CGPoint(x: centerX, y: collectionView.bounds.midY)
            attribute.angle = angle + anglePerItem * CGFloat(item)
            attribute.transform = CGAffineTransform(rotationAngle: attribute.angle)
            attribute.zIndex = item * 1000 * -1
            attributes.append(attribute)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        let itemCount = collectionView.numberOfItems(inSection: 0)
        return CGSize(width: CGFloat(itemCount) * itemSize.width, height: collectionView.bounds.height)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return WheelCollectionLayoutAttributes.self
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class WheelCell: UICollectionViewCell {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attribute = layoutAttributes as? WheelCollectionLayoutAttributes else {
            return
        }
        layer.anchorPoint = attribute.anchorPoint
        let centerY = (attribute.anchorPoint.y - 0.5) * bounds.height
        center = CGPoint(x: center.x, y: centerY + center.y)
    }
}
