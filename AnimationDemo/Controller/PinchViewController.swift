//
//  PinchViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class PinchViewController: UIViewController, DemoUIControl {
    @IBOutlet weak var startX: UITextField!
    @IBOutlet weak var endY: UITextField!
    @IBOutlet weak var endX: UITextField!
    @IBOutlet weak var startY: UITextField!
    @IBOutlet weak var pointCunt: UITextField!
    @IBOutlet weak var animationView: UIView!
    var animationName: String?
    
    @IBAction func enterAction(_ sender: Any) {
        let points = getDemoPoints()
        IFPinchAnimation.showKeyFrameDot(in: animationView.layer,
                                      centerPoint: animationView.center,
                                      points: points,
                                      completion: { _ in
                                        debugPrint("complete")
        })
    }

}

