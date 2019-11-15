//
//  BannerViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/7.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BannerViewController: UIViewController {
    fileprivate lazy var items: [DemoTouchUIModel] =  [
        DemoTouchUIModel(title: "极致肤质", iconName: "balloon"),
        DemoTouchUIModel(title: "局部精修", iconName: "balloon"),
        DemoTouchUIModel(title: "五官微调", iconName: "balloon"),
        DemoTouchUIModel(title: "照片调色", iconName: "balloon"),
        DemoTouchUIModel(title: "手动塑行", iconName: "balloon"),
        DemoTouchUIModel(title: "极致肤质", iconName: "balloon"),
        DemoTouchUIModel(title: "极致肤质", iconName: "balloon"),
        DemoTouchUIModel(title: "极致肤质", iconName: "balloon"),
        DemoTouchUIModel(title: "极致肤质", iconName: "balloon")]
    
    fileprivate var bannerView: FXBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = FXBannerView(frame: CGRect(x: 0,
                                                      y:20,
                                                      width: UIScreen.main.bounds.width,
                                                      height: FXBannerView.customItemHeight + 100))
        bannerView.dataSource = self
        bannerView.delegate = self
        let interSpacing: CGFloat = 5
        bannerView.interitemSpacing = interSpacing
        bannerView.backgroundColor = .red
        bannerView.itemSize = CGSize(width: (UIScreen.main.bounds.width - interSpacing - interSpacing * 2) / 1.5,
                                     height: FXBannerView.customItemHeight)
        bannerView.register(UINib(nibName: "FXBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FXBannerCollectionViewCell")
        view.addSubview(bannerView)
        bannerView.showAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }

}


extension BannerViewController: FXBannerViewDataSource {
    func numberOfItems(in bannerView: FXBannerView) -> Int {
        return items.count
    }
    
    func bannerView(_ bannerView: FXBannerView, cellForItemAt index: Int) -> UICollectionViewCell {
        guard let cell = bannerView.dequeueReusableCell(withReuseIdentifier: "FXBannerCollectionViewCell", at: index) as? FXBannerCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension BannerViewController: FXBannerViewDelegate {
    func bannerViewDidScroll(_ pagerView: FXBannerView) {
        print("pagerView - scrollOffset:\(pagerView.scrollOffset)")
    }
    
    func bannerViewWillBeginDragging(_ pagerView: FXBannerView) {
        
    }
    
    func bannerView(_ pagerView: FXBannerView, willDisplay cell: UICollectionViewCell, forItemAt index: Int) {
        print("pagerView - willDisplay:\(index)")
    }
    
    func bannerView(_ pagerView: FXBannerView, didEndDisplaying cell: UICollectionViewCell, forItemAt index: Int) {
         print("pagerView - didEndDisplaying:\(index)")
    }
    
}
