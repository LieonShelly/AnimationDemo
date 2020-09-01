//
//  CardViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/20.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class CardViewController: IFListBaseViewController {
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = TransformLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    fileprivate lazy var recommendCover: IFGradientView = {
        let view = IFGradientView()
        (view.layer as? CAGradientLayer)?.startPoint = CGPoint(x: 0.5, y: 0)
        (view.layer as? CAGradientLayer)?.endPoint = CGPoint(x: 0.5, y: 1)
        (view.layer as? CAGradientLayer)?.colors = [UIColor(hex: 0xffffff)!.withAlphaComponent(0).cgColor, UIColor(hex: 0xffffff)!.cgColor]
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.registerClassWithCell(WheelCell.self)
        
        
        view.addSubview(recommendCover)
        collectionView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.centerY.equalTo(view.snp.centerY)
            $0.height.equalTo(300)
        }
        
        recommendCover.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(145)
            $0.bottom.equalTo(collectionView.snp.bottom)
        }
    }
}

extension CardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 600
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(WheelCell.self, for: indexPath)
        cell.backgroundColor = UIColor.random
        return cell
    }
}

extension UIColor {
    static var random: UIColor {
        let red = CGFloat(arc4random() % 256)/255.0
        let green = CGFloat(arc4random() % 256)/255.0
        let blue = CGFloat(arc4random() % 256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
