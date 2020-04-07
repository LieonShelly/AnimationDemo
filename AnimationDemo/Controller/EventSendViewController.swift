//
//  EventSendViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/11.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class FXWindow: UIWindow {
    
    var pannelView: PannelView?
    
}

struct ActionRecordEntity {
    var startTimestamp: TimeInterval = 0
    var endTimestamp: TimeInterval = 0
}

class PannelView: UIView {
    fileprivate lazy var dot0: UIView = {
        let dot = UIView()
        dot.bounds.size = CGSize(width: 40, height: 40)
        dot.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        dot.layer.cornerRadius = 10
        dot.layer.borderColor =  UIColor.lightGray.withAlphaComponent(0.7).cgColor
        dot.layer.borderWidth = 1
        return dot
    }()
    
    fileprivate lazy var dot1: UIView = {
        let dot = UIView()
        dot.bounds.size = CGSize(width: 40, height: 40)
        dot.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        dot.layer.cornerRadius = 10
        dot.layer.borderColor =  UIColor.lightGray.withAlphaComponent(0.7).cgColor
        dot.layer.borderWidth = 1
        return dot
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dot1.isHidden = true
        dot0.isHidden = true
        dot1.frame = CGRect(x: 100, y: 200, width: 40, height: 40)
        addSubview(dot1)
        dot0.frame = CGRect(x: 100, y: 200, width: 40, height: 40)
        addSubview(dot0)
        isUserInteractionEnabled = false
        tag = 1000
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension PannelView {
    func show(_ points: [CGPoint]) {
        debugPrint("PannelView-points:\(points)")
        guard !points.isEmpty else {
            return
        }
        if points.count == 1 {
            dot0.isHidden = false
            dot1.isHidden = true
            dot0.center = points[0]
        } else if points.count == 2 {
            dot0.isHidden = false
            dot1.isHidden = false
            dot0.center = points[0]
            dot1.center = points[1]
        }
    }
}
