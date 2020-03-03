//
//  HookViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/3.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HookViewController: UIViewController {
    fileprivate lazy var stepView: FXTutorialStepView = {
        let stepView = FXTutorialStepView()
        return stepView
    }()
    let bag = DisposeBag()
    
    fileprivate lazy var slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.setValue(0, animated: false)
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(stepView)
        stepView.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.size.equalTo(CGSize(width: 200, height: 70))
        }
        
        view.addSubview(slider)
        slider.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(stepView.snp.bottom).offset(50)
            $0.width.equalTo(200)
        }
        slider.rx.value
            .asObservable()
            .subscribe(onNext: {
                self.stepView.update(CGFloat($0))
            })
        .disposed(by: bag)
    }
}

class FXTutorialStepNumView: UIView {
    fileprivate lazy var progressLayer: CAShapeLayer = {
        let progressLayer = CAShapeLayer()
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.lineWidth = 10
        progressLayer.lineCap = .round
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0.5
        return progressLayer
    }()
    
    fileprivate var animationEnd: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        progressLayer.frame = layer.bounds
        let cyclePath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width * 0.5).cgPath
        progressLayer.path = cyclePath
    }
    
    /// progress为1时，动画完成会回调
    func update(_ progress: CGFloat, compeletion: (() -> ())? = nil) {
        progressLayer.strokeEnd = progress
        if progress >= 1 {
            let lineWidth = CABasicAnimation(keyPath: "lineWidth")
            lineWidth.fromValue = 10
            lineWidth.toValue = 5
            lineWidth.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            lineWidth.fillMode = .forwards
            lineWidth.setValue("lineWidth", forKey: "name")
            lineWidth.duration = 0.25
            lineWidth.delegate = self
            progressLayer.add(lineWidth, forKey: nil)
            progressLayer.lineWidth = 3
        }
        self.animationEnd = compeletion
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FXTutorialStepNumView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let lineWidth = anim.value(forKey: "name") as? String, lineWidth == "lineWidth" {
            animationEnd?()
        }
    }
}

class FXTutorialNextStepView: UIView {
    fileprivate lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("下一步", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    fileprivate lazy var progressLayer: CAShapeLayer = {
        let progressLayer = CAShapeLayer()
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 5
        progressLayer.lineCap = .round
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 1
        progressLayer.opacity = 0
        return progressLayer
    }()
    
    fileprivate lazy var scaleView: UIView = {
        let scaleView = UIView()
        scaleView.backgroundColor = .red
        scaleView.layer.cornerRadius = 50 * 0.5
        scaleView.layer.masksToBounds = true
        scaleView.alpha = 0
        scaleView.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
        return scaleView
    }()
    fileprivate var isNeedLayout: Bool = true
    
    fileprivate var animationEnd: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scaleView)
        layer.addSublayer(progressLayer)
        addSubview(nextBtn)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isNeedLayout {
            scaleView.frame = CGRect(x: bounds.width - 50, y: 0, width: 50, height: 50)
            nextBtn.frame = CGRect(x: bounds.width - 70 - 25, y: 0, width: 70, height: 40)
            
        }
       
