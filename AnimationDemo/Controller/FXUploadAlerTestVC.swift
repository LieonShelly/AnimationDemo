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
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        view.backgroundColor = .white
        let btn = UIButton(type: .contactAdd)
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
        }
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalTo(btn.snp.centerX)
            $0.top.equalTo(btn.snp.bottom).offset(10)
        }
        
        btn.rx.tap
            .subscribe(onNext: { [weak self](_) in
                guard let weakSelf = self else {
                    return
                }
                let vcc = FXUploadTextInputAlert("输入署名", textLimit: 100, inputText: nil) { (text) in
                    print(text)
                    label.text = text
                }
                vcc.modalPresentationStyle = .custom
                vcc.modalTransitionStyle = .crossDissolve
                weakSelf.present(vcc, animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
}
