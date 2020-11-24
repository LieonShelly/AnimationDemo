//
//  FXTutorialImageContrastView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/26.
//  Copyright © 2020 lieon. All rights reserved.
// swiftlint:disable function_body_length file_length cyclomatic_complexity no_hiding_in_strings missing_docs

import Foundation
import UIKit

public class FXTutorialImageContrastView: UIView {
    public enum AnimationType {
        /// 渐隐渐现：图片尺寸要一致
        case easeInEaseOut
        /// 从左到右边，斜线扫描 /
        case leftToRightSlash
        /// 左右对比 - 静态
        case staticLeftRight
        /// 上下对比 - 静态
        case staticTopBottom
        
        public func isStatic() -> Bool {
            return self == .staticLeftRight ||
                self == .staticTopBottom
        }
    }
    struct AnimationName {
        static let effectImageViewEaseInEaseOut = "effectImageViewEaseInEaseOut"
        static let effectImageViewEaseInEaseOutShow = "effectImageViewEaseInEaseOutShow"
        static let originImageViewSlashLeftToRight = "originImageViewSlashLeftToRight"
        static let dismissBeforeLabelToTop = "dismissBeforeLabelToTop"
        static let showAfterLabelFromBotttom = "showAfterLabelFromBotttom"
        static let dismissAfterLabelToTop = "dismissAfterLabelToTop"
        static let effectImageZoomIn = "effectImageZoomIn"
        static let expandBeforeLabelContainer = "expandBeforeLabelContainer"
        static let expandAfterLabelContainer = "expandAfterLabelContainer"
        static let originImageViewShow = "originImageViewShow"
        static let originImageZoomOut = "originImageZoomOut"
        static let showBeforeLabelFromBotttom = "showBeforeLabelFromBotttom"
        static let originImageViewMaskToMedium = "originImageViewMaskToMedium"
        static let originImageViewDismiss = "originImageViewDismiss"
        static let originImageZoomIn = "originImageZoomIn"
        static let zoomOutAfterLabelContainer = "zoomOutAfterLabelContainer"
        static let effectImageZoomOut = "effectImageZoomOut"
        static let leftToRightSlashStart = "leftToRightSlashStart"
        static let leftToRightSlashEnd = "leftToRightSlashEnd"
        static let zoomOutBeforeLabelContainer = "zoomOutBeforeLabelContainer"
    }
    fileprivate lazy var beforeLabel: UILabel = {
        let label = UILabel()
        label.text = "Before"
        label.textColor = UIColor(hex: 0xffffff)
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 12, isBold: true)
        return label
    }()
    fileprivate lazy var afterLabel: UILabel = {
        let label = UILabel()
        label.text = "After"
        label.textColor = UIColor(hex: 0xffffff)
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 12, isBold: true)
        return label
    }()
    public var animationType: AnimationType = .easeInEaseOut
    fileprivate lazy var originImageView: UIImageView = {
        let originImageView = UIImageView()
        originImageView.contentMode = .scaleAspectFill
        originImageView.clipsToBounds = true
        return originImageView
    }()
    fileprivate lazy var effectImageView: UIImageView = {
        let originImageView = UIImageView()
        originImageView.contentMode = .scaleAspectFill
        originImageView.clipsToBounds = true
        return originImageView
    }()
    /// 被中断的动画
    fileprivate var errorAnima: CAAnimation?
    fileprivate var isRepeat: Bool = true
    public fileprivate(set) var isAnimating: Bool = false
    /// 给外界控制是否可以开启动画
    public var willAnimate: Bool = false
    fileprivate lazy var beforeLabelContainer: UIView = UIView()
    fileprivate lazy var afterLabelContainer: UIView = UIView()
    fileprivate var name: String = ""
    fileprivate lazy var effectImageMask: CAShapeLayer = {
        let shape = CAShapeLayer()
        return shape
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addNotification()
        clipsToBounds = true
        originImageView.layer.mask = effectImageMask
        beforeLabelContainer.backgroundColor = UIColor.white.withAlphaComponent(0.24)
        afterLabelContainer.backgroundColor = UIColor.white.withAlphaComponent(0.24)
        beforeLabelContainer.layer.cornerRadius = 10
        afterLabelContainer.layer.cornerRadius = 10
        beforeLabelContainer.layer.masksToBounds = true
        afterLabelContainer.layer.masksToBounds = true
        beforeLabelContainer.clipsToBounds = true
        afterLabelContainer.clipsToBounds = true
        addSubview(originImageView)
        addSubview(effectImageView)
        addSubview(beforeLabelContainer)
        addSubview(afterLabelContainer)
        beforeLabelContainer.addSubview(beforeLabel)
        afterLabelContainer.addSubview(afterLabel)
        originImageView.snp.makeConstraints { $0.edges.equalTo(0)}
        effectImageView.snp.makeConstraints { $0.edges.equalTo(0)}
        beforeLabelContainer.snp.makeConstraints {
            $0.left.equalTo(-200)
            $0.size.equalTo(CGSize(width: 50, height: 18))
            $0.bottom.equalTo(-20)
        }
        afterLabelContainer.snp.makeConstraints {
            $0.left.equalTo(-200)
            $0.size.equalTo(CGSize(width: 50, height: 18))
            $0.bottom.equalTo(-20)
        }
        beforeLabel.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        afterLabel.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        effectImageMask.frame = bounds
        let path = createMediumSlashPath()
        effectImageMask.path = path.cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FXTutorialImageContrastView {
    
    /// 配置图片
    public func config(with type: AnimationType, textBottomInset: CGFloat, textHorisonInset: CGFloat, name: String, originImage: UIImage, effectImage: UIImage) {
        self.name = name
        animationType = type
        transition(0.25, name: "config", delegator: nil, content: {
            self.effectImageView.image = effectImage
            self.originImageView.image = originImage
            self.resetUI(textBottomInset, textHorisonInset: textHorisonInset)
        })
    }
    
    /// 开始动画
    public func startAnimation() {
        isHidden = false
        directStartAnimation()
    }
    
    public func stopAnimation() {
        isHidden = true
    }
    
    public func shoulRepeatAniamtion(_ isRepeat: Bool = true) {
        self.isRepeat = isRepeat
    }
    
    public func prepareForReuse() {
        originImageView.image = nil
        effectImageView.image = nil
        isAnimating = false
        isRepeat = true
        willAnimate = false
    }
    
}

extension FXTutorialImageContrastView {
    /// 直接动画
    fileprivate func directStartAnimation() {
        isAnimating = true
        switch animationType {
        case .easeInEaseOut:
            effectImageViewEaseInEaseOut()
        case .leftToRightSlash:
            originImageViewSlashLeftToRight()
        case .staticLeftRight:
            break
        case .staticTopBottom:
            break
        }
    }
    
    /// layer转场动画 调整SubView的层级动画
    fileprivate func transition(_ duration: Double = 0.5, name: String, delegator: CAAnimationDelegate?, content: (() -> Void)) {
        let transition = CATransition()
        transition.subtype = .fromTop
        transition.type = .fade
        transition.duration = duration
        transition.delegate = delegator
        transition.setValue(name, forKey: "name")
        layer.add(transition, forKey: nil)
        content()
    }
    
    /// 中间位置的直线 /
    fileprivate func createMediumSlashPath() -> UIBezierPath {
        let path1 = UIBezierPath()
        path1.move(to: .zero)
        path1.addLine(to: CGPoint(x: bounds.width + 40, y: 0))
        path1.addLine(to: CGPoint(x: bounds.width + 40, y: bounds.height))
        path1.addLine(to: CGPoint(x: 0, y: bounds.height))
        path1.close()
        return path1
    }
    
    /// 起始位置的直线  /
    fileprivate func createStartSlashPath() -> UIBezierPath {
        let path0 = UIBezierPath()
        path0.move(to: .zero)
        path0.addLine(to: CGPoint(x: 0, y: 0))
        path0.addLine(to: CGPoint(x: 0, y: bounds.height))
        path0.addLine(to: CGPoint(x: -40, y: bounds.height))
        path0.addLine(to: CGPoint(x: -40, y: 0))
        path0.close()
        return path0
    }
    
    /// beforelabel从下至上出现
    fileprivate func showBeforeLabelFromBotttom() {
        if beforeLabel.layer.animation(forKey: AnimationName.showBeforeLabelFromBotttom + name) != nil {
            return
        }
        bringSubviewToFront(beforeLabelContainer)
        beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 1.5
        
        let position = CAKeyframeAnimation(keyPath: "position.y")
        position.values = [beforeLabelContainer.bounds.height * 1.5, beforeLabelContainer.bounds.height * 0.5]
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [0, 1]
        
        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime() //+ 0.5 + 1.5
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.delegate = self
        group.setValue(AnimationName.showBeforeLabelFromBotttom + name, forKey: "name")
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.animations = [position, opacity]
        beforeLabel.layer.add(group, forKey: AnimationName.showBeforeLabelFromBotttom + name)
    }
    
    /// beforelabel 中间位置至上消失
    fileprivate func dismissBeforeLabelToTop(_ delegattor: CAAnimationDelegate?) {
        if beforeLabel.layer.animation(forKey: AnimationName.dismissBeforeLabelToTop + name) != nil {
            return
        }
        bringSubviewToFront(beforeLabelContainer)
        beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 0.5
        
        let position = CAKeyframeAnimation(keyPath: "position.y")
        position.values = [beforeLabelContainer.bounds.height * 0.5, beforeLabelContainer.bounds.height * 0.2]
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0]
        
        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime() //+ 0.5 + 1.5
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.delegate = delegattor
        group.setValue(AnimationName.dismissBeforeLabelToTop + name, forKey: "name")
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.animations = [position, opacity]
        beforeLabel.layer.add(group, forKey: AnimationName.dismissBeforeLabelToTop + name)
    }
    
    /// afterlabel从下至上出现
    fileprivate func showAfterLabelFromBotttom() {
        if afterLabelContainer.layer.animation(forKey: AnimationName.showAfterLabelFromBotttom + name) != nil {
            return
        }
        bringSubviewToFront(afterLabelContainer)
        afterLabel.layer.position.y = afterLabelContainer.bounds.height * 1.5
        let position = CAKeyframeAnimation(keyPath: "position.y")
        position.values = [afterLabelContainer.bounds.height * 1.5, afterLabelContainer.bounds.height * 0.5]
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [0, 1]
        
        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime() //+ 0.5 + 1.5
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.delegate = self
        group.setValue(AnimationName.showAfterLabelFromBotttom + name, forKey: "name")
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.animations = [position, opacity]
        afterLabel.layer.add(group, forKey: AnimationName.showAfterLabelFromBotttom + name)
    }
    
    /// afterlabel 中间位置至上消失
    fileprivate func dismissAfterLabelToTop(_ delegator: CAAnimationDelegate?) {
        if afterLabel.layer.animation(forKey: AnimationName.dismissAfterLabelToTop + name) != nil {
            return
        }
        bringSubviewToFront(afterLabelContainer)
        afterLabel.layer.position.y = afterLabelContainer.bounds.height * 0.5
        let position = CAKeyframeAnimation(keyPath: "position.y")
        position.values = [afterLabelContainer.bounds.height * 0.5, afterLabelContainer.bounds.height * 0.2]
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0]
        
        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime() //+ 0.5 + 1.5
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.delegate = delegator
        group.setValue(AnimationName.dismissAfterLabelToTop + name, forKey: "name")
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.animations = [position, opacity]
        afterLabel.layer.add(group, forKey: AnimationName.dismissAfterLabelToTop + name)
    }
    
    /// 扫描：从左边到右边
    fileprivate func originImageViewSlashLeftToRight() {
        //// 移动mask
        if effectImageMask.animation(forKey: AnimationName.originImageViewSlashLeftToRight + name) != nil {
            return
        }
        expandBeforeLabelContainer()
        let maskPosition = CAKeyframeAnimation(keyPath: "position.x")
        maskPosition.values = [bounds.width * 0.5, bounds.width * 1.5]
        maskPosition.beginTime = CACurrentMediaTime() + 1.5
        maskPosition.duration = 1
        maskPosition.timingFunction = CAMediaTimingFunction(name: .linear)
        maskPosition.delegate = self
        maskPosition.setValue(AnimationName.originImageViewSlashLeftToRight + name, forKey: "name")
        maskPosition.isRemovedOnCompletion = false
        maskPosition.fillMode = .forwards
        effectImageMask.add(maskPosition, forKey: AnimationName.originImageViewSlashLeftToRight + name)
        isAnimating = true
    }
    
    /// 将原图的mask恢复到原始位置
    fileprivate func originImageViewMaskToMedium(_ delegator: CAAnimationDelegate?) {
        if effectImageMask.animation(forKey: AnimationName.originImageViewMaskToMedium + name) != nil {
            return
        }
        let maskPosition = CAKeyframeAnimation(keyPath: "position.x")
        maskPosition.values = [bounds.width * 1.5, bounds.width * 0.5]
        maskPosition.duration = 0.01
        maskPosition.timingFunction = CAMediaTimingFunction(name: .linear)
        maskPosition.delegate = delegator
        maskPosition.setValue(AnimationName.originImageViewMaskToMedium + name, forKey: "name")
        maskPosition.isRemovedOnCompletion = false
        maskPosition.fillMode = .forwards
        effectImageMask.add(maskPosition, forKey: AnimationName.originImageViewMaskToMedium + name)
    }
    
    /// 改变原图的opacity为0
    fileprivate func originImageViewDismiss(_ duration: Double = 0.5, delegator: CAAnimationDelegate?) {
        if originImageView.layer.animation(forKey: AnimationName.originImageViewDismiss + name) != nil {
            return
        }
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0]
        opacity.duration = duration
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacity.delegate = delegator
        opacity.setValue(AnimationName.originImageViewDismiss + name, forKey: "name")
        opacity.isRemovedOnCompletion = false
        opacity.fillMode = .forwards
        originImageView.layer.add(opacity, forKey: AnimationName.originImageViewDismiss + name)
    }
    
    /// 原图出现
    fileprivate func originImageViewShow(_ duration: Double = 0.5, delegator: CAAnimationDelegate?) {
        if originImageView.layer.animation(forKey: AnimationName.originImageViewShow + name) != nil {
            return
        }
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [0, 1]
        opacity.duration = duration
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacity.delegate = delegator
        opacity.setValue(AnimationName.originImageViewShow + name, forKey: "name")
        opacity.isRemovedOnCompletion = false
        opacity.fillMode = .forwards
        originImageView.layer.add(opacity, forKey: AnimationName.originImageViewShow + name)
    }
    
    /// 效果图放大动画
    fileprivate func effectImageZoomIn(_ delegator: CAAnimationDelegate?) {
        if effectImageView.layer.animation(forKey: AnimationName.effectImageZoomIn + name) != nil {
            return
        }
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1, 1.1]
        scale.beginTime = CACurrentMediaTime()
        scale.duration = 1
        scale.timingFunction = CAMediaTimingFunction(name: .linear)
        scale.delegate = delegator
        scale.setValue(AnimationName.effectImageZoomIn + name, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        effectImageView.layer.add(scale, forKey: AnimationName.effectImageZoomIn + name)
    }
    
    /// 原图放大动画
    fileprivate func originImageZoomIn(_ delegator: CAAnimationDelegate?) {
        if originImageView.layer.animation(forKey: AnimationName.originImageZoomIn + name) != nil {
            return
        }
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1, 1.1]
        scale.beginTime = CACurrentMediaTime()
        scale.duration = 1
        scale.timingFunction = CAMediaTimingFunction(name: .linear)
        scale.delegate = delegator
        scale.setValue(AnimationName.originImageZoomIn + name, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        originImageView.layer.add(scale, forKey: AnimationName.originImageZoomIn + name)
    }
    
    /// 效果图缩小动画
    fileprivate func effectImageZoomOut() {
        if effectImageView.layer.animation(forKey: AnimationName.effectImageZoomOut + name) != nil {
            return
        }
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1.1, 1]
        scale.beginTime = CACurrentMediaTime()
        scale.duration = 1
        scale.timingFunction = CAMediaTimingFunction(name: .linear)
        scale.delegate = self
        scale.setValue(AnimationName.effectImageZoomOut + name, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        effectImageView.layer.add(scale, forKey: AnimationName.effectImageZoomOut + name)
    }
    
    /// 原图缩小动画
    fileprivate func originImageZoomOut() {
        if originImageView.layer.animation(forKey: AnimationName.originImageZoomOut + name) != nil {
            return
        }
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1.1, 1]
        scale.beginTime = CACurrentMediaTime()
        scale.duration = 1
        scale.timingFunction = CAMediaTimingFunction(name: .linear)
        scale.delegate = self
        scale.setValue(AnimationName.originImageZoomOut + name, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        originImageView.layer.add(scale, forKey: AnimationName.originImageZoomOut + name)
    }
    
    /// beforeLabelContaine出现
    fileprivate func expandBeforeLabelContainer() {
        if beforeLabelContainer.layer.animation(forKey: AnimationName.expandBeforeLabelContainer + name) != nil {
            return
        }
        bringSubviewToFront(beforeLabelContainer)
        let scale = CAKeyframeAnimation(keyPath: "opacity")
        scale.values = [0, 1]
        scale.duration = 0.25
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.setValue(AnimationName.expandBeforeLabelContainer + name, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        beforeLabelContainer.layer.add(scale, forKey: AnimationName.expandBeforeLabelContainer + name)
    }
    
    /// afterLabelContainer展开
    fileprivate func expandAfterLabelContainer() {
        if afterLabelContainer.layer.animation(forKey: AnimationName.expandAfterLabelContainer + name) != nil {
            return
        }
        bringSubviewToFront(afterLabelContainer)
        let scale = CAKeyframeAnimation(keyPath: "opacity")
        scale.values = [0, 1]
        scale.duration = 0.25
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.setValue(AnimationName.expandAfterLabelContainer + name, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        afterLabelContainer.layer.add(scale, forKey: AnimationName.expandAfterLabelContainer + name)
    }
    
    /// beforeLabelContainer缩小
    fileprivate func zoomOutBeforeLabelContainer(_ duration: Double = 0.25, delegator: CAAnimationDelegate?) {
        if beforeLabelContainer.layer.animation(forKey: AnimationName.zoomOutBeforeLabelContainer + name) != nil {
            return
        }
        let scale = CAKeyframeAnimation(keyPath: "opacity")
        scale.values = [1, 0]
        scale.duration = duration
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = delegator
        scale.setValue(AnimationName.zoomOutBeforeLabelContainer + name, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        beforeLabelContainer.layer.add(scale, forKey: AnimationName.zoomOutBeforeLabelContainer + name)
    }
    
    /// afterLabelContainer缩小
    fileprivate func zoomOutAfterLabelContainer(_ duration: Double = 0.25, delegator: CAAnimationDelegate?) {
        if afterLabelContainer.layer.animation(forKey: AnimationName.zoomOutAfterLabelContainer + name) != nil {
            return
        }
        let scale = CAKeyframeAnimation(keyPath: "opacity")
        scale.values = [1, 0]
        scale.duration = duration
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = delegator
        scale.setValue(AnimationName.zoomOutAfterLabelContainer + name, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        afterLabelContainer.layer.add(scale, forKey: AnimationName.zoomOutAfterLabelContainer + name)
    }
    
    /// 隐藏labelContainer
    fileprivate func hiddenLabelContainer(_ duration: Double = 0.001) {
        let scale = CAKeyframeAnimation(keyPath: "opacity")
        scale.values = [1, 0]
        scale.duration = duration
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        scale.setValue("hiddenLabelContainer", forKey: "name")
        beforeLabelContainer.layer.add(scale, forKey: nil)
        afterLabelContainer.layer.add(scale, forKey: nil)
    }
    
    /// 显示labelContainer
    fileprivate func showLabelContainer(_ duration: Double = 0.001) {
        let scale = CAKeyframeAnimation(keyPath: "opacity")
        scale.values = [0, 1]
        scale.duration = duration
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        scale.setValue("showLabelContainer", forKey: "name")
        beforeLabelContainer.layer.add(scale, forKey: nil)
        afterLabelContainer.layer.add(scale, forKey: nil)
    }
    
    /// 效果图消失，before label出现， after label消失
    fileprivate func effectImageViewEaseInEaseOut() {
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0]
        opacity.delegate = self
        opacity.duration = 1
        opacity.fillMode = .forwards
        opacity.isRemovedOnCompletion = false
        opacity.beginTime = CACurrentMediaTime() + 1
        opacity.setValue(AnimationName.effectImageViewEaseInEaseOut, forKey: "name")
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        effectImageView.layer.add(opacity, forKey: nil)
        isAnimating = true
    }
    
    /// 效果图出现
    fileprivate func effectImageViewEaseInEaseOutShow() {
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [0, 1]
        opacity.delegate = self
        opacity.duration = 1
        opacity.fillMode = .forwards
        opacity.isRemovedOnCompletion = false
        opacity.beginTime = CACurrentMediaTime() + 1
        opacity.setValue(AnimationName.effectImageViewEaseInEaseOutShow, forKey: "name")
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        effectImageView.layer.add(opacity, forKey: nil)
    }

    fileprivate func resetUI(_ textBottomInset: CGFloat, textHorisonInset: CGFloat) {
        let beforeSize = CGSize(width: 51.0.fitiPhone5sSerires, height: 18.fitiPhone5sSerires)
        let afterSize = CGSize(width: 51.0.fitiPhone5sSerires, height: 18.fitiPhone5sSerires)
        switch animationType {
        case .easeInEaseOut:
            afterLabelContainer.layer.opacity = 0
            beforeLabelContainer.layer.opacity = 0
            beforeLabelContainer.layer.removeAllAnimations()
            afterLabelContainer.layer.removeAllAnimations()
            beforeLabel.layer.removeAllAnimations()
            afterLabel.layer.removeAllAnimations()
            hiddenLabelContainer()
            if originImageView.frame != bounds, effectImageView.frame != bounds {
                originImageView.snp.makeConstraints { $0.edges.equalTo(0)}
                effectImageView.snp.makeConstraints { $0.edges.equalTo(0)}
                beforeLabelContainer.snp.remakeConstraints {
                    $0.left.equalTo(textHorisonInset)
                    $0.bottom.equalTo(-textBottomInset)
                    $0.size.equalTo(beforeSize)
                }
                afterLabelContainer.snp.remakeConstraints {
                    $0.right.equalTo(-textHorisonInset)
                    $0.centerY.equalTo(beforeLabelContainer.snp.centerY)
                    $0.size.equalTo(afterSize)
                }
                layoutIfNeeded()
            }
            beforeLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabel.font = UIFont.customFont(ofSize: 12, isBold: true)
            beforeLabel.font = UIFont.customFont(ofSize: 12, isBold: true)
            beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 0.5
            afterLabel.layer.position.y = afterLabelContainer.bounds.height * 0.5
        case .leftToRightSlash:
            effectImageView.layer.removeAllAnimations()
            originImageView.layer.removeAllAnimations()
            afterLabelContainer.layer.opacity = 0
            afterLabel.layer.opacity = 0
            beforeLabelContainer.layer.opacity = 0
            beforeLabel.layer.opacity = 0
            if originImageView.frame.width != bounds.width, effectImageView.frame.width != bounds.width {
                originImageView.snp.makeConstraints { $0.edges.equalTo(0)}
                effectImageView.snp.makeConstraints { $0.edges.equalTo(0)}
            }
            beforeLabelContainer.snp.remakeConstraints {
                $0.left.equalTo(textHorisonInset)
                $0.bottom.equalTo(-textBottomInset)
                $0.size.equalTo(beforeSize)
            }
            afterLabelContainer.snp.remakeConstraints {
                $0.right.equalTo(-textHorisonInset)
                $0.centerY.equalTo(beforeLabelContainer.snp.centerY)
                $0.size.equalTo(afterSize)
            }
            layoutIfNeeded()
            bringSubviewToFront(effectImageView)
            bringSubviewToFront(originImageView)
            bringSubviewToFront(beforeLabelContainer)
            bringSubviewToFront(afterLabelContainer)
            beforeLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabel.font = UIFont.customFont(ofSize: 12, isBold: true)
            beforeLabel.font = UIFont.customFont(ofSize: 12, isBold: true)
            beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 1.5
            afterLabel.layer.position.y = afterLabelContainer.bounds.height * 1.5
        case .staticLeftRight:
            afterLabelContainer.layer.opacity = 1
            beforeLabelContainer.layer.opacity = 1
            beforeLabelContainer.layer.removeAllAnimations()
            afterLabelContainer.layer.removeAllAnimations()
            beforeLabel.layer.removeAllAnimations()
            afterLabel.layer.removeAllAnimations()
            showLabelContainer()
            beforeLabel.layer.opacity = 1
            afterLabel.layer.opacity = 1
            beforeLabelContainer.backgroundColor = UIColor.clear
            afterLabelContainer.backgroundColor = UIColor.clear
            beforeLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabel.font = UIFont.customFont(ofSize: 11, isBold: true)
            beforeLabel.font = UIFont.customFont(ofSize: 11, isBold: true)
            bringSubviewToFront(effectImageView)
            bringSubviewToFront(originImageView)
            bringSubviewToFront(beforeLabelContainer)
            bringSubviewToFront(afterLabelContainer)
            if originImageView.frame.width != bounds.width * 0.5 {
                originImageView.snp.remakeConstraints {
                    $0.left.top.bottom.equalToSuperview()
                    $0.right.equalTo(snp.centerX)
                }
                effectImageView.snp.remakeConstraints {
                    $0.right.top.bottom.equalToSuperview()
                    $0.left.equalTo(snp.centerX)
                }
                beforeLabelContainer.snp.remakeConstraints {
                    $0.left.equalTo(originImageView.snp.left).offset(10)
                    $0.bottom.equalTo(originImageView.snp.bottom).offset(-10)
                    $0.size.equalTo(CGSize(width: 51.0.fitiPhone5sSerires, height: 18.fitiPhone5sSerires))
                }
                afterLabelContainer.snp.remakeConstraints {
                    $0.left.equalTo(effectImageView.snp.left).offset(10)
                    $0.bottom.equalTo(effectImageView.snp.bottom).offset(-10)
                    $0.size.equalTo(CGSize(width: 51.0.fitiPhone5sSerires, height: 18.fitiPhone5sSerires))
                }
                layoutIfNeeded()
            }
            beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 0.5
            afterLabel.layer.position.y = afterLabelContainer.bounds.height * 0.5
        case .staticTopBottom:
            afterLabelContainer.layer.opacity = 1
            beforeLabelContainer.layer.opacity = 1
            beforeLabelContainer.layer.removeAllAnimations()
            afterLabelContainer.layer.removeAllAnimations()
            beforeLabel.layer.removeAllAnimations()
            afterLabel.layer.removeAllAnimations()
            showLabelContainer()
            beforeLabel.layer.opacity = 1
            afterLabel.layer.opacity = 1
            beforeLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabel.font = UIFont.customFont(ofSize: 11, isBold: true)
            beforeLabel.font = UIFont.customFont(ofSize: 11, isBold: true)
            
            bringSubviewToFront(effectImageView)
            bringSubviewToFront(originImageView)
            bringSubviewToFront(beforeLabelContainer)
            bringSubviewToFront(afterLabelContainer)
            if originImageView.frame.height != bounds.height * 0.5 {
                originImageView.snp.remakeConstraints {
                    $0.left.top.right.equalToSuperview()
                    $0.bottom.equalTo(snp.centerY)
                }
                effectImageView.snp.remakeConstraints {
                    $0.right.bottom.left.equalToSuperview()
                    $0.top.equalTo(snp.centerY)
                }
                beforeLabelContainer.snp.remakeConstraints {
                    $0.left.equalTo(originImageView.snp.left).offset(18)
                    $0.top.equalTo(originImageView.snp.top).offset(12)
                    $0.size.equalTo(CGSize(width: 51.0.fitiPhone5sSerires, height: 18.fitiPhone5sSerires))
                }
                afterLabelContainer.snp.remakeConstraints {
                    $0.left.equalTo(effectImageView.snp.left).offset(18)
                    $0.top.equalTo(effectImageView.snp.top).offset(12)
                    $0.size.equalTo(CGSize(width: 51.0.fitiPhone5sSerires, height: 18.fitiPhone5sSerires))
                }
                layoutIfNeeded()
            }
            beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 0.5
            afterLabel.layer.position.y = afterLabelContainer.bounds.height * 0.5
        }
    }
    
    fileprivate func addNotification() {

    }
}

extension FXTutorialImageContrastView: CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag == true else {
            errorAnima = anim
            isAnimating = false
            if let aniName = anim.value(forKey: "name") as? String {
                print("动画出错：\(aniName)")
            }
            return
        }
        animationLoop(anim)
    }

    
    fileprivate func animationLoop(_ anim: CAAnimation) {
        guard let aniName = anim.value(forKey: "name") as? String else {
            return
        }
        if aniName == AnimationName.effectImageViewEaseInEaseOut { /// EaseInEaseOut 这一轮动画结束
            effectImageView.layer.opacity = 0
            effectImageViewEaseInEaseOutShow()
        } else if aniName == AnimationName.effectImageViewEaseInEaseOutShow { /// EaseInEaseOut 进行到一半
            effectImageView.layer.opacity = 1
            beforeLabel.layer.opacity = 0
            if isRepeat {
                effectImageViewEaseInEaseOut()
            } else {
                isAnimating = false
            }
        } else if aniName == AnimationName.originImageViewSlashLeftToRight + name { /// 原图从左到右扫描完成，出现效果图放大，同时原图也跟着放大
//            effectImageMask.position.x = bounds.width * 1.5
            expandAfterLabelContainer()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.effectImageZoomIn(self)
                self.originImageZoomIn(self)
                self.originImageViewMaskToMedium(self)
                self.originImageViewDismiss(0.001, delegator: self)
            }
        } else if aniName == AnimationName.originImageViewMaskToMedium + name {
            effectImageMask.position.x = bounds.width * 0.5
        } else if aniName == AnimationName.originImageViewDismiss + name {
            originImageView.layer.opacity = 0
        } else if aniName == AnimationName.showBeforeLabelFromBotttom + name { /// beforelabel从下至上出现完成
            beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 0.5
            beforeLabel.layer.opacity = 1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.zoomOutBeforeLabelContainer(delegator: self)
                self.dismissBeforeLabelToTop(self)
            }
        } else if name == AnimationName.zoomOutBeforeLabelContainer + name {
            beforeLabelContainer.layer.opacity = 0
        } else if aniName == AnimationName.dismissBeforeLabelToTop + name || aniName == AnimationName.zoomOutBeforeLabelContainer + name { /// beforelabel从中间至上消失完成
            beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 1.5
            beforeLabel.layer.opacity = 0
        } else if aniName == AnimationName.showAfterLabelFromBotttom + name { /// afterLabel从下至上出现完成
            afterLabel.layer.position.y = afterLabelContainer.bounds.height * 0.5
            afterLabel.layer.opacity = 1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.zoomOutAfterLabelContainer(delegator: self)
                self.dismissAfterLabelToTop(self)
            }
        } else if aniName == AnimationName.dismissAfterLabelToTop + name || aniName == AnimationName.zoomOutAfterLabelContainer + name { /// afterLabel从中间至上消失完成
            afterLabel.layer.position.y = afterLabelContainer.bounds.height * 1.5
            afterLabel.layer.opacity = 0
        } else if aniName == AnimationName.effectImageZoomIn + name || aniName ==   AnimationName.originImageZoomIn + name { /// 效果图放大动画完成，
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.originImageViewShow(delegator: self)
            }
        } else if aniName == AnimationName.expandBeforeLabelContainer + name { /// beforeLabelContainer 展开完成
            beforeLabelContainer.layer.opacity = 1
            showBeforeLabelFromBotttom()
        } else if aniName == AnimationName.expandAfterLabelContainer + name { /// afterLabelContainer 展开完成
            afterLabelContainer.layer.opacity = 1
            showAfterLabelFromBotttom()
        } else if aniName == AnimationName.originImageViewShow + name { /// 原图出现完成
            originImageView.layer.opacity = 1
            originImageZoomOut()
            effectImageZoomOut()
        } else if aniName == AnimationName.originImageZoomOut + name || aniName == AnimationName.effectImageZoomOut + name { /// 一轮完成
            beforeLabelContainer.layer.removeAllAnimations()
            afterLabelContainer.layer.removeAllAnimations()
            beforeLabel.layer.removeAllAnimations()
            afterLabel.layer.removeAllAnimations()
            effectImageMask.removeAllAnimations()
            effectImageView.layer.removeAllAnimations()
            originImageView.layer.removeAllAnimations()
            afterLabelContainer.layer.opacity = 0
            afterLabel.layer.opacity = 0
            beforeLabelContainer.layer.opacity = 0
            beforeLabel.layer.opacity = 0
            if isRepeat {
                bringSubviewToFront(effectImageView)
                bringSubviewToFront(originImageView)
                bringSubviewToFront(beforeLabelContainer)
                bringSubviewToFront(afterLabelContainer)
                originImageViewSlashLeftToRight()
            } else {
                transition(0.5, name: AnimationName.leftToRightSlashEnd, delegator: nil, content: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.bringSubviewToFront(weakSelf.originImageView)
                    weakSelf.bringSubviewToFront(weakSelf.beforeLabelContainer)
                    weakSelf.bringSubviewToFront(weakSelf.effectImageView)
                    weakSelf.bringSubviewToFront(weakSelf.afterLabelContainer)
                    isAnimating = false
                })
            }
        } else {
            print("未捕获到的aniName: \(aniName)")
        }
    }
    
    fileprivate func log(_ name: String, desc: String) {
        if self.name == name {
//            printInFace(desc)
        }
    }
}
