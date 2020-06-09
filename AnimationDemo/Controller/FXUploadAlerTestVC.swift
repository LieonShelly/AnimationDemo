//
//  FXUploadAlerTestVC.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/9.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FXUploadAlerTestVC: UIViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let btn = UIButton(type: .contactAdd)
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
        }
        
        btn.rx.tap
            .subscribe(onNext: { [weak self](_) in
                guard let weakSelf = self else {
                    return
                }
                let vcc = FXUploadTextInputAlert("输入署名", textLimit: 100, inputText: nil) { (text) in
                    print(text)
                }
                vcc.modalPresentationStyle = .custom
                vcc.modalTransitionStyle = .crossDissolve
                weakSelf.present(vcc, animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
}
