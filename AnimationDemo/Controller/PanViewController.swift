//
//  PanViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class PanViewController: UIViewController {
    @IBOutlet weak var animationView: TouchView!
    
    @IBAction func enterAction(_ sender: Any) {
        IFPanAnimation.showPath(in: animationView.layer, points: animationView.currentHandlePoints) { (_) in
            debugPrint("complete")
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        animationView.clear()
    }
}
