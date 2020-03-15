//
//  FXTutorialManulVideoIcon.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/3/12.
//

import Foundation
import UIKit

class FXTutorialManulVideoIcon: UIView {
    struct UISize {
        static let iconSize: CGSize = CGSize(width: 44.fitiPhone5sSerires, height: 44.fitiPhone5sSerires)
    }
    var cllickAction: (() -> ())?
    var showSuccessHandler: (() -> ())?
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(hex: 0xf65685)
        label.font = UIFont.customFont(ofSize: 8)
        label.layer.cornerRadius = 8.8.fitiPhone5sSerires
        label.text = "讲解"
        label.textAlignment = .center
        label.textColor = .white
        label.layer.masksToBounds = true
        return label
    }()
    fileprivate lazy var imageView: UIButton = {
        let imageView = UIButton()
        imageView.backgroundColor = UIColor.yellow
        imageView.layer.cornerRadius = UISize.iconSize.width * 0.5
        imageView.layer.masksToBounds = true
        imageView.setImage(UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_author_yls@3x")), for: .normal)
        return imageView
    }()
    fileprivate lazy var container: UIView = {
        let container = UIView()
        container.layer.cornerRadius = UISize.iconSize.width * 0.5
        container.layer.masksToBounds = true
        return container
    }()
    fileprivate lazy var cycleLayer: CAShapeLayer = {
        let cycleLayer = CAShapeLayer()
        cycleLayer.strokeColor = UIColor(hex: 0xf65685)?.cgColor
        cycleLayer.lineWidth = 4
        cycleLayer.fillColor = UIColor.clear.cgColor
        return cycleLayer
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(cycleLayer)
        addSubview(container)
        container.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(UISize.iconSize)
        }
        imageView.addTarget(self, action: #selector(iconAction), for: .touchUpInside)
        container.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        container.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top)
            $0.centerX.equalTo(imageView.snp.centerX)
            $0.size.equalTo(CGSize(width: 44.fitiPhone5sSerires, height: 20.fitiPhone5sSerires))
        }
        
        reset()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        cycleLayer.frame = CGRect(x: (bounds.width - container.bounds.width) * 0.5, y: (bounds.height - container.bounds.height) * 0.5, width: container.bounds.width, height: container.bounds.height)
        let path = UIBezierPath(roundedRect: container.bounds, cornerRadius: container.bounds.width * 0.5)
        cycleLayer.path = path.cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FXTutorialManulVideoIcon {
    func show(_ iconURLStr: String?, isShowBreath: Bool = false) {
        alpha = 1
        if isShowBreath {
            showBreathAnimation()
        } else {
            showIconAnimaton()
        }
    }
    
    func dismiss() {
        dismissAnimation()
    }
}

extension FXTutorialManulVideoIcon {
    
    @objc
    fileprivate func iconAction() {
        cllickAction?()
    }
    
    fileprivate func showBreathAnimation() {
        /// 出现
        container.layer.opacity = 1
        let containerScale = CAKeyframeAnimation(keyPath: "transform.scale")
        containerScale.values = [0, 1.5, 1, 0.8, 1] // [1, 0.8, 1]
        containerScale.calculationMode = .linear
        containerScale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        containerScale.duration = 1
        containerScale.delegate = self
        containerScale.fillMode = .forwards
        containerScale.isRemovedOnCompletion = false
        containerScale.setValue("showIconSuccess", forKey: "name")
        container.layer.add(containerScale, forKey: nil)
        
        /// 开始,同时展示
        return;
        cycleLayer.opacity = 1
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1, 1.5, 1, 1.2, 1.5 ]
        scale.calculationMode = .linear
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.duration = 1

        let lineWidth = CAKeyframeAnimation(keyPath: "lineWidth")
        lineWidth.values = [3, 0]
        lineWidth.calculationMode = .linear
        lineWidth.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        lineWidth.duration = 1
        
        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime() + 0.1
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.duration = 1
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        group.delegate = self
        group.setValue("showBreathAnimation", forKey: "name")
        group.animations = [scale, lineWidth]
        cycleLayer.add(group, forKey: nil)
    }
    
    fileprivate func showIconAnimaton() {
        container.layer.opacity = 1
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [0, 1, 1.5, 1, 0.8, 1]
        scale.calculationMode = .linear
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.duration = 0.5
        scale.delegate = self
        scale.fillMode = .forwards
        scale.isRemovedOnCompletion = false
        scale.setValue("showIconAnimaton", forKey: "name")
        container.layer.add(scale, forKey: nil)
    }
    
    fileprivate func dismissAnimation() {
        cycleLayer.opacity = 0
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1, 1.5, 1, 0]
        scale.calculationMode = .linear
        scale.keyTimes = [0, 0.8, 1.2, 1.5]
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.duration = 1.5
        scale.delegate = self
        scale.fillMode = .forwards
        scale.setValue("dismissAnimation", forKey: "name")
        container.layer.add(scale, forKey: nil)
    }
    
    fileprivate func reset() {
        isUserInteractionEnabled = false
        alpha = 0
        container.layer.transform = CATransform3DMakeScale(0, 0, 0)
        cycleLayer.opacity = 0
        cycleLayer.lineWidth = 3
    }
}

extension FXTutorialManulVideoIcon: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag == true else {
            return
        }
        if let name = anim.value(forKey: "name") as? String, name == "showBreathAnimation" {
            cycleLayer.opacity = 0
        } else if let name = anim.value(forKey: "name") as? String, name == "showIconAnimaton" {
            isUserInteractionEnabled = true
            container.layer.transform = CATransform3DMakeScale(1, 1, 1)
            showSuccessHandler?()
        } else if let name = anim.value(forKey: "name") as? String, name == "dismissAnimation" {
            reset()//
        } else if let name = anim.value(forKey: "name") as? String, name == "showIconSuccess" {
            
        }
    }
}
