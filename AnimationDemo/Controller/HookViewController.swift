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
    fileprivate lazy var nameView: FXTutorialStepNameView = {
        let nameView = FXTutorialStepNameView()
        nameView.layer.cornerRadius = 22
        nameView.layer.masksToBounds = true
        return nameView
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
            $0.size.equalTo(CGSize(width: 143, height: 55))
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
        stepView.exitClickAction = {
            debugPrint("exitClickAction")
        }
        
        view.addSubview(nameView)
        nameView.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.top.equalTo(view.snp.centerY)
            $0.width.equalTo(120)
            $0.height.equalTo(44)
        }
        nameView.titleBtnClick = {  [weak self] (currentHeight, isRevertArrow) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.nameView.snp.updateConstraints { $0.height.equalTo(currentHeight)}
            if isRevertArrow {
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               options: [.curveEaseInOut],
                               animations: {
                                weakSelf.nameView.arrow.layer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1)
                },
                               completion: nil)
            } else {
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               options: [.curveEaseInOut],
                               animations: {
                                weakSelf.nameView.arrow.transform = CGAffineTransform(rotationAngle: .pi * 2)
                },
                               completion: nil)
            }
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                            weakSelf.view.layoutIfNeeded()
            }, completion: nil)
            
            UIView.animate(withDuration: 0.25,
                           delay: 0.1,
                           options: [.curveEaseInOut],
                           animations: {
                            weakSelf.nameView.existBtn.alpha = isRevertArrow ? 1 : 0
            }, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stepView.startShow {
            
        }
       
        nameView.config("机制复制复制辅助", isShowArrow: true) { (width) in
            self.nameView.snp.updateConstraints { $0.width.equalTo(width) }
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                            self.nameView.layoutIfNeeded()
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
}