        print("layoutSubviews")
      
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if isNeedLayout {
            progressLayer.frame = CGRect(x: bounds.width - 50, y: 0, width: 50, height: 50)
            let hookPath = UIBezierPath()
            hookPath.move(to: CGPoint(x: 25, y: 0))
            hookPath.addCurve(to: CGPoint(x: 12, y: 11), controlPoint1: CGPoint(x: 25, y: 0), controlPoint2: CGPoint(x: 15.25, y: 5))
            hookPath.addCurve(to: CGPoint(x: 12, y: 24), controlPoint1: CGPoint(x: 8.75, y: 17), controlPoint2: CGPoint(x: 12, y: 24))
            hookPath.addLine(to: CGPoint(x: 21, y: 32))
            hookPath.addLine(to: CGPoint(x: 33, y: 20))
            progressLayer.path = hookPath.cgPath
        }
      
    }
    
    func showAnimation() {
        /// 出现
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scaleView.alpha = 1
        scale.fromValue = 0.5
        scale.toValue = 1
        scale.fillMode = .backwards
        scale.duration = 3
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.setValue("scaleAnimation", forKey: "name")
        scale.delegate = self
        scaleView.layer.add(scale, forKey: nil)
        scaleView.layer.transform = CATransform3DMakeScale(1, 1, 1)
    }
    
    func startHookAnimation() {
        progressLayer.opacity = 1
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 0.4
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.5
        strokeAnimationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        strokeAnimationGroup.delegate = self
        strokeAnimationGroup.setValue("hookAnimation", forKey: "name")
        progressLayer.add(strokeAnimationGroup, forKey: nil)
        progressLayer.strokeStart = 0.5
        progressLayer.strokeEnd = 1
    }
    
    func boundsAnimation() {
        let scaleViewboundsAni = CABasicAnimation(keyPath: "bounds")
        scaleViewboundsAni.fromValue = self.scaleView.bounds
        scaleViewboundsAni.toValue = self.bounds
        scaleViewboundsAni.duration = 2
        scaleViewboundsAni.fillMode = .forwards
        scaleViewboundsAni.isRemovedOnCompletion = false
        scaleViewboundsAni.delegate = self
        scaleViewboundsAni.setValue("boundsAnimation", forKey: "name")
        scaleViewboundsAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        isNeedLayout = false
        print(scaleView.frame)
        scaleView.setAnchorPoint(CGPoint(x: 1, y: 0.5))
         print(scaleView.frame)
        scaleView.layer.add(scaleViewboundsAni, forKey: nil)
        let hookViewPosition = CABasicAnimation(keyPath: "position.x")
        hookViewPosition.fromValue = bounds.width - 50 * 0.5
        hookViewPosition.toValue = 25
        hookViewPosition.fillMode = .forwards
        hookViewPosition.isRemovedOnCompletion = false
        hookViewPosition.duration = 2
        hookViewPosition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressLayer.add(hookViewPosition, forKey: nil)
    }
    
    func showNextbtn() {
        let btnPositionY = CABasicAnimation(keyPath: "position.y")
        btnPositionY.fromValue = bounds.height * 1.5
        btnPositionY.toValue = bounds.height * 0.5
        btnPositionY.duration = 2
        btnPositionY.fillMode = .backwards
        btnPositionY.isRemovedOnCompletion = false
        nextBtn.layer.add(btnPositionY, forKey: nil)
        nextBtn.layer.position.y = bounds.height * 0.5
    }
}

extension FXTutorialNextStepView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag == true else {
            return
        }
        if let name = anim.value(forKey: "name") as? String?, name == "scaleAnimation" {
            startHookAnimation()
        } else if let name = anim.value(forKey: "name") as? String?, name == "hookAnimation" {
            boundsAnimation()
        } else if let name = anim.value(forKey: "name") as? String?, name == "boundsAnimation" {
            showNextbtn()
        }
    }
}

class FXTutorialStepView: UIView {
    fileprivate lazy var stepNumberView: FXTutorialStepNumView = {
        let view = FXTutorialStepNumView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = UISize.cycleSize.width * 0.5
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var nextStepView: FXTutorialNextStepView = {
        let view = FXTutorialNextStepView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    
    struct UISize {
        static let cycleSize: CGSize = CGSize(width: 50, height: 50)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stepNumberView)
        addSubview(nextStepView)
        nextStepView.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.height.equalTo(UISize.cycleSize.height)
            $0.width.equalToSuperview()
            $0.right.equalTo(snp.right)
        }
        stepNumberView.snp.makeConstraints {
            $0.right.equalTo(snp.right)
            $0.centerY.equalTo(snp.centerY)
            $0.size.equalTo(UISize.cycleSize)
        }
    }
  
    
    func update(_ progress: CGFloat) {
        stepNumberView.update(progress, compeletion: {
            self.nextStepView.showAnimation()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
