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
        PinchAnimation.showKeyFrameDots(in: animationView.layer,
                                          pointsA: animationView.pointsA,
                                          pointsB: animationView.pointsB) { (_) in
          debugPrint("complete")
        }
    }

}

