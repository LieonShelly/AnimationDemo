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
    
    fileprivate var bannerView: BannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = BannerView(frame: CGRect(x: 0,
                                                      y: self.view.center.y,
                                                      width: UIScreen.main.bounds.width,
                                                      height: 400))
        bannerView.dataSource = self
        let interSpacing: CGFloat = 5
        bannerView.interitemSpacing = interSpacing
        bannerView.itemSize = CGSize(width: (UIScreen.main.bounds.width - interSpacing - interSpacing * 2) / 1.5, height: 300)
        bannerView.register(UINib(nibName: "ImageTitleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageTitleCollectionViewCell")
        view.addSubview(bannerView)
        bannerView.showAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }

}


extension BannerViewController: BannerViewDataSource {
    func numberOfItems(in bannerView: BannerView) -> Int {
        return items.count
    }
    
    func bannerView(_ bannerView: BannerView, cellForItemAt index: Int) -> UICollectionViewCell {
        guard let cell = bannerView.dequeueReusableCell(withReuseIdentifier: "ImageTitleCollectionViewCell", at: index) as? ImageTitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let element = items[index]
        cell.label.text = element.title
        cell.imageView.image = UIImage(named: element.iconName)
        cell.contentView.backgroundColor = .white
        return cell
    }
}
