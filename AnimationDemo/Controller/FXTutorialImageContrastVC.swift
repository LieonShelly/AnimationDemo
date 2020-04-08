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
        contrastView.startAnimation(with: .leftToRightSlash, textBottomInset: 30)
        let btn = UIButton(type: .contactAdd)
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.centerX.equalTo(contrastView.snp.centerX)
            $0.top.equalTo(contrastView.snp.bottom).offset(10)
        }
        btn.rx.tap.subscribe(onNext: { [weak self](_) in
            self?.navigationController?.pushViewController(RefreshViewController(), animated: true)
        })
        .disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contrastView.recoverAnimation()
    }
    
    deinit {
        print("FXTutorialImageContrastVC - deinit")
    }
    
}
