//
//  BannerViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/7.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BannerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bannerView = BannerView(frame: CGRect(x: 0,
                                            y: self.view.center.y,
                                            width: UIScreen.main.bounds.width,
                                            height: 300))
        view.addSubview(bannerView)
    }


}
