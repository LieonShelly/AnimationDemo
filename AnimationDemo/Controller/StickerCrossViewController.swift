//
//  StickerCrossViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/7/27.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit


class StickerCrossViewController: UIViewController {
    fileprivate lazy var crossView: StickerCrossView = {
        let crossView = StickerCrossView()
        return crossView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(crossView)
        crossView.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.size.equalTo(CGSize(width: 85, height: 85))
        }
    }
}
