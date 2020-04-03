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
    fileprivate lazy var beforeText: NSMutableAttributedString = {
        let text = "before"
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 2
        shadow.shadowColor = UIColor.black
        let att = NSMutableAttributedString(string: text)
        att.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.7),
                           NSAttributedString.Key.shadow: shadow], range: NSRange(location: 0, length: text.count))
        return att
    }()
    fileprivate lazy var afterText: NSMutableAttributedString = {
        let text = "after"
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 2
        shadow.shadowColor = UIColor.black
        let att = NSMutableAttributedString(string: text)
        att.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.7),
                           NSAttributedString.Key.shadow: shadow], range: NSRange(location: 0, length: text.count))
        return att
    }()
    fileprivate lazy var beforeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    fileprivate lazy var afterLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    fileprivate var animationType: AnimationType = .easeInEaseOut
    fileprivate lazy var originImageView: UIImageView = {
        let originImageView = UIImageView()
        originImageView.image = UIImage(named: "meishi0")
        return originImageView
    }()
    fileprivate lazy var effectImageView: UIImageView = {
        let originImageView = UIImageView()
        originImageView.image = UIImage(named: "meishi1")
        return originImageView
    }()
    fileprivate var fontSize: CGFloat = 0
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
    fileprivate var isRepeat: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(originImageView)
        addSubview(effectImageView)
        addSubview(beforeLabel)
        addSubview(afterLabel)
        addSubview(sperateLine)
        reset()
        originImageView.snp.makeConstraints { $0.edges.equalTo(0)}
         effectImageView.snp.makeConstraints { $0.edges.equalTo(0)}
        beforeLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.size.equalTo(CGSize(width: 50, height: 20))
            $0.bottom.equalTo(-20)
        }
        afterLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.size.equalTo(CGSize(width: 50, height: 20))
            $0.bottom.equalTo(-20)
        }
        sperateLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(2)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    /// 配置图片
    public func config(_ originImage: UIImage, effectImage: UIImage) {
        effectImageView.image = effectImage
        originImageView.image = originImage
    }
    
    /// 开始动画
    public func startAnimation(with type: AnimationType, fontSize: CGFloat = 18) {
        animationType = type
        self.fontSize = fontSize
        reset()
        resetUI(fontSize)
        directStartAnimation()
    }
    
    
    /// 是否重复动画，在动画结束时判断是否继续动画
    /// - Parameter isRepeat: 是否重复播放
    public func shoulRepeatAniamtion(_ isRepeat: Bool = true) {
        self.isRepeat = isRepeat
    }
    
    public func prepareForReuse() {
        reset()
        originImageView.image = nil
        effectImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FXTutorialImageContrastView {
    fileprivate func directStartAnimation() {
        switch animationType {
        case .easeInEaseOut:
            effectImageViewEaseInEaseOut()
        case .leftToRightSlash:
            originImageViewSlashLeftToMedium()
        case .staticLeftRight:
            break
        case .staticTopBottom:
            break
        }
    }
    
    /// 效果图消失，before label出现， after label消失
    fileprivate func effectImageViewEaseInEaseOut() {
        if beforeLabel.layer.opacity != 0 {
            beforeLabel.layer.opacity = 0
            beforeLabel.layer.removeAllAnimations()
        }
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
        
        /// 显示 before label
        let labelopacity = CAKeyframeAnimation(keyPath: "opacity")
        labelopacity.values = [0, 1]
        labelopacity.beginTime = CACurrentMediaTime() + 1.5 + 0.5
        labelopacity.duration = 0.5
        labelopacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        labelopacity.delegate = self
        labelopacity.setValue("showLabel", forKey: "name")
        labelopacity.isRemovedOnCompletion = false
        labelopacity.fillMode = .forwards
        beforeLabel.layer.add(labelopacity, forKey: nil)
        
        /// 隐藏 after label
        if afterLabel.layer.opacity == 1 {
            let breforeLabelopacity = CAKeyframeAnimation(keyPath: "opacity")
            breforeLabelopacity.values = [1, 0]
            breforeLabelopacity.beginTime = CACurrentMediaTime() + 1 + 0.5
            breforeLabelopacity.duration = 0.5
            breforeLabelopacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            breforeLabelopacity.delegate = self
            breforeLabelopacity.setValue("showLabel", forKey: "name")
            breforeLabelopacity.isRemovedOnCompletion = false
            breforeLabelopacity.fillMode = .forwards
            afterLabel.layer.add(breforeLabelopacity, forKey: nil)
        }
    }
    
    /// 效果图出现 after label出现  before label消失
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
        
        /// 显示 after label
        let labelopacity = CAKeyframeAnimation(keyPath: "opacity")
        labelopacity.values = [0, 1]
        labelopacity.beginTime = CACurrentMediaTime() + 1 + 0.5
        labelopacity.duration = 0.5
        labelopacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        labelopacity.delegate = self
        labelopacity.setValue("showLabel", forKey: "name")
        labelopacity.isRemovedOnCompletion = false
        labelopacity.fillMode = .forwards
        afterLabel.layer.add(labelopacity, forKey: nil)
        
        /// 隐藏 before label
        let breforeLabelopacity = CAKeyframeAnimation(keyPath: "opacity")
        breforeLabelopacity.values = [1, 0]
        breforeLabelopacity.beginTime = CACurrentMediaTime() + 1 + 0.5
        breforeLabelopacity.duration = 0.5
        breforeLabelopacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        breforeLabelopacity.delegate = self
        breforeLabelopacity.setValue("showLabel", forKey: "name")
        breforeLabelopacity.isRemovedOnCompletion = false
        breforeLabelopacity.fillMode = .forwards
        beforeLabel.layer.add(breforeLabelopacity, forKey: nil)
        
    }
    
    /// 中间位置的斜线 /
    fileprivate func createMediumSlashPath() -> UIBezierPath {
        let path1 = UIBezierPath()
        path1.move(to: .zero)
        path1.addLine(to: CGPoint(x: bounds.width * 0.5 + 40, y: 0))
        path1.addLine(to: CGPoint(x: bounds.width * 0.5 + 40 - 40, y: bounds.height))
        path1.addLine(to: CGPoint(x: 0, y: bounds.height))
        path1.close()
        return path1
    }
    
    /// 起始位置的斜线 /
    fileprivate func createStartSlashPath() -> UIBezierPath {
        let path0 = UIBezierPath()
        path0.move(to: .zero)
        path0.addLine(to: CGPoint(x: 0, y: 0))
        path0.addLine(to: CGPoint(x: -40, y: bounds.height))
        path0.addLine(to: CGPoint(x: 0, y: bounds.height))
        path0.close()
        return path0
    }
    
    /// 斜线扫描：从左边到中间
    fileprivate func originImageViewSlashLeftToMedium() {
        bringSubviewToFront(effectImageView)
        bringSubviewToFront(originImageView)
        bringSubviewToFront(beforeLabel)
        bringSubviewToFront(afterLabel)
        let shape = CAShapeLayer()
        originImageView.layer.mask = shape
        let path0 = createStartSlashPath()
        let path1 = createMediumSlashPath()
        let firstPathAnimation = CAKeyframeAnimation(keyPath: "path")
        firstPathAnimation.values = [path0.cgPath, path1.cgPath]
        firstPathAnimation.beginTime = CACurrentMediaTime() + 1.5
        firstPathAnimation.duration = 1
        firstPathAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        firstPathAnimation.delegate = self
        firstPathAnimation.setValue("originImageViewSlashLeftToMedium", forKey: "name")
        firstPathAnimation.isRemovedOnCompletion = false
        firstPathAnimation.fillMode = .forwards
        shape.add(firstPathAnimation, forKey: nil)
        
        /// 显示label
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [0, 1]
        opacity.beginTime = CACurrentMediaTime() + 0.5 + 1.5
        opacity.duration = 0.5
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacity.delegate = self
        opacity.setValue("showLabel", forKey: "name")
        opacity.isRemovedOnCompletion = false
        opacity.fillMode = .forwards
        beforeLabel.layer.add(opacity, forKey: nil)
        afterLabel.layer.add(opacity, forKey: nil)
    }
    
     /// 斜线扫描：从中间到左边
    fileprivate func originImageViewSlashMediumToLeft() {
        bringSubviewToFront(effectImageView)
        bringSubviewToFront(originImageView)
        bringSubviewToFront(beforeLabel)
        bringSubviewToFront(afterLabel)
        let path0 = createStartSlashPath()
        let path1 = createMediumSlashPath()
        let pathAnimation = CAKeyframeAnimation(keyPath: "path")
        pathAnimation.values = [path1.cgPath, path0.cgPath]
        pathAnimation.beginTime = CACurrentMediaTime() + 1
        pathAnimation.duration = 1
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pathAnimation.delegate = self
        pathAnimation.setValue("originImageViewSlashMediumToLeft", forKey: "name")
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.fillMode = .forwards
        (originImageView.layer.mask as? CAShapeLayer)?.add(pathAnimation, forKey: nil)
        /// 隐藏label
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0]
        opacity.beginTime = CACurrentMediaTime() + 1
        opacity.duration = 0.5
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacity.delegate = self
        opacity.setValue("showLabel", forKey: "name")
        opacity.isRemovedOnCompletion = false
        opacity.fillMode = .forwards
        beforeLabel.layer.add(opacity, forKey: nil)
        afterLabel.layer.add(opacity, forKey: nil)
    }
    
    fileprivate func reset() {
        beforeLabel.layer.mask = nil
        beforeLabel.layer.opacity = 0
        afterLabel.layer.opacity = 0
        beforeLabel.layer.mask?.removeAllAnimations()
        beforeLabel.layer.removeAllAnimations()
        afterLabel.layer.mask?.removeAllAnimations()
        afterLabel.layer.removeAllAnimations()
        sperateLine.isHidden = true
        layer.removeAllAnimations()
        isRepeat = true
    }
    
    fileprivate func resetUI(_ fontSize: CGFloat) {
          beforeLabel.font = UIFont.customFont(ofSize: fontSize)
          afterLabel.font = UIFont.customFont(ofSize: fontSize)
          self.fontSize = fontSize
          let style = NSMutableParagraphStyle()
          style.alignment = .left
          style.lineSpacing = 0
          beforeText.addAttributes([NSAttributedString.Key.paragraphStyle: style,
                                    NSAttributedString.Key.font: UIFont.customFont(ofSize: fontSize, isBold: true)],
                                   range: NSRange(location: 0, length: beforeText.string.count))
          afterText.addAttributes([NSAttributedString.Key.font: UIFont.customFont(ofSize: fontSize, isBold: true),
                                   NSAttributedString.Key.paragraphStyle: style],
                                  range: NSRange(location: 0, length: afterText.string.count))
          let beforeSize = beforeText.boundingRect(with: CGSize(width: 100, height: CGFloat.infinity), options: [.usesLineFragmentOrigin], context: nil).size
          let afterSize = beforeText.boundingRect(with: CGSize(width: 100, height: CGFloat.infinity), options: [.usesLineFragmentOrigin], context: nil).size
          beforeLabel.attributedText = beforeText
          afterLabel.attributedText = afterText
          switch animationType {
          case .easeInEaseOut:
              beforeLabel.snp.remakeConstraints {
                  $0.left.equalTo(20)
                  $0.bottom.equalTo(-10)
                  $0.size.equalTo(beforeSize)
              }
              afterLabel.snp.remakeConstraints {
                  $0.left.equalTo(beforeLabel.snp.left)
                  $0.centerY.equalTo(beforeLabel.snp.centerY)
                  $0.size.equalTo(afterSize)
              }
              layoutIfNeeded()
          case .leftToRightSlash:
              beforeLabel.snp.remakeConstraints {
                  $0.left.equalTo(20)
                  $0.bottom.equalTo(-10)
                  $0.size.equalTo(beforeSize)
              }
              afterLabel.snp.remakeConstraints {
                  $0.right.equalTo(-20)
                  $0.centerY.equalTo(beforeLabel.snp.centerY)
                  $0.size.equalTo(afterSize)
              }
              layoutIfNeeded()
          case .staticLeftRight:
              (sperateLine.layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 0.0)
              (sperateLine.layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 1)
              beforeLabel.layer.opacity = 1
              afterLabel.layer.opacity = 1
              sperateLine.isHidden = false
              bringSubviewToFront(effectImageView)
              bringSubviewToFront(originImageView)
              bringSubviewToFront(beforeLabel)
              bringSubviewToFront(afterLabel)
              bringSubviewToFront(sperateLine)
              sperateLine.snp.remakeConstraints {
                  $0.centerX.equalToSuperview()
                  $0.width.equalTo(2)
                  $0.top.equalTo(0)
                  $0.bottom.equalTo(0)
              }
              effectImageView.snp.remakeConstraints {
                  $0.left.top.bottom.equalToSuperview()
                  $0.right.equalTo(snp.centerX)
              }
              originImageView.snp.remakeConstraints {
                  $0.right.top.bottom.equalToSuperview()
                  $0.left.equalTo(snp.centerX)
              }
              beforeLabel.snp.remakeConstraints {
                  $0.left.equalTo(20)
                  $0.bottom.equalTo(-10)
                  $0.size.equalTo(beforeSize)
              }
              afterLabel.snp.remakeConstraints {
                  $0.right.equalTo(-5)
                  $0.centerY.equalTo(beforeLabel.snp.centerY)
                  $0.size.equalTo(afterSize)
              }
              layoutIfNeeded()
          case .staticTopBottom:
              (sperateLine.layer as! CAGradientLayer).startPoint = CGPoint(x: 0, y: 0.5)
              (sperateLine.layer as! CAGradientLayer).endPoint = CGPoint(x: 1, y: 0.5)
              beforeLabel.layer.opacity = 1
              afterLabel.layer.opacity = 1
              sperateLine.isHidden = false
              bringSubviewToFront(effectImageView)
              bringSubviewToFront(originImageView)
              bringSubviewToFront(beforeLabel)
              bringSubviewToFront(afterLabel)
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
              beforeLabel.snp.remakeConstraints {
                  $0.left.equalTo(20)
                  $0.top.equalTo(10)
                  $0.size.equalTo(beforeSize)
              }
              afterLabel.snp.remakeConstraints {
                  $0.left.equalTo(20)
                  $0.bottom.equalTo(-10)
                  $0.size.equalTo(afterSize)
              }
              layoutIfNeeded()
          }
      }
    
    
}

