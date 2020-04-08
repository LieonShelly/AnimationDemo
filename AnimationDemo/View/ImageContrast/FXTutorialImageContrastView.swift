//
//  FXTutorialImageContrastView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/26.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit

class FXTutorialImageContrastView: UIView {
    enum AnimationType {
        case easeInEaseOut
        /// 从左到右边，斜线扫描 /
        case leftToRightSlash
        /// 左右对比 - 静态
        case staticLeftRight
        /// 上下对比 - 静态
        case staticTopBottom
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
    fileprivate var animationType: AnimationType = .easeInEaseOut
    fileprivate lazy var originImageView: UIImageView = {
        let originImageView = UIImageView()
        originImageView.image = UIImage(named: "bfore1")
        return originImageView
    }()
    fileprivate lazy var effectImageView: UIImageView = {
        let originImageView = UIImageView()
        originImageView.image = UIImage(named: "after1")
        return originImageView
    }()
    fileprivate lazy var sperateLine: FXGradientView = {
        let view = FXGradientView()
        (view.layer as! CAGradientLayer).colors = [
            UIColor(hex: 0xffffff)!.withAlphaComponent(0.4).cgColor,
            UIColor(hex: 0xffffff)!.cgColor,
            UIColor(hex: 0xffffff)!.withAlphaComponent(0.4).cgColor
        ]
        (view.layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 0.0)
        (view.layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 1)
        return view
    }()
    fileprivate var isRepeat: Bool = false
    fileprivate(set) var isAnimating: Bool = false
    fileprivate lazy var beforeLabelContainer: UIView = UIView()
    fileprivate lazy var afterLabelContainer: UIView = UIView()
    /// 被中断的动画
    fileprivate var errorAnima: CAAnimation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addNotification()
        clipsToBounds = true
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
        addSubview(sperateLine)
        beforeLabelContainer.addSubview(beforeLabel)
        afterLabelContainer.addSubview(afterLabel)
        reset()
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
        sperateLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(2)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    deinit {
        print("FXTutorialImageContrastView - deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FXTutorialImageContrastView {
    
    /// 配置图片
    public func config(_ originImage: UIImage, effectImage: UIImage) {
        effectImageView.image = effectImage
        originImageView.image = originImage
    }
    
    /// 开始动画
    public func startAnimation(with type: AnimationType, textBottomInset: CGFloat = 10,  textHorisonInset: CGFloat = 10) {
        animationType = type
        reset()
        resetUI(textBottomInset, textHorisonInset: textHorisonInset)
        directStartAnimation()
    }
    
    /// 是否重复动画，在动画结束时判断是否继续动画
    /// - Parameter isRepeat: 是否重复播放
    public func shoulRepeatAniamtion(_ isRepeat: Bool = true) {
        self.isRepeat = isRepeat
    }
    
    public func prepareForReuse() {
        originImageView.layer.removeAllAnimations()
        effectImageView.layer.removeAllAnimations()
        originImageView.layer.mask = nil
        effectImageView.layer.mask = nil
        originImageView.image = nil
        effectImageView.image = nil
        reset()
    }
    
    /// 恢复被中断的动画
    @objc
    public func recoverAnimation() {
        guard let errorAnima = self.errorAnima else {
            return
        }
        animationErrorHandle(errorAnima)
    }

}

extension FXTutorialImageContrastView {
    fileprivate func directStartAnimation() {
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
    
    /// 效果图消失
    fileprivate func effectImageViewEaseInEaseOut() {
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0]
        opacity.delegate = self
        opacity.duration = 1
        opacity.fillMode = .forwards
        opacity.isRemovedOnCompletion = false
        opacity.beginTime = CACurrentMediaTime() + 1.5
        opacity.setValue("effectImageViewEaseInEaseOut", forKey: "name")
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
        opacity.setValue("effectImageViewEaseInEaseOutShow", forKey: "name")
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        effectImageView.layer.add(opacity, forKey: nil)
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
        group.setValue("showBeforeLabelFromBotttom", forKey: "name")
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.animations = [position, opacity]
        beforeLabel.layer.add(group, forKey: nil)
    }
    
    /// beforelabel 中间位置至上消失
    fileprivate func dismissBeforeLabelToTop() {
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
        group.delegate = self
        group.setValue("dismissBeforeLabelToTop", forKey: "name")
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.animations = [position, opacity]
        beforeLabel.layer.add(group, forKey: nil)
        
    }
    
    /// afterlabel从下至上出现
    fileprivate func showAfterLabelFromBotttom() {
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
        group.setValue("showAfterLabelFromBotttom", forKey: "name")
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.animations = [position, opacity]
        afterLabel.layer.add(group, forKey: nil)
    }
    
    /// afterlabel 中间位置至上消失
    fileprivate func dismissAfterLabelToTop() {
        bringSubviewToFront(afterLabelContainer)
        afterLabel.layer.position.y = afterLabelContainer.bounds.height * 0.5
        let position = CAKeyframeAnimation(keyPath: "position.y")
        position.values = [afterLabelContainer.bounds.height * 0.5, -afterLabelContainer.bounds.height * 1.5]
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0]
        
        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime() //+ 0.5 + 1.5
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.delegate = self
        group.setValue("dismissAfterLabelToTop", forKey: "name")
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.animations = [position, opacity]
        afterLabel.layer.add(group, forKey: nil)
    }
    
    /// 斜线扫描：从左边到右边
    fileprivate func originImageViewSlashLeftToRight() {
        bringSubviewToFront(effectImageView)
        bringSubviewToFront(originImageView)
        bringSubviewToFront(beforeLabelContainer)
        bringSubviewToFront(sperateLine)
        expandBeforeLabelContainer()
        
        let shape = CAShapeLayer()
        shape.frame = bounds
        originImageView.layer.mask = shape
        let path = createMediumSlashPath()
        shape.path = path.cgPath
        
        //// 移动mask
        let maskPosition = CAKeyframeAnimation(keyPath: "position.x")
        maskPosition.values = [bounds.width * 0.5, bounds.width * 1.5]
        maskPosition.beginTime = CACurrentMediaTime() + 1.5
        maskPosition.duration = 0.7
        maskPosition.timingFunction = CAMediaTimingFunction(name: .linear)
        maskPosition.delegate = self
        maskPosition.setValue("originImageViewSlashLeftToRight", forKey: "name")
        maskPosition.isRemovedOnCompletion = false
        maskPosition.fillMode = .forwards
        shape.add(maskPosition, forKey: nil)
    }
    
    /// 将原图的mask恢复到原始位置
    fileprivate func originImageViewMaskToMedium(_ duration: Double = 0.01) {
        let maskPosition = CAKeyframeAnimation(keyPath: "position.x")
        maskPosition.values = [bounds.width * 1.5, bounds.width * 0.5]
        maskPosition.duration = duration
        maskPosition.timingFunction = CAMediaTimingFunction(name: .linear)
        maskPosition.delegate = self
        maskPosition.setValue(AnimationName.originImageViewMaskToMedium, forKey: "name")
        maskPosition.isRemovedOnCompletion = false
        maskPosition.fillMode = .forwards
        originImageView.layer.mask?.add(maskPosition, forKey: nil)
    }
    
    /// 改变原图的opacity为0
    fileprivate func originImageViewDismiss(_ duration: Double = 0.5) {
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0]
        opacity.duration = duration
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacity.delegate = self
        opacity.setValue(AnimationName.originImageViewDismiss, forKey: "name")
        opacity.isRemovedOnCompletion = false
        opacity.fillMode = .forwards
        originImageView.layer.add(opacity, forKey: nil)
    }
    
