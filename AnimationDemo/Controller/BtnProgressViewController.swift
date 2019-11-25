//
//  BtnProgressViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class BtnProgressViewController: UIViewController {
    var progressView: FXTutorialProgressView!
    @IBOutlet weak var animateView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        animateView.backgroundColor = .white
        progressView = FXTutorialProgressView(frame: CGRect(x: 20, y: animateView.center.y - 50, width: view.bounds.width - 40, height: 100))
        animateView.addSubview(progressView)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    @IBAction func sliderProgreeAction(_ sender: UISlider) {
        progressView.setProgress(CGFloat(sender.value))
    }
}


class FXTutorialProgressView: UIView {
    struct UISize {
        static let borderWidth: CGFloat = 2
        static let innerInset: CGFloat = borderWidth + 1
        static let innerBorderWidth: CGFloat = innerInset
        static let progressLinWidth: CGFloat = 10
        static let progressViewContainerSize: CGSize = CGSize(width: 100, height: 100)
    }
    fileprivate lazy var progressViewContainer: UIView = {
        let progressViewContainer = UIView()
        progressViewContainer.backgroundColor = .red
        return progressViewContainer
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }()
    
    fileprivate lazy var progressLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.orange.cgColor
        maskLayer.lineWidth = UISize.progressLinWidth
        maskLayer.strokeColor = UIColor.cyan.cgColor
        return maskLayer
    }()
    
    fileprivate lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    var innerLayer: CALayer?
    lazy var startBtn: UIButton = {
        let btn = UIButton(type: .custom)
//        btn.gradientColors = [UIColor(hex: 0x7ad3ff)!, UIColor(hex: 0xff41d3)!]
//        btn.backgroundColor = UIColor(hex: 0xff41d3)
        btn.setTitle("开始", for: .normal)
//        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        progressViewContainer.frame = CGRect(x: frame.width * 0.5 - UISize.progressViewContainerSize.width * 0.5,
                                             y: frame.height * 0.5 - UISize.progressViewContainerSize.height * 0.5,
                                             width: UISize.progressViewContainerSize.width,
                                             height: UISize.progressViewContainerSize.height)
        progressViewContainer.layer.masksToBounds = true
        progressViewContainer.layer.cornerRadius = UISize.progressViewContainerSize.height * 0.5
        addSubview(progressViewContainer)
        gradientLayer.frame = progressViewContainer.bounds
        progressViewContainer.layer.addSublayer(gradientLayer)
        
        let maskBounds = gradientLayer.bounds.insetBy(dx: UISize.borderWidth, dy: UISize.borderWidth)
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.frame = maskBounds
        maskLayer.cornerRadius = maskBounds.width * 0.5
        maskLayer.masksToBounds = true
        progressViewContainer.layer.addSublayer(maskLayer)
        
        let innerLayer = CALayer()
        let innerFrame = CGRect(x: 0, y: 0,
                                width: progressViewContainer.bounds.width,
                                height: progressViewContainer.bounds.height)
            .insetBy(dx: UISize.borderWidth + UISize.innerInset, dy: UISize.borderWidth + UISize.innerInset)
        innerLayer.frame = innerFrame
        innerLayer.cornerRadius = innerFrame.width * 0.5
        innerLayer.masksToBounds = true
        progressViewContainer.layer.addSublayer(innerLayer)
        let innerGradientLayer = createGrdientLayer()
        innerGradientLayer.frame = innerLayer.bounds
        innerLayer.addSublayer(innerGradientLayer)
        
        let contentBounds = CGRect(x: UISize.borderWidth + UISize.innerInset + UISize.progressLinWidth * 0.4,
                                   y: UISize.borderWidth + UISize.innerInset +  UISize.progressLinWidth * 0.4,
                                   width: progressViewContainer.bounds.width - (UISize.borderWidth + UISize.innerInset + UISize.progressLinWidth * 0.4) * 2 ,
                                   height: progressViewContainer.bounds.height - (UISize.borderWidth + UISize.innerInset + UISize.progressLinWidth * 0.4) * 2)
        contentView.frame = contentBounds
        contentView.layer.cornerRadius = contentBounds.width * 0.5
        contentView.layer.masksToBounds = true
        progressViewContainer.addSubview(contentView)
        self.innerLayer = innerLayer
        
        let pathFrame = CGRect(x: 5, y: 5, width: innerFrame.width - 10, height: innerFrame.height - 10 )
        let path = UIBezierPath(roundedRect: pathFrame,
                                cornerRadius: pathFrame.height * 0.5)
        
        progressLayer.path = path.cgPath
        innerLayer.mask = progressLayer
        progressLayer.strokeEnd = 0.7
        titleLabel.frame = contentView.bounds
        contentView.addSubview(titleLabel)
        startBtn.frame = progressViewContainer.frame
        startBtn.layer.cornerRadius = innerFrame.width * 0.5
        startBtn.layer.masksToBounds = true
        addSubview(startBtn)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func createGrdientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        //        gradientLayer.locations = [0, 0.16, 0.4, 0.5, 0.61, 0.83, 1]
        return gradientLayer
    }
    
    func setProgress(_ progress: CGFloat) {
        progressLayer.strokeEnd = progress
        let percentTitle = NSMutableAttributedString(string: "%")
        let numberTitle = NSMutableAttributedString(string: "\(Int(progress * 100))")
        if progress >= 1 {
            contentView.backgroundColor = UIColor.clear
            percentTitle.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12),
                                        NSAttributedString.Key.foregroundColor : UIColor(hex: 0xffffff)!],
                                       range: NSRange(location: 0, length: 1))
            numberTitle.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                                       NSAttributedString.Key.foregroundColor : UIColor(hex: 0xffffff)!],
                                      range: NSRange(location: 0, length: numberTitle.string.count))
            let scaleAniamtion = CABasicAnimation(keyPath: "transform.scale")
            scaleAniamtion.fromValue = 1
            scaleAniamtion.toValue = 1.5
            scaleAniamtion.duration = 1
            scaleAniamtion.fillMode = .both
            scaleAniamtion.isRemovedOnCompletion = false
            scaleAniamtion.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            innerLayer?.add(scaleAniamtion, forKey: nil)
            
            scaleAniamtion.toValue = 1.2
            titleLabel.layer.add(scaleAniamtion, forKey: nil)
            
            let scaleGroup = CAAnimationGroup()
            scaleGroup.fillMode = .both
            scaleGroup.duration = 1
            scaleGroup.beginTime = CACurrentMediaTime() + 1
            scaleGroup.isRemovedOnCompletion = false
            scaleGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            let scaleX = CABasicAnimation(keyPath: "transform.scale.x")
            scaleX.toValue = 0.8
            scaleGroup.animations = [scaleX]
            progressViewContainer.layer.add(scaleGroup, forKey: nil)
            
            let opacity = CABasicAnimation(keyPath: "opacity")
            opacity.toValue = 0
            scaleGroup.animations = [opacity]
            scaleGroup.delegate = self
            scaleGroup.setValue(titleLabel.layer, forKey: "layer")
            titleLabel.layer.add(scaleGroup, forKey: nil)
        } else {
            startBtn.layer.opacity = 0
            progressViewContainer.layer.removeAllAnimations()
            titleLabel.layer.removeAllAnimations()
            innerLayer?.removeAllAnimations()
            contentView.backgroundColor = UIColor.white
            percentTitle.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12),
                                        NSAttributedString.Key.foregroundColor : UIColor(hex: 0xe261e0)!],
                                       range: NSRange(location: 0, length: 1))
            numberTitle.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                                       NSAttributedString.Key.foregroundColor : UIColor(hex: 0xe261e0)!],
                                      range: NSRange(location: 0, length: numberTitle.string.count))
        }
        let allText = NSMutableAttributedString()
        allText.append(numberTitle)
        allText.append(NSAttributedString(string: " "))
        allText.append(percentTitle)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        allText.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: NSRange(location: 0, length: allText.string.count))
        titleLabel.attributedText = allText
    }
}

extension FXTutorialProgressView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else {
            return
        }
        if let layer = anim.value(forKey: "layer") as? CALayer, layer == titleLabel.layer { // label动画显示完毕
           
        }
    }
}