extension FXTutorialImageContrastView: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        guard !isRepeat else {
            return
        }
        if let name = anim.value(forKey: "name") as? String, name == "originImageViewSlashLeftToMedium" {
            print("animationDidStart - effectImageViewEaseInEaseOut - isRepeat :\(isRepeat)")
            effectImageView.layer.removeAllAnimations()
            originImageView.layer.mask?.removeAllAnimations()
            originImageView.layer.mask = nil
            effectImageView.layer.opacity = 1
            bringSubviewToFront(effectImageView)
        } else   if let name = anim.value(forKey: "name") as? String, name == "effectImageViewEaseInEaseOutShow" {
            print("animationDidStart - effectImageViewEaseInEaseOutShow - isRepeat :\(isRepeat)")
            bringSubviewToFront(effectImageView)
            let opacity = CAKeyframeAnimation(keyPath: "opacity")
            opacity.values = [0, 1]
            opacity.duration = 1
            opacity.duration = 0.25
            opacity.fillMode = .forwards
            opacity.isRemovedOnCompletion = false
            opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            effectImageView.layer.add(opacity, forKey: nil)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag == true else {
            return
        }
        if let name = anim.value(forKey: "name") as? String, name == "originImageViewSlashLeftToMedium" { /// 从左边到中间扫描结束
            (originImageView.layer.mask as? CAShapeLayer)?.path = createMediumSlashPath().cgPath
            afterLabel.layer.opacity = 1
            beforeLabel.layer.opacity = 1
            originImageViewSlashMediumToLeft()
        } else if let name = anim.value(forKey: "name") as? String, name == "originImageViewSlashMediumToLeft" { /// 从中间到左边扫描结束， leftToRightSlash 这一轮动画结束
            effectImageView.layer.removeAllAnimations()
            originImageView.layer.mask?.removeAllAnimations()
            originImageView.layer.mask = nil
            if isRepeat {
                originImageViewSlashLeftToMedium()
            } else {
                bringSubviewToFront(effectImageView)
            }
        }  else if let name = anim.value(forKey: "name") as? String, name == "effectImageViewEaseInEaseOut" { /// EaseInEaseOut 这一轮动画结束
            effectImageView.layer.opacity = 0
            beforeLabel.layer.opacity = 1
            afterLabel.layer.opacity = 0
            effectImageViewEaseInEaseOutShow()
        } else if let name = anim.value(forKey: "name") as? String, name == "effectImageViewEaseInEaseOutShow" { /// EaseInEaseOut 进行到一半
            effectImageView.layer.opacity = 1
            beforeLabel.layer.opacity = 0
            if isRepeat {
                afterLabel.layer.opacity = 1
                bringSubviewToFront(afterLabel)
                effectImageViewEaseInEaseOut()
            } else {
                let labelopacity = CAKeyframeAnimation(keyPath: "opacity")
                labelopacity.values = [1, 0]
                labelopacity.duration = 0.25
                labelopacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                labelopacity.isRemovedOnCompletion = false
                labelopacity.fillMode = .forwards
                afterLabel.layer.add(labelopacity, forKey: nil)
            }
        } else if let name = anim.value(forKey: "name") as? String, name == "stopAnimation" {
            layer.opacity = 0
            reset()
        }  else if let name = anim.value(forKey: "name") as? String, name == "startAniamtion" {
            layer.opacity = 1
            directStartAnimation()
        }
    }
    
}