    /// 原图出现
    fileprivate func originImageViewShow(_ duration: Double = 0.5) {
         let opacity = CAKeyframeAnimation(keyPath: "opacity")
         opacity.values = [0, 1]
         opacity.duration = duration
         opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
         opacity.delegate = self
        opacity.setValue(AnimationName.originImageViewShow, forKey: "name")
         opacity.isRemovedOnCompletion = false
         opacity.fillMode = .forwards
         originImageView.layer.add(opacity, forKey: nil)
     }
    
    /// 效果图放大动画
    fileprivate func effectImageZoomIn() {
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1, 1.1]
        scale.beginTime = CACurrentMediaTime()
        scale.duration = 1
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.setValue(AnimationName.effectImageZoomIn, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        effectImageView.layer.add(scale, forKey: nil)
    }
    
    /// 原图放大动画
    fileprivate func originImageZoomIn() {
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1, 1.1]
        scale.beginTime = CACurrentMediaTime()
        scale.duration = 1
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.setValue( AnimationName.originImageZoomIn, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        originImageView.layer.add(scale, forKey: nil)
    }
    
    /// 效果图缩小动画
    fileprivate func effectImageZoomOut() {
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1.1, 1]
        scale.beginTime = CACurrentMediaTime()
        scale.duration = 1
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.setValue("effectImageZoomOut", forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        effectImageView.layer.add(scale, forKey: nil)
    }
    
