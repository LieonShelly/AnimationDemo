//
//  IConViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/12.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class IConViewController: UIViewController {
    let bag = DisposeBag()
    fileprivate lazy var manualVideoIcon: FXTutorialManulVideoIcon = {
        let manualVideoIcon = FXTutorialManulVideoIcon()
        return manualVideoIcon
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(manualVideoIcon)
        manualVideoIcon.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 44, height: 44))
            $0.center.equalToSuperview()
        }
        
        let btn = UIButton(type: .contactAdd)
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 44, height: 44))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(manualVideoIcon.snp.bottom).offset(20)
        }
        
        btn.rx.tap
            .subscribe(onNext: { (_) in
                self.manualVideoIcon.show(nil, isShowBreath: true)
            })
        .disposed(by: bag)
        
    }


}
