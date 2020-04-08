//
//  IFRefreshHeader.swift
//  InFace
//
//  Created by lieon on 2020/3/31.
//  Copyright © 2020 Pinguo. All rights reserved.
//

import Foundation
import MJRefresh
import UIKit

class IFRefreshHeader: MJRefreshHeader {
   fileprivate lazy var loadingView: IFRefreshLoadingView = IFRefreshLoadingView()
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                loadingView.reset()
                loadingView.layer.removeAllAnimations()
                break
            case .pulling:
                break
            case .refreshing:
                refreshAnimation()
                break
            default:
                break
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        mj_h = 50
        loadingView.frame.size = CGSize(width: 36, height: 36)
        addSubview(loadingView)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        let size = loadingView.frame.size
        loadingView.center = CGPoint(x: mj_w * 0.5, y: mj_h - size.height * 0.5)
    }
    
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        guard let offsetY = scrollView?.mj_offsetY else {
            return
        }
        guard let scrollView = scrollView else {
            return
        }
        let happenOffsetY = -scrollViewOriginalInset.top
        let pullPercent = (happenOffsetY - offsetY - 50) / mj_h
        if !scrollView.isDragging && pullPercent <= 0 && state != .refreshing {
            loadingView.reset()
            return
        }
        if state == .refreshing {
            return
        }
        loadingView.update(pullPercent)
    }
    
    override func endRefreshing() {
        super.endRefreshing()
    }
}

extension IFRefreshHeader {
    fileprivate func refreshAnimation() {
        if loadingView.progress < 1 {
            loadingView.update(1)
        }
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.fillMode = .forwards
        rotation.duration = 0.5
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        rotation.autoreverses = false
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
        loadingView.layer.add(rotation, forKey: nil)
        
    }
}


class IFRefreshLoadingView: UIView {
    var progress: CGFloat = 0
    fileprivate lazy var topLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor(hex: 0xD6DDE7)!.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = 2
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()
    fileprivate lazy var bottomLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor(hex: 0xD6DDE7)!.cgColor
        layer.lineCap = .round
        layer.lineWidth = 2
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    fileprivate var isAnimating: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(bottomLayer)
        layer.addSublayer(topLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let topframe = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.5)
        let bottomframe = CGRect(x: 0, y: topframe.maxY, width: bounds.width, height: bounds.height * 0.5)
        topLayer.frame = topframe
        bottomLayer.frame = bottomframe
        
        let topPath = UIBezierPath(arcCenter: CGPoint(x: topframe.width * 0.5, y: topframe.maxY),
                                   radius: 11,
                                   startAngle: .pi * 20 / 180 + .pi ,
                                   endAngle: -.pi * 20 / 180,
                                   clockwise: true)
        topLayer.path = topPath.cgPath
        
        let bottomPath = UIBezierPath(arcCenter: CGPoint(x: bottomLayer.bounds.width * 0.5, y: 0),
                                      radius: 11,
                                      startAngle: .pi * 20 / 180,
                                      endAngle: .pi - .pi * 20 / 180,
                                      clockwise: true)
        bottomLayer.path = bottomPath.cgPath
    }
    
    func update(_ progress: CGFloat) {
        topLayer.strokeEnd = progress
        bottomLayer.strokeEnd = progress
        self.progress = progress
    }
    
    func reset() {
        if isAnimating {
            return
        }
        isAnimating = true
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.toValue = 1
        strokeStart.duration = 0.25
        strokeStart.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeStart.fillMode = .forwards
        strokeStart.isRemovedOnCompletion = false
        strokeStart.delegate = self
        strokeStart.setValue("reset", forKey: "name")
        bottomLayer.add(strokeStart, forKey: "strokeStart")
        topLayer.add(strokeStart, forKey: "strokeStart")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IFRefreshLoadingView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag == true else {
            return
        }
        guard let name = anim.value(forKey: "name") as? String, name == "reset" else {
            return
        }
        isAnimating = false
        topLayer.strokeEnd = 0
        bottomLayer.strokeEnd = 0
        bottomLayer.removeAllAnimations()
        topLayer.removeAllAnimations()
    }
}

