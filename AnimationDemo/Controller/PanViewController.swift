//
//  PanViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class PanViewController: UIViewController, DemoUIControl {
    @IBOutlet weak var startX: UITextField!
    @IBOutlet weak var endY: UITextField!
    @IBOutlet weak var endX: UITextField!
    @IBOutlet weak var startY: UITextField!
    @IBOutlet weak var pointCunt: UITextField!
    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func enterAction(_ sender: Any) {
        let points = getDemoPoints()
        IFPanAnimation.showPath(in: animationView.layer, points: points) { (_) in
            debugPrint("completion - PanViewController")
        }
    }
    
}
