//
//  TestViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    fileprivate lazy var bgView: UIView = UIView()
    fileprivate lazy var testView: UIView = UIView()
         
    override func viewDidLoad() {
        super.viewDidLoad()
        testView.frame =  CGRect(x: view.center.x,
                                y: view.center.y,
                                width: 100, height: 100)
        testView.backgroundColor = .yellow
        view.addSubview(testView)
        bgView.frame = CGRect(x: view.center.x,
                              y: view.center.y,
                              width: 100, height: 100)
        bgView.backgroundColor = .red
        // (0.5, 0.5)
        bgView.layer.anchorPoint = CGPoint(x: 0.3, y: 0.2)
        bgView.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.addSubview(bgView)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /**
         position.x = frame.origin.x + anchorPoint.x * bounds.size.width；
         position.y = frame.origin.y + anchorPoint.y * bounds.size.height
         */
     
        UIView.animate(withDuration: 0.25) {
            self.bgView.transform =  CGAffineTransform(scaleX: 1, y: 1)
        }
//        let anchorPoint = bgView.layer.anchorPoint
//        bgView.frame.origin.x = bgView.layer.position.x - 0.3 * testView.bounds.width
//        bgView.frame.origin.y = bgView.layer.position.y - 0.2 * testView.bounds.height
        debugPrint("testView - position:\(testView.layer.position) - bgView - position:\(bgView.layer.position)")
        debugPrint("testView - frame:\(testView.layer.frame) - bgView - frame:\(bgView.frame)")
    }

}
