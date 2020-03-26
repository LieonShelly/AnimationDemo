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
        static let lineWidth: CGFloat = 1
        static let lineMaxWidth: CGFloat = 2
    }
    var cllickAction: (() -> ())?
    var showSuccessHandler: (() -> ())?

    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(hex: 0xD470E1)
        label.font = UIFont.customFont(ofSize: 8)
        label.layer.cornerRadius = 15.fitiPhone5sSerires
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
//        imageView.setImage(UIImage(named: "test"), for: .normal)
        imageView.setImage(UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_author_yls@3x")), for: .normal)
        return imageView
    }()
    fileprivate lazy var container: UIView = {
        let container = UIView()
        container.layer.cornerRadius = UISize.iconSize.width * 0.5
        container.layer.masksToBounds = true
        return container
    }()
    fileprivate lazy var cycleLayer0: CAShapeLayer = {
        let cycleLayer = CAShapeLayer()
        cycleLayer.strokeColor = UIColor(hex: 0xD470E1)?.cgColor
        cycleLayer.lineWidth = UISize.lineWidth
        cycleLayer.fillColor = UIColor.clear.cgColor
        return cycleLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(cycleLayer0)
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
            $0.size.equalTo(CGSize(width: 36.fitiPhone5sSerires, height: 12.fitiPhone5sSerires))
        }
        reset()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let pathRect = CGRect(x: (bounds.width - container.bounds.width - UISize.lineWidth * 0.5) * 0.5, y: (bounds.height - container.bounds.height - UISize.lineWidth * 0.5) * 0.5, width: container.bounds.width + UISize.lineWidth * 1, height: container.bounds.height + UISize.lineWidth * 1)
        cycleLayer0.frame = pathRect
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: pathRect.width * 0.5)
        cycleLayer0.path = path.cgPath
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FXTutorialManulVideoIcon {
    func config(_ iconURLStr: String?) {
        
    }
    func show() {
        alpha = 1
        showIconAnimaton()
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
    
    fileprivate func iconShowRloop() {
        container.layer.opacity = 1
        let containerScale = CAKeyframeAnimation(keyPath: "transform.scale")
        containerScale.values = [1, 0.8]
        containerScale.calculationMode = .linear
        containerScale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        containerScale.duration = 0.5
        containerScale.delegate = self
        containerScale.repeatCount = .infinity
        containerScale.fillMode = .forwards
        containerScale.isRemovedOnCompletion = false
        containerScale.setValue("iconShowRoolp", forKey: "name")
        containerScale.autoreverses = true
        container.layer.add(containerScale, forKey: nil)
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0.5]
        opacity.calculationMode = .linear
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacity.duration = 0.5
        opacity.delegate = self
        opacity.repeatCount = .infinity
        opacity.fillMode = .forwards
        opacity.isRemovedOnCompletion = false
        opacity.rotationMode = .rotateAutoReverse
        opacity.autoreverses = true

        let lineWidth = CAKeyframeAnimation(keyPath: "lineWidth")
        lineWidth.values = [UISize.lineWidth, UISize.lineMaxWidth]
        lineWidth.calculationMode = .linear
        lineWidth.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime()
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.duration = 0.5
        group.fillMode = .forwards
        group.repeatCount = .infinity
        group.isRemovedOnCompletion = false
        group.delegate = self
        group.autoreverses = true
        group.animations = [opacity, lineWidth]
        cycleLayer0.add(group, forKey: nil)
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
    
     func dismissAnimation() {
        cycleLayer0.removeAllAnimations()
        cycleLayer0.opacity = 0
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1, 1.5, 1, 0]
        scale.calculationMode = .linear
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.duration = 0.5
        scale.delegate = self
        scale.fillMode = .forwards
        scale.setValue("dismissAnimation", forKey: "name")
        container.layer.add(scale, forKey: nil)
    }
    
    fileprivate func reset() {
        isUserInteractionEnabled = false
        alpha = 0
        cycleLayer0.opacity = 0
        cycleLayer0.lineWidth = UISize.lineWidth
        cycleLayer0.removeAllAnimations()
        container.layer.removeAllAnimations()
    }
}

extension FXTutorialManulVideoIcon: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag == true else {
            return
        }
        if let name = anim.value(forKey: "name") as? String, name == "showIconAnimaton" {
            isUserInteractionEnabled = true
            showSuccessHandler?()
            iconShowRloop()
        } else if let name = anim.value(forKey: "name") as? String, name == "dismissAnimation" {
            reset()
        }
    }
}
