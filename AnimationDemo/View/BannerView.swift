//
//  BannerView.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/8.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BannerViewDataSource: NSObjectProtocol {
    
    func numberOfItems(in bannerView: BannerView) -> Int
    
    func bannerView(_ bannerView: BannerView, cellForItemAt index: Int) -> UICollectionViewCell
    
}

protocol BannerViewDelegate: NSObjectProtocol {
    
}

class BannerView: UIView {
    let bag = DisposeBag()
    internal var numberOfSections: Int = 0
    internal var numberOfItems: Int = 0
    open var scrollOffset: CGFloat {
          let contentOffset = max(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y)
          let scrollOffset = Double(contentOffset / self.collectionViewLayout.itemSpacing)
          return fmod(CGFloat(scrollOffset), CGFloat(self.numberOfItems))
      }
    internal weak var collectionViewLayout: BannerLayout!
    internal weak var collectionView: UICollectionView!
    internal weak var contentView: UIView!
    fileprivate var possibleTargetingIndexPath: IndexPath?
    open fileprivate(set) var currentIndex: Int = 0
    weak var dataSource: BannerViewDataSource!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        self.collectionView.frame = self.contentView.bounds
    }
}

extension BannerView {
    open func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
       collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    open func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
       collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    open func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> UICollectionViewCell {
       let indexPath = IndexPath(item: index, section: 0)
       let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
       return cell
    }

    func scrollToItem(at index: Int, animated: Bool) {
       guard index < self.numberOfItems else {
           fatalError("index \(index) is out of range [0...\(self.numberOfItems-1)]")
       }
       let indexPath = { () -> IndexPath in
           if let indexPath = self.possibleTargetingIndexPath, indexPath.item == index {
               defer {
                   self.possibleTargetingIndexPath = nil
               }
               return indexPath
           }
           return self.numberOfSections > 1 ? self.nearbyIndexPath(for: index) : IndexPath(item: index, section: 0)
       }()
       let contentOffset = self.collectionViewLayout.contentOffset(for: indexPath)
       self.collectionView.setContentOffset(contentOffset, animated: animated)
    }

    func showAnimation() {
        collectionView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1, delay:0,
                              usingSpringWithDamping: 0.4,
                              initialSpringVelocity: 0.2,
                              options: [.curveEaseInOut],
                              animations: {
                                self.collectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            
        })
    }
}


extension BannerView {
    fileprivate func commonInit() {
        backgroundColor = .clear
        let contentView = UIView(frame:CGRect.zero)
        contentView.backgroundColor = UIColor.clear
        self.addSubview(contentView)
        self.contentView = contentView

        let collectionViewLayout = BannerLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        self.contentView.addSubview(collectionView)
        self.collectionView = collectionView
        self.collectionViewLayout = collectionViewLayout
       }
    
    fileprivate func nearbyIndexPath(for index: Int) -> IndexPath {
          let currentIndex = self.currentIndex
          let currentSection = 0
          if abs(currentIndex - index) <= self.numberOfItems/2 {
              return IndexPath(item: index, section: currentSection)
          } else if (index-currentIndex >= 0) {
              return IndexPath(item: index, section: currentSection-1)
          } else {
              return IndexPath(item: index, section: currentSection+1)
          }
      }
}


extension BannerView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.numberOfSections = 1
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfItems = dataSource.numberOfItems(in: self)
        return dataSource.numberOfItems(in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource.bannerView(self, cellForItemAt: indexPath.row)
    }
}


extension BannerView: UICollectionViewDelegate {
     public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         self.possibleTargetingIndexPath = indexPath
         defer {
             self.possibleTargetingIndexPath = nil
         }
        let index = indexPath.item % self.numberOfItems
        scrollToItem(at: index, animated: true)
     }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.numberOfItems > 0 {
             let currentIndex = lround(Double(self.scrollOffset)) % self.numberOfItems
             if (currentIndex != self.currentIndex) {
                 self.currentIndex = currentIndex
             }
         }
    }
}


