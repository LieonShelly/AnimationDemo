//
//  FX3DLightExchangeLightSourceBtn.swift
//  AnimationDemo
//
//  Created by lieon on 2020/8/29.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit

class FX3DLightExchangeLightSourceBtn: UIView {
    struct UISize {
        static let topW: CGFloat = 27
        static let topH: CGFloat = 27
        static let bottomW: CGFloat = 22
        static let bottomH: CGFloat = 22
        static let normalSize = CGSize(width: (topW + bottomW) * 0.5, height: (topH + bottomH) * 0.5)
        static let size: CGSize = CGSize(width: topW + bottomW * 0.5, height: topH + bottomH * 0.5)
        
        static let moveD: CGFloat = bottomW * 0.5 * 0.7
        static let larageScale: CGFloat = topH / normalSize.height
        static let smallScale: CGFloat = bottomW / normalSize.height
        static let normalScale: CGFloat = (larageScale + smallScale) * 0.5
        static let maxZindex: CGFloat = 100
        static let minZindex: CGFloat = maxZindex - 1
    }
    enum Status: Int {
        case topToBottom
        case bottomToTop
        case none
    }
    var tapAction: (() -> Void)?
    fileprivate lazy var tapBtn: UIButton = {
        let tapBtn = UIButton()
        return tapBtn
    }()
    fileprivate lazy var topView: CornerShadowView = {
        let view = CornerShadowView()
        view.contentView.backgroundColor = .red
        view.contentView.layer.cornerRadius = 5
        view.contentView.layer.masksToBounds = true
        return view
    }()
    fileprivate lazy var bottomView: CornerShadowView = {
        let view = CornerShadowView()
        view.contentView.backgroundColor = .blue
        view.contentView.layer.cornerRadius = 5
        view.contentView.layer.masksToBounds = true
        return view
    }()
    fileprivate var status: Status = .topToBottom
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bottomView)
        addSubview(topView)
        addSubview(tapBtn)
        tapBtn.addTarget(self, action: #selector(tapBtnClick), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tapBtn.frame = bounds
        bottomView.frame = CGRect(x: UISize.bottomW * 0.5, y: 0, width: UISize.normalSize.width, height: UISize.normalSize.height)
        topView.frame = CGRect(x: 0, y: UISize.bottomH * 0.5, width: UISize.normalSize.width, height: UISize.normalSize.height)
        bottomView.layer.transform = CATransform3DMakeScale(UISize.smallScale, UISize.smallScale, UISize.smallScale)
        topView.layer.transform = CATransform3DMakeScale(UISize.larageScale, UISize.larageScale, UISize.larageScale)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
     
    func configColor(_ topViewColor: UIColor?, bottomViewColor: UIColor?) {
        switch status {
        case .topToBottom:
            topView.contentView.backgroundColor = topViewColor
            bottomView.contentView.backgroundColor = bottomViewColor
        case .bottomToTop:
            bottomView.contentView.backgroundColor = topViewColor
            topView.contentView.backgroundColor = bottomViewColor
        default:
            break
        }
    }
}

extension FX3DLightExchangeLightSourceBtn {
    @objc
    fileprivate func tapBtnClick() {
        tapAction?()
        if status == .none {
            status = .topToBottom
        }
        switch status {
        case .topToBottom:
            topViewCenter2LeftTB()
            bottomViewCenter2RightTB()
        case .bottomToTop:
            topViewCenter2LeftBT()
            bottomViewCenter2RightBT()
        default:
            break
        }
       
    }
    
    // topToBottom状态下：红框变小，位置从中心移动左下角
    fileprivate func topViewCenter2LeftTB() {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        let position = CABasicAnimation(keyPath: "position")
        position.fromValue = topView.center
        position.toValue = CGPoint(x: topView.center.x - UISize.moveD  , y: topView.center.y + UISize.moveD)
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = UISize.larageScale
        scale.toValue = UISize.normalScale
        group.animations = [position, scale]
//        group.setValue("topViewCenter2Left", forKey: "name")
        group.delegate = self
        topView.layer.add(group, forKey: nil)
    }
    
    // topToBottom状态下：红框变小后从左下角移动到绿框的中心位置
    fileprivate func topViewLeft2CenterTB() {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        let position = CABasicAnimation(keyPath: "position")
        position.toValue = bottomView.center
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue = UISize.smallScale
        group.animations = [position, scale]

        group.delegate = self
        topView.layer.add(group, forKey: nil)
    }
    
