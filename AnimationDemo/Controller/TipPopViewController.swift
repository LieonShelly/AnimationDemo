//
//  TipPopViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/22.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

struct CommonTipPopParam: TipPopParam {
    var priorityDirection: ArrowDirection!
    var direction: ArrowDirection!
    var arrowPosition: CGPoint!
    var arrorwSize: CGSize! = CGSize(width: 20, height: 20)
    var cornorRadius: CGFloat! = 10
    var popRect: CGRect!
    var borderColor: UIColor! = UIColor.yellow
    var borderWidth: CGFloat! = 1
    

}

struct CommonTipPopInputParam: TipPopInputParam {
    var point: CGPoint!
    var arrowDirection: ArrowDirection!
    var popSize: CGSize!
}

class TipPopViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: view)
        var param = CommonTipPopInputParam()
        param.arrowDirection = .right
        param.point = location
        param.popSize = CGSize(width: 200, height: 80)
        TipPop.show(param)
    }
}

extension TipPopViewController {
    
    
}
