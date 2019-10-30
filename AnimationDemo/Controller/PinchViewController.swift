//
//  PinchViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class PinchViewController: UIViewController {
    @IBOutlet weak var animationView: PinchView!
    var animationName: String?
    
    @IBAction func enterAction(_ sender: Any) {
        var param = CommonPinchAnimationParam(animationView.layer, pointsA: animationView.pointsA, pointsB: animationView.pointsB)
        param.dotStartFillColor = UIColor.white.withAlphaComponent(0.5)
        param.dotMoveColor = UIColor.white.withAlphaComponent(0.5)
        param.dotEndFillColor = UIColor.white.withAlphaComponent(0.5)
        param.dotStartBorderColor = .white
        param.dotEndBorderColor = .white
        param.speed = 50
        IFAnimation.show(.pinch(param)) { (_) in
            debugPrint("complete")
        }
    }

}

