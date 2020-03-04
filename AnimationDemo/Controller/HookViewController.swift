//
//  HookViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/3.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HookViewController: UIViewController {
    fileprivate lazy var stepView: FXTutorialStepView = {
        let stepView = FXTutorialStepView()
        return stepView
    }()
    let bag = DisposeBag()
    
    fileprivate lazy var slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.setValue(0, animated: false)
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(stepView)
        stepView.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.size.equalTo(CGSize(width: 120, height: 70))
        }
        
        view.addSubview(slider)
        slider.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(stepView.snp.bottom).offset(50)
            $0.width.equalTo(200)
        }
        slider.rx.value
            .asObservable()
            .subscribe(onNext: {
                self.stepView.update(CGFloat($0))
            })
        .disposed(by: bag)
    }
}




