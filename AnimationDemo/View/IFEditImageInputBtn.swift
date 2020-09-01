//
//  IFEditImageInputBtn.swift
//  InFace
//
//  Created by lieon on 2020/6/30.
//  Copyright © 2020 Pinguo. All rights reserved.
//

import UIKit

class IFEditImageInputBtn: UIView {
    struct UISize {
        static let btnSize = CGSize(width: 77, height: 77)
    }
    var btnTapAction: (() -> Void)?
    fileprivate var waveCompeletion: (() -> Void)?
    fileprivate lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "home_wave")
        view.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)
        return view
    }()
    
    fileprivate lazy var mediumView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "home_wave")
        return view
    }()
    fileprivate lazy var shadow: IFShadowView = {
        let view = IFShadowView()
        view.shadowColor = UIColor(hex: 0xda53da)!.withAlphaComponent(0.3).cgColor
        view.shadowRadius = 12
        view.shadowOffset = CGSize(width: 0, height: 6)
        view.cornerRadius = UISize.btnSize.width * 0.5
        return view
    }()
    lazy var btn: IFGradientCustomBtn = {
        let btn = IFGradientCustomBtn()
        (btn.layer as? CAGradientLayer)?.startPoint = CGPoint(x: 0, y: 0.3)
        (btn.layer as? CAGradientLayer)?.endPoint = CGPoint(x: 1, y: 0.9)
        (btn.layer as? CAGradientLayer)?.colors = [UIColor(red: 255 / 255.0, green: 100 / 255.0, blue: 185 / 255.0, alpha: 1).cgColor, UIColor(red: 178 / 255.0, green: 130 / 255.0, blue: 255 / 255.0, alpha: 0.99).cgColor]
        btn.setImage(UIImage(named: "edit_imng_icon_add"), for: .normal)
        btn.setImage(UIImage(named: "edit_imng_icon_add"), for: .highlighted)
        (btn.layer as? CAGradientLayer)?.locations = [0.1, 1]
        btn.layer.cornerRadius = UISize.btnSize.width * 0.5
        btn.layer.masksToBounds = true
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(mediumView)
        addSubview(shadow)
        addSubview(btn)

        bgView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(UISize.btnSize)
        }
        
        btn.snp.makeConstraints {
            $0.center.equalTo(bgView.snp.center)
            $0.size.equalTo(UISize.btnSize)
        }
        shadow.snp.makeConstraints {
            $0.edges.equalTo(btn.snp.edges)
        }
        mediumView.snp.makeConstraints {
            $0.edges.equalTo(bgView.snp.edges)
        }

        btn.addTarget(self, action: #selector(self.tapBtnAction), for: .touchUpInside)
        btn.addTarget(self, action: #selector(self.tapBtnDownAction), for: .touchDown)
        btn.addTarget(self, action: #selector(self.tapBtnCancleAction), for: .touchCancel)
        btn.outTouchHandler = {[weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.tapBtnCancleAction()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
    


extension IFEditImageInputBtn {
    func showWaveAnimation(compeletion: (() -> Void)? = nil ) {
        self.waveCompeletion = compeletion
        
        let bgViewGroup = CAAnimationGroup()
        bgViewGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        bgViewGroup.fillMode = .forwards
        bgViewGroup.isRemovedOnCompletion = false
        bgViewGroup.delegate = self
        bgViewGroup.duration = 2
        bgViewGroup.setValue("bgViewGroup", forKey: "name")
        
        let bgViewScale = CAKeyframeAnimation(keyPath: "transform.scale")
        bgViewScale.values = [1.4, 2.8, 2]
        bgViewScale.delegate = self
        
        let bgViewOpacity = CAKeyframeAnimation(keyPath: "opacity")
        bgViewOpacity.values = [1, 0]
        
        bgViewGroup.animations = [bgViewScale, bgViewOpacity]
        bgView.layer.add(bgViewGroup, forKey: nil)
        
        let mediumViewGroup = CAAnimationGroup()
        mediumViewGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        mediumViewGroup.fillMode = .forwards
        mediumViewGroup.isRemovedOnCompletion = false
        mediumViewGroup.beginTime = CACurrentMediaTime() + 0.5
        mediumViewGroup.delegate = self
        mediumViewGroup.duration = 2
        mediumViewGroup.setValue("mediumViewGroup", forKey: "name")
        
        let mediumViewScale = CAKeyframeAnimation(keyPath: "transform.scale")
        mediumViewScale.values = [0, 2.5, 1.4]
        mediumViewScale.delegate = self
        
        let mediumViewOpacity = CAKeyframeAnimation(keyPath: "opacity")
//        mediumViewOpacity.values = [1, 0]
        
        mediumViewGroup.animations = [mediumViewScale, mediumViewOpacity]
        
        mediumView.layer.add(mediumViewGroup, forKey: nil)
    }
    
    func tapAnimation() {
       
    }
    
    fileprivate func tapBtnWave() {
        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        group.delegate = self
        group.duration = 1
        group.setValue("tapBtnWave", forKey: "name")
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0]
        let bgViewScale = CAKeyframeAnimation(keyPath: "transform.scale")
        bgViewScale.values = [1.4, 2]
        group.animations = [ opacity, bgViewScale]
        mediumView.layer.add(group, forKey: nil)
    }
    
    /// 按钮点击动画
    fileprivate func tapBtnScaleSmallLarage() {
        let btnScale = CAKeyframeAnimation(keyPath: "transform.scale")
        btnScale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        btnScale.fillMode = .forwards
        btnScale.isRemovedOnCompletion = false
        btnScale.delegate = self
        btnScale.duration = 0.25
        btnScale.setValue("tapBtnScaleSmallLarage", forKey: "name")
        btnScale.values = [1, 0.8, 1]
        btnScale.delegate = self
        btn.layer.add(btnScale, forKey: nil)
    }
    
    fileprivate func tapBtnScaleSmall() {
        let btnScale = CAKeyframeAnimation(keyPath: "transform.scale")
        btnScale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        btnScale.fillMode = .forwards
        btnScale.isRemovedOnCompletion = false
        btnScale.delegate = self
        btnScale.duration = 0.25
        btnScale.setValue("tapBtnScaleSmall", forKey: "name")
        btnScale.values = [1, 0.8]
        btnScale.delegate = self
        btn.layer.add(btnScale, forKey: nil)
    }
    
    fileprivate func mediumViewScaleSmall() {
        let btnScale = CAKeyframeAnimation(keyPath: "transform.scale")
        btnScale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        btnScale.fillMode = .forwards
        btnScale.isRemovedOnCompletion = false
        btnScale.delegate = self
        btnScale.duration = 0.25
        btnScale.setValue("mediumViewScaleSmall", forKey: "name")
        btnScale.values = [1.4, 1.2]
        btnScale.delegate = self
        mediumView.layer.add(btnScale, forKey: nil)
    }
    
    
    fileprivate func mediumViewScaleLarge() {
        let btnScale = CAKeyframeAnimation(keyPath: "transform.scale")
        btnScale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        btnScale.fillMode = .forwards
        btnScale.isRemovedOnCompletion = false
        btnScale.delegate = self
        btnScale.duration = 0.25
        btnScale.setValue("mediumViewScaleLarge", forKey: "name")
        btnScale.values = [1.2, 1.4]
        btnScale.delegate = self
        mediumView.layer.add(btnScale, forKey: nil)
    }
    
    fileprivate func tapBtnScaleLarage() {
        let btnScale = CAKeyframeAnimation(keyPath: "transform.scale")
        btnScale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        btnScale.fillMode = .forwards
        btnScale.isRemovedOnCompletion = false
        btnScale.delegate = self
        btnScale.duration = 0.25
        btnScale.setValue("tapBtnScaleLarage", forKey: "name")
        btnScale.values = [0.8, 1]
        btnScale.delegate = self
        btn.layer.add(btnScale, forKey: nil)
    }
    
    @objc
    fileprivate func tapBtnAction() {
         print("tapBtnAction-inside")
        tapBtnScaleLarage()
        mediumViewScaleLarge()
        
        btnTapAction?()
    }
    
    @objc
    fileprivate func tapBtnDownAction() {
        print("tapBtnDownAction")
        tapBtnScaleSmall()
        mediumViewScaleSmall()
        let impactFeedBack = UIImpactFeedbackGenerator()
        impactFeedBack.prepare()
        impactFeedBack.impactOccurred()
    }
    
    @objc
    fileprivate func tapBtnCancleAction() {
        print("tapBtnCancleAction")
        tapBtnScaleLarage()
        mediumViewScaleLarge()
    }
    
    
    
    @objc func logGesAction(_ ges: UILongPressGestureRecognizer) {
    
        switch ges.state {
        case .began:
            tapBtnScaleSmall()
            mediumViewScaleSmall()
            let impactFeedBack = UIImpactFeedbackGenerator()
            impactFeedBack.prepare()
            impactFeedBack.impactOccurred()
        case .changed:
            break
        case .ended:
            tapBtnScaleLarage()
            mediumViewScaleLarge()
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
//                self.tapBtnWave()
//            })
            btnTapAction?()
        default:
            break
        }
    }
    
}

extension IFEditImageInputBtn: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }
        if name == "mediumViewGroup" {
            waveCompeletion?()
        }
        if name == "tapBtnWave" {
           
        }
    }
}