    /// 原图缩小动画
    fileprivate func originImageZoomOut() {
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1.1, 1]
        scale.beginTime = CACurrentMediaTime()
        scale.duration = 1
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.setValue("originImageZoomOut", forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        originImageView.layer.add(scale, forKey: nil)
    }
    
    /// beforeLabelContaine出现
    fileprivate func expandBeforeLabelContainer() {
         bringSubviewToFront(beforeLabelContainer)
        let scale = CAKeyframeAnimation(keyPath: "opacity")
        scale.values = [0, 1]
        scale.duration = 0.25
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.setValue(AnimationName.expandBeforeLabelContainer, forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        scale.setValue("expandBeforeLabelContainer", forKey: "name")
        beforeLabelContainer.layer.add(scale, forKey: nil)
    }
    
    /// afterLabelContainer展开
    fileprivate func expandAfterLabelContainer() {
        bringSubviewToFront(afterLabelContainer)
        let scale = CAKeyframeAnimation(keyPath: "opacity")
        scale.values = [0, 1]
        scale.duration = 0.25
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.setValue("expandAfterLabelContainer", forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        afterLabelContainer.layer.add(scale, forKey: nil)
    }
    
    /// beforeLabelContainer缩小
    fileprivate func zoomOutBeforeLabelContainer(_ duration: Double = 0.25) {
        let scale = CAKeyframeAnimation(keyPath: "opacity")
        scale.values = [1, 0]
        scale.duration = duration
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.setValue("zoomOutBeforeLabelContainer", forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        beforeLabelContainer.layer.add(scale, forKey: nil)
    }
    
    /// afterLabelContainer缩小
    fileprivate func zoomOutAfterLabelContainer(_ duration: Double = 0.25) {
        let scale = CAKeyframeAnimation(keyPath: "opacity")
        scale.values = [1, 0]
        scale.duration = duration
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.delegate = self
        scale.setValue("zoomOutAfterLabelContainer", forKey: "name")
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        afterLabelContainer.layer.add(scale, forKey: nil)
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
    
    fileprivate func reset() {
        originImageView.layer.mask = nil
        originImageView.layer.removeAllAnimations()
        effectImageView.layer.removeAllAnimations()
        beforeLabel.layer.removeAllAnimations()
        afterLabel.layer.removeAllAnimations()
        sperateLine.isHidden = true
        isRepeat = true
        beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 1.5
        afterLabel.layer.position.y = afterLabelContainer.bounds.height * 1.5
        hiddenLabelContainer()
    }
    
    fileprivate func resetUI(_ textBottomInset: CGFloat, textHorisonInset: CGFloat) {
        let beforeSize = CGSize(width: 52, height: 20)
        let afterSize = CGSize(width: 52, height: 20)
        switch animationType {
        case .easeInEaseOut:
            hiddenLabelContainer()
            beforeLabelContainer.isHidden = true
            afterLabelContainer.backgroundColor = UIColor.clear
            afterLabel.font = UIFont.customFont(ofSize: 13, isBold: true)
            beforeLabel.font = UIFont.customFont(ofSize: 13, isBold: true)
            beforeLabelContainer.snp.remakeConstraints {
                $0.left.equalTo(20)
                $0.bottom.equalTo(-textBottomInset)
                $0.size.equalTo(beforeSize)
            }
            afterLabelContainer.snp.remakeConstraints {
                $0.left.equalTo(beforeLabelContainer.snp.left)
                $0.centerY.equalTo(beforeLabelContainer.snp.centerY)
                $0.size.equalTo(afterSize)
            }
            layoutIfNeeded()
        case .leftToRightSlash:
            hiddenLabelContainer()
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
            (sperateLine.layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 0.0)
            (sperateLine.layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 1)
            sperateLine.isHidden = true
            sperateLine.snp.remakeConstraints {
                $0.right.equalTo(snp.left)
                $0.width.equalTo(2)
                $0.top.equalTo(0)
                $0.bottom.equalTo(0)
            }
            bringSubviewToFront(effectImageView)
            bringSubviewToFront(originImageView)
            bringSubviewToFront(beforeLabelContainer)
            bringSubviewToFront(afterLabelContainer)
            bringSubviewToFront(sperateLine)
            layoutIfNeeded()
            beforeLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabel.font = UIFont.customFont(ofSize: 11, isBold: true)
            beforeLabel.font = UIFont.customFont(ofSize: 11, isBold: true)
            beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 1.5
            afterLabel.layer.position.y = afterLabelContainer.bounds.height * 1.5
        case .staticLeftRight:
            showLabelContainer()
            (sperateLine.layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 0.0)
            (sperateLine.layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 1)
            beforeLabel.layer.opacity = 1
            afterLabel.layer.opacity = 1
            sperateLine.isHidden = true
            beforeLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabel.font = UIFont.customFont(ofSize: 11, isBold: true)
            beforeLabel.font = UIFont.customFont(ofSize: 11, isBold: true)
            bringSubviewToFront(effectImageView)
            bringSubviewToFront(originImageView)
            bringSubviewToFront(beforeLabelContainer)
            bringSubviewToFront(afterLabelContainer)
            bringSubviewToFront(sperateLine)
            sperateLine.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(2)
                $0.top.equalTo(0)
                $0.bottom.equalTo(0)
            }
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
                $0.size.equalTo(beforeSize)
            }
            afterLabelContainer.snp.remakeConstraints {
                $0.left.equalTo(effectImageView.snp.left).offset(10)
                $0.bottom.equalTo(effectImageView.snp.bottom).offset(-8)
                $0.size.equalTo(afterSize)
            }
            layoutIfNeeded()
        case .staticTopBottom:
            showLabelContainer()
            (sperateLine.layer as! CAGradientLayer).startPoint = CGPoint(x: 0, y: 0.5)
            (sperateLine.layer as! CAGradientLayer).endPoint = CGPoint(x: 1, y: 0.5)
            beforeLabel.layer.opacity = 1
            afterLabel.layer.opacity = 1
            sperateLine.isHidden = true
            beforeLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabelContainer.backgroundColor = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 18 / 255.0, alpha: 0.31)
            afterLabel.font = UIFont.customFont(ofSize: 11, isBold: true)
            beforeLabel.font = UIFont.customFont(ofSize: 11, isBold: true)
            bringSubviewToFront(effectImageView)
            bringSubviewToFront(originImageView)
            bringSubviewToFront(beforeLabelContainer)
            bringSubviewToFront(afterLabelContainer)
            bringSubviewToFront(sperateLine)
            sperateLine.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.height.equalTo(2)
                $0.left.equalTo(0)
                $0.right.equalTo(0)
            }
            originImageView.snp.remakeConstraints {
                $0.left.top.right.equalToSuperview()
                $0.bottom.equalTo(snp.centerY)
            }
            effectImageView.snp.remakeConstraints {
                $0.right.bottom.left.equalToSuperview()
                $0.top.equalTo(snp.centerY)
            }
            beforeLabelContainer.snp.remakeConstraints {
                $0.left.equalTo(originImageView.snp.left).offset(12)
                $0.top.equalTo(8)
                $0.size.equalTo(beforeSize)
            }
            afterLabelContainer.snp.remakeConstraints {
                $0.left.equalTo(effectImageView.snp.left).offset(12)
                $0.top.equalTo(effectImageView.snp.top).offset(8)
                $0.size.equalTo(afterSize)
            }
            layoutIfNeeded()
        }
    }
    
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(recoverAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}

extension FXTutorialImageContrastView: CAAnimationDelegate {
 
