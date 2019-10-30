//
//  TapAnimationViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TapAnimationViewController: UIViewController {
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var tapButton: UIButton!
    
    @IBAction func buttonTapAction(_ sender: UIButton) {
        showWaveAnimation()
    }
    
    fileprivate func showWaveAnimation() {
        let param = CommonAnimateParam(animateView.layer)
        param.fromPoint = CGPoint(x: animateView.center.x, y: 2000)
        param.endPoint = animateView.center
        param.color = UIColor.white
        param.layer = animateView.layer
        IFAnimation.show(.tap(param), completion: nil)
    }
    
}
