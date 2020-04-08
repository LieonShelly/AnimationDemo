//
//  FXTutorialImageContrastVC.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/26.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit

class FXTutorialImageContrastVC: UIViewController {
    fileprivate lazy var contrastView: FXTutorialImageContrastView = {
        let view = FXTutorialImageContrastView()
        return view
    }()
    
    fileprivate lazy var progressView: FXTutorialUploadProgressView = {
        let progressView = FXTutorialUploadProgressView()
        return progressView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(contrastView)
        contrastView.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.height.equalTo(300)
            $0.width.equalTo(300)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contrastView.startAnimation(with: .easeInEaseOut, textBottomInset: 30)
        progressView.show("geasdfsdf")
    }
    
}
