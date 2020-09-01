//
//  SegmentVC.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import JXSegmentedView

class SegmentVC: UIViewController {
    struct UISize {
        static let titleInset: CGFloat = 10
        static let naviHeight: CGFloat = 44
        static let navTop: CGFloat = UIDevice.current.isiPhoneXSeries ? 44 : 20
        static let navMaxY = navTop + naviHeight
    }
    fileprivate lazy var segmentedDataSource: JXSegmentedBaseDataSource = {
        let segmentedDataSource = JXSegmentedDotDataSource()
        segmentedDataSource.isTitleColorGradientEnabled = true
        
        segmentedDataSource.titles = ["修图", "教程"]
        segmentedDataSource.titleNormalColor = UIColor.black.withAlphaComponent(0.5)
        segmentedDataSource.titleSelectedColor = UIColor.black
        segmentedDataSource.isTitleZoomEnabled = false
        segmentedDataSource.itemSpacing = UISize.titleInset
        segmentedDataSource.isSelectedAnimable = true
        segmentedDataSource.titleNormalFont = UIFont.customFont(ofSize: 18, isBold: true)
        segmentedDataSource.titleSelectedFont = UIFont.customFont(ofSize: 18, isBold: true)
        segmentedDataSource.dotStates = [false, false]
        segmentedDataSource.dotColor = UIColor(hex: 0xf54fb0)!
        segmentedDataSource.dotSize = CGSize(width: 5, height: 5)
        return  segmentedDataSource
    }()
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    var vcLists: [IFListBaseViewController] = []
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        vcLists.append(CardViewController())
        vcLists.append(GradientBtnVC())
        view.backgroundColor = .white
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        segmentedView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(140)
            $0.bottom.equalTo(0)
            $0.height.equalTo(18)
        }
        listContainerView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(segmentedView.snp.bottom)
            $0.bottom.equalTo(0)
        }
    
    }
    
}

extension SegmentVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension SegmentVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return vcLists[index]
    }
}



class IFListBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension IFListBaseViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
