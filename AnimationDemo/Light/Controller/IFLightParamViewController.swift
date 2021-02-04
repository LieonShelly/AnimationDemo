//
//  IFLightParamViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/4.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit

class IFLightParamViewController: UIViewController {
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    fileprivate lazy var contentView: MenuCommonContentView = {
        let view = MenuCommonContentView()
        return view
    }()
    fileprivate lazy var toolbar: MenuCommonToolbarView = {
        let view = MenuCommonToolbarView()
        return view
    }()
    fileprivate lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("返回", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    fileprivate lazy var titleCateView: MennuCommonTitleCategoryView = {
        let view = MennuCommonTitleCategoryView()
        return view
    }()
    
    fileprivate lazy var lists: [IFLightMennuOriginCellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configData()
    }
    
    fileprivate func configUI() {
        view.backgroundColor = .gray
        view.addSubview(toolbar)
        view.addSubview(contentView)
        contentView.addSubview(collectionView)
        contentView.addSubview(backBtn)
        contentView.addSubview(titleCateView)
        backBtn.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.centerY.equalToSuperview()
        }
     
        collectionView.snp.makeConstraints {
            $0.right.equalTo(0)
            $0.left.equalTo(backBtn.snp.right).offset(10)
            $0.height.equalTo(80)
            $0.bottom.equalTo(-UIDevice.current.safeAreaInsets.bottom)
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
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        collectionView.registerClassWithCell(MenuCommonIconTitleCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func configData() {
        lists.append(contentsOf: [IFLightMennuOriginCellData(icon: UIImage(named: "FX_3DLIGHT_SHAPELIGHT_BLURDEGREE")!, title: "光线强弱"),
                                  IFLightMennuOriginCellData(icon: UIImage(named: "FX_3DLIGHT_SHAPELIGHT_BLURDEGREE")!, title: "光源距离"),
                                  IFLightMennuOriginCellData(icon: UIImage(named: "FX_3DLIGHT_SHAPELIGHT_BLURDEGREE")!, title: "光线类型"),
                                  IFLightMennuOriginCellData(icon: UIImage(named: "FX_3DLIGHT_SHAPELIGHT_BLURDEGREE")!, title: "立体感"),
                                  IFLightMennuOriginCellData(icon: UIImage(named: "FX_3DLIGHT_SHAPELIGHT_BLURDEGREE")!, title: "阴影程度"),
                                  IFLightMennuOriginCellData(icon: UIImage(named: "FX_3DLIGHT_SHAPELIGHT_BLURDEGREE")!, title: "旋转"),
                                  IFLightMennuOriginCellData(icon: UIImage(named: "FX_3DLIGHT_SHAPELIGHT_BLURDEGREE")!, title: "曲线")])
        collectionView.reloadData()
    }
    
    @objc
    fileprivate func backAction() {
        navigationController?.popViewController(animated: true)
    }
}


extension IFLightParamViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = lists[indexPath.item]
        let cell = collectionView.dequeueCell(MenuCommonIconTitleCell.self, for: indexPath)
        cell.icon.image = data.icon
        cell.titleLabel.text = data.title
        return cell
    }
}

extension IFLightParamViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 2 {
            titleCateView.isHidden = false
            titleCateView.config(["强光", "弱光"])
        } else {
            titleCateView.isHidden = true
        }
    }
    
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
        return CGSize(width: 60, height: 60)
    }
    
}


