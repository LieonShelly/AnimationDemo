//
//  ArcLayout.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class ArcLayout: UICollectionViewFlowLayout {
    fileprivate var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    fileprivate var itemCount = 0
    fileprivate var arcCenter: CGPoint = .zero
    fileprivate var radius: CGFloat = 0
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        radius = min(collectionView.bounds.height, collectionView.bounds.width) * 0.5
        arcCenter = CGPoint(x: collectionView.bounds.width * 0.5, y: collectionView.bounds.height * 0.5)
        itemCount = collectionView.numberOfItems(inSection: 0)
        layoutAttributes = []
        for item in 0..<itemCount {
            guard let attribute = self.layoutAttributesForItem(at: IndexPath(item: item, section: 0)) else {
                continue
            }
            layoutAttributes.append(attribute)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let angle = 2 * CGFloat.pi * CGFloat(indexPath.row) / CGFloat(itemCount)
        attributes.size = CGSize(width: 80, height: 80)
        attributes.center = CGPoint(x: arcCenter.x + radius * cos(angle),
                                    y: arcCenter.y + radius * sin(angle))
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { rect.intersects($0.frame)}
    }
    
    override var collectionViewContentSize: CGSize {
        return collectionView!.bounds.size
    }
}