    // topToBottom状态下：绿框变小，位置从中心移动右上角
    fileprivate func bottomViewCenter2RightTB() {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        
        let position = CABasicAnimation(keyPath: "position")
        position.fromValue = bottomView.center
        position.toValue = CGPoint(x: bottomView.center.x + UISize.moveD  , y: bottomView.center.y - UISize.moveD)
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = UISize.smallScale
        scale.toValue = UISize.normalScale
        
        group.animations = [position, scale]
        group.setValue("bottomViewCenter2RightTB", forKey: "name")
        group.delegate = self
        bottomView.layer.add(group, forKey: nil)
    }
    
    // topToBottom状态下：绿框变小后位置从右上角移动到中心
    fileprivate func bottomViewRight2CenterTB() {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        
        let position = CABasicAnimation(keyPath: "position")
        position.toValue = topView.center
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue = UISize.larageScale
        
        group.animations = [position, scale]
        group.setValue("bottomViewRight2CenterTB", forKey: "name")
        group.delegate = self
        bottomView.layer.add(group, forKey: nil)
    }
    
    // bottomToTop状态下：红框变大，位置从中心移动左下角
    fileprivate func topViewCenter2LeftBT() {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        
        let position = CABasicAnimation(keyPath: "position")
        position.toValue = CGPoint(x: topView.center.x - UISize.moveD  , y: topView.center.y + UISize.moveD)
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue = UISize.normalScale
        
        group.animations = [position, scale]
        group.delegate = self
        topView.layer.add(group, forKey: nil)
    }
    // bottomToTop状态下：红框变大，位置从左下角移动中心
    fileprivate func topViewLeft2CenterBT() {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        let position = CABasicAnimation(keyPath: "position")
        position.toValue = topView.center
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue = UISize.larageScale
        group.animations = [position, scale]

        group.delegate = self
        topView.layer.add(group, forKey: nil)
    }
    
    // bottomToTop状态下：绿框变小，位置从中心移动右上角
    fileprivate func bottomViewCenter2RightBT() {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        
        let position = CABasicAnimation(keyPath: "position")
        position.toValue = CGPoint(x: bottomView.center.x + UISize.moveD  , y: bottomView.center.y - UISize.moveD)
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue = UISize.normalScale
        
        group.animations = [position, scale]
        group.setValue("bottomViewCenter2RightBT", forKey: "name")
        group.delegate = self
        bottomView.layer.add(group, forKey: nil)
    }
    
    // bottomToTop状态下：绿框变小后位置从右上角移动到中心
    fileprivate func bottomViewRight2CenterBT() {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        
        let position = CABasicAnimation(keyPath: "position")
        position.toValue = bottomView.center
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue = UISize.smallScale
        
        group.animations = [position, scale]
        group.setValue("bottomViewRight2CenterBT", forKey: "name")
        group.delegate = self
        bottomView.layer.add(group, forKey: nil)
    }
}

extension FX3DLightExchangeLightSourceBtn: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }
        if name == "bottomViewCenter2RightTB" {
            bottomView.layer.zPosition = UISize.maxZindex
            topView.layer.zPosition = UISize.minZindex
            topViewLeft2CenterTB()
            bottomViewRight2CenterTB()
        } else if name == "bottomViewCenter2RightBT" {
            bottomView.layer.zPosition = UISize.minZindex
            topView.layer.zPosition = UISize.maxZindex
            topViewLeft2CenterBT()
            bottomViewRight2CenterBT()
        } else if name == "bottomViewRight2CenterBT" {
            status = .topToBottom
        } else if name == "bottomViewRight2CenterTB" {
            status = .bottomToTop
        }
        print("status: \(status)")
    }
}



class CornerShadowView: UIView {
    lazy var gradientShadow: FXShadowView = {
        let thumbView = FXShadowView()
        thumbView.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        thumbView.shadowRadius = 5
        thumbView.shadowOffset = .zero
        thumbView.cornerRadius = 5
        return thumbView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(gradientShadow)
        addSubview(contentView)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(gradientShadow)
        addSubview(contentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
        gradientShadow.frame = contentView.frame
    }
}
