//
//  HomeViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/12/23.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let kbView = NumberKeyBoardView()
        view.addSubview(kbView)
        kbView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(NumberKeyBoardView.UISize.rightBtnSize.height * 2)
            $0.bottom.equalTo(-70)
        }
    }
    
}


class NumberKeyBoardView: UIView {
    struct NumberPadData {
        var text: String
        var isValid: Bool = true
    }
    fileprivate lazy var numbers: [NumberPadData] = [
        NumberPadData(text: "1", isValid: true),
        NumberPadData(text: "2", isValid: true),
        NumberPadData(text: "3", isValid: true),
        NumberPadData(text: "4", isValid: true),
        NumberPadData(text: "5", isValid: true),
        NumberPadData(text: "6", isValid: true),
        NumberPadData(text: "7", isValid: true),
        NumberPadData(text: "8", isValid: true),
        NumberPadData(text: "9", isValid: true),
        NumberPadData(text: "0", isValid: true),
        NumberPadData(text: ".", isValid: true),
        NumberPadData(text: "EMPTY", isValid: false),
    ]
    struct UISize {
        static let rightBtnSize: CGSize = CGSize(width: 100, height: 100)
    }
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    fileprivate lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("回退", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.them
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()
    
    fileprivate lazy var enterBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColor.them
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        let enterBtnView = UIView()
        let deleteBtnView = UIView()
        collectionView.registerNibWithCell(NumberKeyboardCell.self)
        collectionView.dataSource = self
        addSubview(collectionView)
        addSubview(enterBtnView)
        addSubview(deleteBtnView)
        deleteBtnView.addSubview(deleteBtn)
        enterBtnView.addSubview(enterBtn)
        deleteBtnView.snp.makeConstraints {
            $0.right.top.equalTo(0)
            $0.size.equalTo(UISize.rightBtnSize)
        }
        enterBtnView.snp.makeConstraints {
            $0.top.equalTo(deleteBtnView.snp.bottom)
            $0.right.equalTo(deleteBtnView.snp.right)
            $0.size.equalTo(UISize.rightBtnSize)
        }
        collectionView.snp.makeConstraints {
            $0.left.equalTo(0)
            $0.top.equalTo(deleteBtnView.snp.top)
            $0.right.equalTo(deleteBtnView.snp.left)
            $0.bottom.equalTo(enterBtnView.snp.bottom)
        }
        deleteBtn.snp.makeConstraints {
            $0.right.bottom.equalTo(deleteBtnView).inset(5)
            $0.left.equalTo(deleteBtnView).inset(0)
            $0.top.equalTo(deleteBtnView).inset(5 * 2)
                      
        }
        enterBtn.snp.makeConstraints {
            $0.right.equalTo(enterBtnView).inset(5)
            $0.bottom.equalTo(enterBtnView).inset(5 * 2)
            $0.top.equalTo(enterBtnView).inset(5)
            $0.left.equalTo(enterBtnView).inset(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 5
        let itemSize = CGSize(width: (bounds.width - UISize.rightBtnSize.width - inset * 2) / 3.0000,
                              height: (bounds.height - inset * 2) / 4.0000)
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = itemSize
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension NumberKeyBoardView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(NumberKeyboardCell.self, for: indexPath)
        let text = numbers[indexPath.row].text
        cell.label.setTitle(text, for: .normal)
        return cell
    }
}
