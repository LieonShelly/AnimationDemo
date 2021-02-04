//
//  MennuCommonTitleCategoryView.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/3.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit

class MennuCommonTitleCategoryView: UIView {
    class UIEntity {
        var title: String
        var isSelected: Bool = false
        
        init(_ title: String, isSelected: Bool = false) {
            self.title = title
            self.isSelected = isSelected
        }
    }
    var selectedAction: ((Int) -> Void)?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    fileprivate lazy var titles: [UIEntity] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClassWithCell(MennuCommonTitleCategoryCell.self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func config(_ titles: [String], selectedIndex: Int = 0) {
        self.titles.removeAll()
        self.titles.append(contentsOf: titles.map { UIEntity($0, isSelected: false)})
        self.titles[selectedIndex].isSelected = true
        collectionView.reloadData()
    }
}

extension MennuCommonTitleCategoryView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = titles[indexPath.row]
        let cell = collectionView.dequeueCell(MennuCommonTitleCategoryCell.self, for: indexPath)
        cell.titleLabel.text = data.title
        cell.titleLabel.textColor = data.isSelected ? UIColor.red : UIColor.white
        return cell
    }
}

extension MennuCommonTitleCategoryView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        titles.forEach {
            $0.isSelected = false
        }
        let currentTitle = titles[indexPath.item]
        currentTitle.isSelected = true
        collectionView.reloadData()
        selectedAction?(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = titles[indexPath.item]
        return CGSize(width: text.title.width(font: UIFont.systemFont(ofSize: 15)), height: 40)
    }
    
}

class MennuCommonTitleCategoryCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
