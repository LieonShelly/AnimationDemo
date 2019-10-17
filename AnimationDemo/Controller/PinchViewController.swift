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
        let param = CommonPinchAnimationParam(animationView.layer, pointsA: animationView.pointsA, pointsB: animationView.pointsB)
        PinchAnimation.showKeyFrameDots(with: param) { (_) in
          debugPrint("complete")
        }
    }

}

