//
//  ProgressViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/11.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    @IBOutlet weak var animatieView: UIView!
    @IBOutlet weak var slider: UISlider!
    fileprivate lazy var progressView: ProgressView = {
        let progressView = ProgressView()
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(progressView)
        let pCenterX = progressView.centerXAnchor.constraint(equalTo: animatieView.centerXAnchor)
        let pCenterY = progressView.centerYAnchor.constraint(equalTo: animatieView.centerYAnchor)
        let pWidth = progressView.widthAnchor.constraint(equalToConstant: 100)
        let pHeight = progressView.heightAnchor.constraint(equalToConstant: 100)
        NSLayoutConstraint.activate([pCenterX, pCenterY, pWidth, pHeight])
        
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        
    }
}
