//
//  LongPressViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/29.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class LongPressViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate lazy var dataSource: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        title = "长按图片放大"
        collectionView.delegate = self
        collectionView.registerNibWithCell(ImageCollectionViewCell.self)
        for _ in 0...100 {
            dataSource.append(UIImage(named: "balloon")!)
        }
        let press = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        collectionView.addGestureRecognizer(press)
    }
}

extension LongPressViewController {
    @objc fileprivate func longPress(_ ges: UILongPressGestureRecognizer) {
        switch ges.state {
        case .began:
            let location = ges.location(in: collectionView)
            guard let selectedIP = collectionView.indexPathForItem(at: location) else {
              return
            }
            guard let cell = collectionView.cellForItem(at: selectedIP) as? ImageCollectionViewCell else {
              return
            }
            let rect = view.convert(cell.frame, from: collectionView)
            PopImageBrowser.show(cell.imageView.image!,
                               selectedFrame: rect)
        default:
            break
        }
      
    }
}

extension LongPressViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ImageCollectionViewCell.self, for: indexPath)
        cell.imageView.image = dataSource[indexPath.item]
        return cell
    }
    
}

extension LongPressViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 15 * 3) / 2.0001,
                      height: (collectionView.bounds.width - 15 * 3) / 2.0001)
    }
}
