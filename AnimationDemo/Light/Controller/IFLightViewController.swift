//
//  IFLightViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/3.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit
import Kingfisher

class IFLightViewController: UIViewController {
    fileprivate lazy var toolbar: MenuCommonToolbarView = {
        let view = MenuCommonToolbarView()
        return view
    }()
    fileprivate lazy var contentView: MenuCommonContentView = {
        let view = MenuCommonContentView()
        return view
    }()
    fileprivate lazy var titleCateView: MennuCommonTitleCategoryView = {
        let view = MennuCommonTitleCategoryView()
        return view
    }()
    fileprivate lazy var bottomView: MenuCommonBottomView = {
        let view = MenuCommonBottomView()
        return view
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    fileprivate lazy var lists: [IFLightMenuCellType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configData()
      
    }
    
    fileprivate func configUI() {
        view.backgroundColor = .gray
        view.addSubview(toolbar)
        view.addSubview(contentView)
        contentView.addSubview(titleCateView)
        contentView.addSubview(bottomView)
        contentView.addSubview(collectionView)
        bottomView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(50)
            $0.bottom.equalTo(-UIDevice.current.safeAreaInsets.bottom)
        }
        collectionView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(80)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        titleCateView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(40)
            $0.bottom.equalTo(collectionView.snp.top)
            $0.top.equalTo(0)
        }
        toolbar.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(50)
            $0.bottom.equalTo(contentView.snp.top)
        }
        contentView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
        }
        collectionView.registerClassWithCell(MenuLightCustomCell.self)
        collectionView.registerClassWithCell(MennuCommonIconTitleCell.self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func configData() {
        let origin = IFLightMennuOriginCellData(icon: UIImage(named: "girl0")!, title: "原图")
        let custom = IFLightMennuOriginCellData(icon: UIImage(named: "girl0")!, title: "自定义")
        lists.append(.origin(origin))
        lists.append(.custom(custom))
        for index in 0 ..< 10 {
            let recommend = IFLightMennuRecommendCellData(iconURL: "https://store-bsy.c360dn.com/q_7f318f23c7e20b894655081ab88af31c.jpg", title: "梦" + "\(index)")
            lists.append(.recommend(recommend))
        }
        collectionView.reloadData()
        bottomView.config("面部光")
        titleCateView.config(["面部光","柔光","柔光","柔光","柔阿斯顿发送到发光","柔大师傅光"])
    }
    
}

extension IFLightViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = lists[indexPath.row]
        switch data {
        case .origin(let entity):
            let cell = collectionView.dequeueCell(MennuCommonIconTitleCell.self, for: indexPath)
            cell.icon.image = entity.icon
            cell.titleLabel.text = entity.title
            return cell
        case .custom(let entity):
            let cell = collectionView.dequeueCell(MenuLightCustomCell.self, for: indexPath)
            cell.icon.image = entity.icon
            cell.titleLabel.text = entity.title
            return cell
        case .recommend(let entity):
            let cell = collectionView.dequeueCell(MennuCommonIconTitleCell.self, for: indexPath)
            cell.icon.kf.setImage(with: URL(string: entity.iconURL!)!)
            cell.titleLabel.text = entity.title
            return cell
        }
    }
}

extension IFLightViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
    
}

