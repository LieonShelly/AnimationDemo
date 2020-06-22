//
//  TransformLayout.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/23.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class TransformLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        self.scrollDirection = UICollectionView.ScrollDirection.horizontal
        self.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        self.itemSize = CGSize(width: (UIScreen.main.bounds.width  - 2 * 5) / 2, height: collectionView!.bounds.height - 20)
        self.minimumLineSpacing = 5
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        guard let collectionView = collectionView else {
            return nil
        }
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        for attribute in attributes {
            let distance = abs(attribute.center.x - centerX)
            let apartScale = distance / (collectionView.bounds.width )
            let scale = abs(cos(apartScale * CGFloat.pi / 4))
            print(scale)
            attribute.transform = CGAffineTransform(scaleX: 1.0, y: scale)
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
