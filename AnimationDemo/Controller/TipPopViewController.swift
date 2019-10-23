//
//  TipPopViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/22.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

struct CommonTipPopParam: TipPopParam {
    var minInset: CGFloat!
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
    var minInset: CGFloat! = 10
    var point: CGPoint!
    var arrowDirection: ArrowDirection!
    var popSize: CGSize!
}

class TipPopViewController: UIViewController {
    @IBOutlet weak var animateView: UIView!
    fileprivate var selectedBtn: UIButton?
    fileprivate var param: CommonTipPopInputParam = CommonTipPopInputParam()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        animateView.isUserInteractionEnabled = true
        animateView.addGestureRecognizer(tap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: view)
        param.point = location!
        param.popSize = CGSize(width: 200, height: 80)
        TipPop.show(param)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        selectedBtn?.isSelected = false
        sender.isSelected = true
        selectedBtn = sender
        param.arrowDirection = ArrowDirection(rawValue: sender.tag) ?? .top
    }
    
    @objc fileprivate func tapAction(_ tap: UITapGestureRecognizer) {
        let location = tap.location(in: tap.view!)
        let keywindow = UIApplication.shared.keyWindow!
        let point = keywindow.convert(location, from: animateView)
        param.point = point
        param.popSize = CGSize(width: 200, height: 80)
        TipPop.show(param)
    }
}

extension TipPopViewController {
    
    
}
