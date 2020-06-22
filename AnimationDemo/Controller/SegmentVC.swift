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
    lazy var segmentedDataSource: JXSegmentedBaseDataSource = {
        let segmentedDataSource = JXSegmentedDotDataSource()
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titles = ["修图", "教程"]
        segmentedDataSource.titleNormalColor = UIColor.black
        segmentedDataSource.titleSelectedColor = .black
        segmentedDataSource.isTitleZoomEnabled = true
        segmentedDataSource.itemSpacing = 10
        segmentedDataSource.isSelectedAnimable = true
        segmentedDataSource.dotStates = [false, true]
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
            $0.left.equalTo(0)
            $0.width.equalTo(100)
            $0.top.equalTo(100)
            $0.height.equalTo(44)
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
