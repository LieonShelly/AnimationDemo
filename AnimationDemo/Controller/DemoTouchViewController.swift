//
//  DemoTouchViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/29.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct DemoTouchUIModel {
    var title: String
    var iconName: String
}

class DemoTouchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 60, height: 80)
        layout.scrollDirection = .horizontal
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
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
        }
        .disposed(by: bag)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            GuideStartView.show()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
}
