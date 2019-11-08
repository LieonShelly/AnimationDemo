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

class BannerView: UIView {
    let bag = DisposeBag()
    internal weak var collectionViewLayout: BannerLayout!
    internal weak var collectionView: UICollectionView!
    internal weak var contentView: UIView!
    weak var dataSource: BannerViewDataSource!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
}


extension BannerView {
    fileprivate func commonInit() {
        // Content View
        backgroundColor = .red
        let contentView = UIView(frame:CGRect.zero)
        contentView.backgroundColor = UIColor.clear
        self.addSubview(contentView)
        self.contentView = contentView

        // UICollectionView
        let collectionViewLayout = BannerLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.yellow
        self.contentView.addSubview(collectionView)
        self.collectionView = collectionView
        self.collectionViewLayout = collectionViewLayout
       collectionView.registerNibWithCell(ImageTitleCollectionViewCell.self)
        let items = Observable<[DemoTouchUIModel]>.just([
                DemoTouchUIModel(title: "极致肤质", iconName: "balloon"),
                DemoTouchUIModel(title: "局部精修", iconName: "balloon"),
                DemoTouchUIModel(title: "五官微调", iconName: "balloon"),
                DemoTouchUIModel(title: "照片调色", iconName: "balloon"),
                DemoTouchUIModel(title: "手动塑行", iconName: "balloon"),
                DemoTouchUIModel(title: "极致肤质", iconName: "balloon"),
                DemoTouchUIModel(title: "极致肤质", iconName: "balloon"),
                DemoTouchUIModel(title: "极致肤质", iconName: "balloon"),
                DemoTouchUIModel(title: "极致肤质", iconName: "balloon")
            ])
        items.bind(to: collectionView.rx.items(cellIdentifier: String(describing: ImageTitleCollectionViewCell.self), cellType: ImageTitleCollectionViewCell.self)) { (_, element, cell) in
            cell.label.text = element.title
            cell.imageView.image = UIImage(named: element.iconName)
            cell.contentView.backgroundColor = .white
        }
        .disposed(by: bag)
       }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        self.collectionView.frame = self.contentView.bounds
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        collectionView.reloadData()
    }
}


extension BannerView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource.bannerView(self, cellForItemAt: indexPath.row)
    }
}


extension BannerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


