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
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        switch event.type {
        case .touches:
            handleEvent(event)
        case .motion:
            debugPrint("type - motion:\(event.type)")
        case .presses:
            debugPrint("type - presses:\(event.type)")
        case .remoteControl:
            debugPrint("type - remoteControl:\(event.type)")
        }
        
    }
 
    func startShowDot() {
        pannelView?.isHidden = false
    }
    
    func dismiss() {
        pannelView?.isHidden = true
    }
    
    func removePannel() {
        pannelView?.removeFromSuperview()
        pannelView = nil
    }
    
    func addPannel() {
        let pannelView = PannelView()
        pannelView.backgroundColor = .clear
        pannelView.frame = UIApplication.shared.keyWindow!.bounds
        addSubview(pannelView)
        self.pannelView = pannelView
    }
    
    var startTimeStamp: TimeInterval = 0
    var endTimeStamp: TimeInterval = 0
    
    fileprivate func handleEvent(_ event: UIEvent) {
        let currentWindow = UIApplication.shared.keyWindow!
        guard let touches = event.touches(for: currentWindow) else {
            return
        }
        if touches.count == 1 {
            let touch = Array(touches)[0]
          
            switch touch.phase {
            case .began:
                startTimeStamp = Date().timeIntervalSince1970
            case .ended:
                endTimeStamp = Date().timeIntervalSince1970
                print("startTimeStamp:\(startTimeStamp) - endTimeStamp:\(endTimeStamp) - detla:\(endTimeStamp - startTimeStamp)")
            default:
                break
            }
            guard let touchView = touch.view, touchView is UIScrollView else {
                return
            }
            let location = touch.location(in: currentWindow)
            guard let pannelView = self.pannelView  else {
                return
            }
            let center = pannelView.convert(location, from: currentWindow)
            pannelView.show([center])
        } else if touches.count == 2 {
            let firstTouch = Array(touches)[0]
            let secondTouch = Array(touches)[1]
            let firstLocation = firstTouch.location(in: currentWindow)
            let secondLocation = secondTouch.location(in: currentWindow)
            guard let pannelView = self.pannelView  else {
                return
            }
            let center0 = pannelView.convert(firstLocation, from: currentWindow)
            let center1 = pannelView.convert(secondLocation, from: currentWindow)
            pannelView.show([center0, center1])
        }

    }
    
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
