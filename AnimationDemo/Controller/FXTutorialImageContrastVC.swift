//
//  FXTutorialImageContrastVC.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/26.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FXTutorialImageContrastVC: UIViewController {
    fileprivate lazy var contrastView: FXTutorialImageContrastView = {
        let view = FXTutorialImageContrastView()
        return view
    }()
    
    fileprivate lazy var progressView: FXTutorialUploadProgressView = {
        let progressView = FXTutorialUploadProgressView()
        return progressView
    }()
    let toast = FXTutorialToast()
    
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(contrastView)
        contrastView.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.height.equalTo(300)
            $0.width.equalTo(300)
        }
      
        let btn = UIButton(type: .contactAdd)
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.centerX.equalTo(contrastView.snp.centerX)
            $0.top.equalTo(contrastView.snp.bottom).offset(10)
        }
        btn.rx.tap.subscribe(onNext: { [weak self](_) in
            self?.contrastView.startAnimation(with: .leftToRightSlash, textBottomInset: 30)
        })
        .disposed(by: bag)
        
        let btn0 = UIButton(type: .contactAdd)
        view.addSubview(btn0)
        btn0.snp.makeConstraints {
            $0.centerX.equalTo(contrastView.snp.centerX)
            $0.top.equalTo(btn.snp.bottom).offset(10)
        }
        btn0.rx.tap.subscribe(onNext: { [weak self](_) in
            self?.contrastView.shoulRepeatAniamtion( !self!.contrastView.isRepeat)
        })
            .disposed(by: bag)
        
        view.addSubview(toast)
        toast.isUserInteractionEnabled = true
        toast.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toast.show("asdfasd", bottomInset: 190)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        print("FXTutorialImageContrastVC - deinit")
    }
    
}
