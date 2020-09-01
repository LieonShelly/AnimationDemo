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
                loadingView.update(0)
            case .pulling:
                break
            case .refreshing:
                refreshAnimation()
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
        loadingView.center = CGPoint(x: mj_w * 0.5, y: mj_h * 0.5)
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
    let contentInsetTop: CGFloat = 50
    override func beginRefreshing() {
        state = .pulling
        let contentInset = scrollView!.contentInset
        scrollView?.contentInset = UIEdgeInsets(top: contentInset.top + contentInsetTop, left: contentInset.left, bottom: contentInset.bottom, right: contentInset.right)
        
    }
    
    override func endRefreshing() {
        state = .idle
        let contentInset = scrollView!.contentInset
        scrollView?.contentInset = UIEdgeInsets(top: contentInset.top - contentInsetTop, left: contentInset.left, bottom: contentInset.bottom, right: contentInset.right)
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
        rotation.duration = 0.4
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        rotation.autoreverses = false
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
        loadingView.layer.add(rotation, forKey: nil)
        
    }
}

private let contentOffsetY: CGFloat = 50.0

enum RefrehState {
    case normal
    case pulling
    case wilRefresh
}

public class LRefreshControl: UIView {
    public var refreshHandler: ( () -> (Void))?
    fileprivate weak var scrollView: UIScrollView?
    fileprivate lazy var refreshView: IFRefreshLoadingView = IFRefreshLoadingView()
    
    fileprivate var state: RefrehState = .normal {
        didSet {
            switch state {
            case .normal:
                refreshView.update(0)
            case .pulling:
                refreshView.update(1)
            case .wilRefresh:
                refreshAnimation()
            }
        }
    }
    
    public init() {
        super.init(frame: CGRect())
        addNormamRefesh()
        refreshView.backgroundColor = .red
        backgroundColor = .blue
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addNormamRefesh()
        addShineView()
    }
    
    public func beginRefresh() {
        guard let sv = scrollView else { return  }
        state = .wilRefresh
        var inset = sv.contentInset
        inset.top += contentOffsetY
        sv.contentInset = inset
        refreshHandler?()
    }
    
   public func endRefreshing() {
        if state != .wilRefresh {
            return
        }
        guard let sv = scrollView else { return  }
        state = .normal
        var inset = sv.contentInset
        inset.top -= contentOffsetY
        sv.contentInset = inset
    }
    
    public func needToShine(text: String) {
        refreshView.isHidden = true
    }
}

extension LRefreshControl {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let sv = newSuperview as? UIScrollView else { return  }
        scrollView = sv
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let sv = scrollView else { return  }
        let happenOffsetY = -sv.contentInset.top
        let offsetY = sv.contentOffset.y
        let pullPercent = (happenOffsetY - offsetY - 50) / 50
        let height = -(sv.contentInset.top + sv.contentOffset.y )
        if height < 0 {
            return
        }
        print(pullPercent)
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        if sv.isDragging {
            if height > contentOffsetY && state == .normal {
                state = .pulling
            } else if height <= contentOffsetY && state == .pulling {
                state = .normal
            }
        } else {
            if state == .pulling  {
                beginRefresh()
                
            }
        }
    }
    
    override public func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
}
extension LRefreshControl {
    fileprivate func refreshAnimation() {
        if refreshView.progress < 1 {
            refreshView.update(1)
        }
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.fillMode = .forwards
        rotation.duration = 0.4
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        rotation.autoreverses = false
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
        refreshView.layer.add(rotation, forKey: nil)
        
    }
    fileprivate  func addNormamRefesh() {
        backgroundColor = superview?.backgroundColor
        addSubview(refreshView)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
        refreshView.update(0)
    }
    
    fileprivate func addShineView() {

    }
}

class IFRefreshLoadingView: UIView {
    var progress: CGFloat = 0
    fileprivate lazy var topLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor(hex: 0xC8CED5)!.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = 2
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()
    fileprivate lazy var bottomLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor(hex: 0xC8CED5)!.cgColor
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
        if bottomLayer.animation(forKey: "strokeStart") != nil {
            bottomLayer.removeAllAnimations()
            isAnimating = false
        }
        if topLayer.animation(forKey: "strokeStart") != nil {
            topLayer.removeAllAnimations()
            isAnimating = false
        }
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
