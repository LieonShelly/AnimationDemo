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
