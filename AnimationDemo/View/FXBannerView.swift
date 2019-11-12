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

protocol FXBannerViewDataSource: NSObjectProtocol {
    
    func numberOfItems(in bannerView: FXBannerView) -> Int
    
    func bannerView(_ bannerView: FXBannerView, cellForItemAt index: Int) -> UICollectionViewCell
    
}

@objc
protocol FXBannerViewDelegate: NSObjectProtocol {
    
    /// Asks the delegate if the item should be hi
    @objc
    optional func bannerView(_ pagerView: FXBannerView, shouldHighlightItemAt index: Int) -> Bool
    
    /// Tells the delegate that the item at the specified index was highlighted.
    @objc
    optional func bannerView(_ pagerView: FXBannerView, didHighlightItemAt index: Int)
    
    /// Asks the delegate if the specified item should be selected.
    @objc
    optional func bannerView(_ pagerView: FXBannerView, shouldSelectItemAt index: Int) -> Bool
    
    /// Tells the delegate that the item at the specified index was selected.
    @objc
    optional func bannerView(_ pagerView: FXBannerView, didSelectItemAt index: Int)
    
    /// Tells the delegate that the specified cell is about to be displayed in the pager view.
    @objc
    optional func bannerView(_ pagerView: FXBannerView, willDisplay cell: UICollectionViewCell, forItemAt index: Int)
    
    /// Tells the delegate that the specified cell was removed from the pager view.
    @objc
    optional func bannerView(_ pagerView: FXBannerView, didEndDisplaying cell: UICollectionViewCell, forItemAt index: Int)
    
    /// Tells the delegate when the pager view is about to start scrolling the content.
    @objc
    optional func bannerViewWillBeginDragging(_ pagerView: FXBannerView)
    
    /// Tells the delegate when the user finishes scrolling the content.
    @objc
    optional func bannerViewWillEndDragging(_ pagerView: FXBannerView, targetIndex: Int)
    
    /// Tells the delegate when the user scrolls the content view within the receiver.
    @objc
    optional func bannerViewDidScroll(_ pagerView: FXBannerView)
    
    /// Tells the delegate when a scrolling animation in the pager view concludes.
    @objc
    optional func bannerViewDidEndScrollAnimation(_ pagerView: FXBannerView)
    
    /// Tells the delegate that the pager view has ended decelerating the scrolling movement.
    @objc
    optional func bannerViewDidEndDecelerating(_ pagerView: FXBannerView)
}

class FXBannerView: UIView {
    static var customItemHeight: CGFloat {
        let deviceWidth = UIScreen.main.bounds.width
        if deviceWidth <= 640 * 0.5 { // 5s
            return 218
        } else if deviceWidth > 640 * 0.5 && deviceWidth <= 750 * 0.5 { // 7系列
            return 280
        } else if deviceWidth >= 828 * 0.5 &&  deviceWidth <= 1125 * 0.5 { // x xr xs
            return 312
        } else if deviceWidth >= 1242 * 0.5 { // xsmax plus
            return 280
        }
        return 312.0.fit375Pt
    }
     open var interitemSpacing: CGFloat = 0 {
         didSet {
             self.collectionViewLayout.forceInvalidate()
         }
     }
    open var itemSize: CGSize = .zero {
         didSet {
             self.collectionViewLayout.forceInvalidate()
         }
     }
    let bag = DisposeBag()
    internal var numberOfSections: Int = 0
    internal var numberOfItems: Int = 0
    /// 内容视图原点与bannerView视图原点偏移的x位置百分比
    open var scrollOffset: CGFloat {
          let contentOffset = max(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y)
          let scrollOffset = Double(contentOffset / self.collectionViewLayout.itemSpacing)
          return fmod(CGFloat(scrollOffset), CGFloat(self.numberOfItems))
      }
    internal weak var collectionViewLayout: FXBannerLayout!
    internal weak var collectionView: UICollectionView!
    internal weak var contentView: UIView!
    fileprivate var possibleTargetingIndexPath: IndexPath?
    open fileprivate(set) var currentIndex: Int = 0
    weak var dataSource: FXBannerViewDataSource!
    weak var delegate: FXBannerViewDelegate?
    
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

extension FXBannerView {
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


extension FXBannerView {
    fileprivate func commonInit() {
        backgroundColor = .clear
        let contentView = UIView(frame:CGRect.zero)
        contentView.backgroundColor = UIColor.clear
        self.addSubview(contentView)
        self.contentView = contentView

        let collectionViewLayout = FXBannerLayout()
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


extension FXBannerView: UICollectionViewDataSource {
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


extension FXBannerView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let function = self.delegate?.bannerView(_:shouldHighlightItemAt:) else {
            return true
        }
        let index = indexPath.item % self.numberOfItems
        return function(self,index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let function = self.delegate?.bannerView(_:didHighlightItemAt:) else {
            return
        }
        let index = indexPath.item % self.numberOfItems
        function(self,index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let function = self.delegate?.bannerView(_:shouldSelectItemAt:) else {
            return true
        }
        let index = indexPath.item % self.numberOfItems
        return function(self,index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.possibleTargetingIndexPath = indexPath
        defer {
            self.possibleTargetingIndexPath = nil
        }
        let index = indexPath.item % self.numberOfItems
        scrollToItem(at: index, animated: true)
        guard let function = self.delegate?.bannerView(_:didSelectItemAt:) else {
                   return
        }
        function(self,index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let function = self.delegate?.bannerView(_:willDisplay:forItemAt:) else {
            return
        }
        let index = indexPath.item % self.numberOfItems
        function(self,cell,index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let function = self.delegate?.bannerView(_:didEndDisplaying:forItemAt:) else {
            return
        }
        let index = indexPath.item % self.numberOfItems
        function(self,cell,index)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.numberOfItems > 0 {
            let currentIndex = lround(Double(self.scrollOffset)) % self.numberOfItems
            if (currentIndex != self.currentIndex) {
                self.currentIndex = currentIndex
            }
        }
        guard let function = self.delegate?.bannerViewDidScroll else {
            return
        }
        function(self)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let function = self.delegate?.bannerViewWillBeginDragging(_:) {
            function(self)
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let function = self.delegate?.bannerViewWillEndDragging(_:targetIndex:) {
            let contentOffset = targetContentOffset.pointee.x
            let targetItem = lround(Double(contentOffset/self.collectionViewLayout.itemSpacing))
            function(self, targetItem % self.numberOfItems)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let function = self.delegate?.bannerViewDidEndDecelerating {
            function(self)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let function = self.delegate?.bannerViewDidEndScrollAnimation {
            function(self)
        }
    }
    
}


