//
//  TapAnimationViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TapAnimationViewController: UIViewController {
    
    @IBOutlet weak var tapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func buttonTapAction(_ sender: UIButton) {
        IFTapAniamtion.jumpSpring(layer: sender.layer)
    }
}