    func animationDidStart(_ anim: CAAnimation) {
        guard !isRepeat else {
            return
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag == true else {
            isAnimating = false
            errorAnima = anim
            return
        }
         animationLoop(anim)
    }
    
    fileprivate func animationErrorHandle(_ anim: CAAnimation) {
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }
        print(name)
        isAnimating = true
        if name == AnimationName.originImageZoomIn || name == AnimationName.effectImageZoomIn  { /// 原图效果放大后，动画被中断
            originImageViewMaskToMedium()
            originImageViewDismiss(0.001)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.originImageViewShow()
            }
        }  else if name == AnimationName.zoomOutAfterLabelContainer { /// AfterLabelContainer 动画被中断
            originImageViewMaskToMedium()
            originImageViewDismiss(0.001)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.originImageViewShow()
            }
        } else if name == AnimationName.originImageViewDismiss {
            showAfterLabelFromBotttom()
            originImageViewMaskToMedium()
            originImageViewDismiss(0.001)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.originImageViewShow()
            }
        } else if name == AnimationName.dismissBeforeLabelToTop {
            zoomOutBeforeLabelContainer()
            expandAfterLabelContainer()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.effectImageZoomIn()
                self.originImageZoomIn()
                self.originImageViewMaskToMedium()
                self.originImageViewDismiss(0.001)
            }
        } else if name == AnimationName.effectImageZoomOut {
            originImageViewSlashLeftToRight()
        } else if name == AnimationName.dismissAfterLabelToTop {
            zoomOutAfterLabelContainer()
        } else if name == AnimationName.originImageViewMaskToMedium {
            originImageViewDismiss(0.001)
            showAfterLabelFromBotttom()
            originImageViewMaskToMedium()
            originImageViewDismiss(0.001)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.originImageViewShow()
            }
        } else if name == AnimationName.showAfterLabelFromBotttom {
            dismissAfterLabelToTop()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
                self.originImageViewMaskToMedium()
                self.originImageViewDismiss(0.001)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.originImageViewShow()
            }
        } else {
            animationLoop(anim)
        }
    }
    
    fileprivate func animationLoop(_ anim: CAAnimation) {
        if let name = anim.value(forKey: "name") as? String, name == AnimationName.effectImageViewEaseInEaseOut { /// EaseInEaseOut 这一轮动画结束
            effectImageView.layer.opacity = 0
            effectImageViewEaseInEaseOutShow()
        } else if let name = anim.value(forKey: "name") as? String, name == AnimationName.effectImageViewEaseInEaseOutShow { /// EaseInEaseOut 进行到一半
            effectImageView.layer.opacity = 1
            if isRepeat {
                bringSubviewToFront(afterLabel)
                effectImageViewEaseInEaseOut()
            } else {
                let labelopacity = CAKeyframeAnimation(keyPath: "opacity")
                labelopacity.values = [1, 0]
                labelopacity.duration = 0.25
                labelopacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                labelopacity.isRemovedOnCompletion = false
                labelopacity.fillMode = .forwards
                labelopacity.delegate = self
                labelopacity.setValue("easeInEaseOutFinish", forKey: "name")
                afterLabel.layer.add(labelopacity, forKey: nil)
                isAnimating = false
            }
        } else if let name = anim.value(forKey: "name") as? String, name == AnimationName.originImageViewSlashLeftToRight { /// 原图从左到右扫描完成，出现效果图放大，同时原图也跟着放大
            expandAfterLabelContainer()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.effectImageZoomIn()
                self.originImageZoomIn()
                self.originImageViewMaskToMedium()
                self.originImageViewDismiss(0.001)
            }
        } else if let name = anim.value(forKey: "name") as? String, name == AnimationName.showBeforeLabelFromBotttom { /// beforelabel从下至上出现完成
            beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 0.5
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.zoomOutBeforeLabelContainer()
                self.dismissBeforeLabelToTop()
            }
        } else if let name = anim.value(forKey: "name") as? String, name == AnimationName.zoomOutBeforeLabelContainer { /// beforelabel从中间至上消失完成
            beforeLabel.layer.position.y = beforeLabelContainer.bounds.height * 1.5
        } else if let name = anim.value(forKey: "name") as? String, name == AnimationName.showAfterLabelFromBotttom { /// afterLabel从下至上出现完成
            afterLabel.layer.position.y = afterLabelContainer.bounds.height * 0.5
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.zoomOutAfterLabelContainer()
                self.dismissAfterLabelToTop()
            }
        } else if let name = anim.value(forKey: "name") as? String, name == AnimationName.dismissAfterLabelToTop { /// afterLabel从中间至上消失完成
            afterLabel.layer.position.y = afterLabelContainer.bounds.height * 1.5
        }  else if let name = anim.value(forKey: "name") as? String, name == AnimationName.effectImageZoomIn { /// 效果图放大动画完成，
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.originImageViewShow()
            }
        }   else if let name = anim.value(forKey: "name") as? String, name == AnimationName.expandBeforeLabelContainer { /// beforeLabelContainer 展开
            showBeforeLabelFromBotttom()
        } else if let name = anim.value(forKey: "name") as? String, name == AnimationName.expandAfterLabelContainer { /// afterLabelContainer 展开
            showAfterLabelFromBotttom()
        } else if let name = anim.value(forKey: "name") as? String, name == AnimationName.originImageViewShow { /// 原图出现
            originImageZoomOut()
            effectImageZoomOut()
        }  else if let name = anim.value(forKey: "name") as? String, name == AnimationName.originImageZoomOut { /// 一轮完成
            if isRepeat {
                originImageViewSlashLeftToRight()
            } else {
                isAnimating = false
            }
        }
    }
    
}

