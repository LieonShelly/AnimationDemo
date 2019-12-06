//
//  BtnProgressViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class BtnProgressViewController: UIViewController {
    @IBOutlet weak var imageVIew: UIImageView!
    
    var progressView: FXTutorialProgressView!
    @IBOutlet weak var animateView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        animateView.backgroundColor = .white
        progressView = FXTutorialProgressView(frame: CGRect(x: 20, y: animateView.center.y - 50, width: view.bounds.width - 40, height: 80))
        animateView.addSubview(progressView)
        let ges = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        ges.scale = 10
        view.addGestureRecognizer(ges)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageVIew.contentMode = .center
        var images: [UIImage] = []
        for index in (52 ... 126) {
            let name = String(format: "%03d", index)
//            let path = Bundle.main.path(forResource: "开始_\(name).png", ofType: nil)
//            let image = UIImage(contentsOfFile: path!)
            let image = UIImage(named: "开始_\(name).png")
            images.append(image!)
        }
        imageVIew.animationDuration = 2
        imageVIew.animationImages = images
        imageVIew.animationRepeatCount = 1
        imageVIew.startAnimating()
    }
    
    @IBAction func sliderProgreeAction(_ sender: UISlider) {
        progressView.setProgress(CGFloat(sender.value))
    }
    
    @objc
    fileprivate func pinchAction(_ ges: UIPinchGestureRecognizer) {
        switch ges.state {
        case .began:
            break
        case .changed:
            break
        case .ended:
            break
        default:
            break
        }
    }
}


class FXTutorialProgressView: UIView {
    struct UISize {
        static let borderWidth: CGFloat = 2
        static let innerInset: CGFloat = borderWidth + 1
        static let innerBorderWidth: CGFloat = innerInset
        static let progressLinWidth: CGFloat = 10
        static let progressViewContainerSize: CGSize = CGSize(width: 46, height: 46)
    }
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        return imageView
    }()
    fileprivate lazy var progressViewContainer: UIView = {
        let progressViewContainer = UIView()
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
    fileprivate var startBtn: GradientButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            for btn in progressViewContainer.subviews {
                if btn.tag == 100 {
                    btn.removeFromSuperview()
                }
            }
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
    /*
     正常加载
     加载失败，点击重试
     准备中
     **/
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else {
            return
        }
        if let layer = anim.value(forKey: "layer") as? CALayer, layer == titleLabel.layer { // label动画显示完毕
            progressViewContainer.frame = bounds
            let btn = GradientButton(button: .custom,
                                    showBottom: .gradient,
                                    corner: 10,
                                    gradient: [UIColor(hex: 0x7ad3ff)!, UIColor(hex: 0xff41d3)!],
                                    shadow: UIColor(hex: 0xb196ed),
                                    shadowRadius: 20,
                                    shadowOpacity: 1,
                                    shadowOffset: CGSize(width: 0, height: 0),
                                    borderOut: false)
            btn.setTitle("开始", for: .normal)
            btn.isHidden = false
            btn.tag = 100
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            btn.frame = bounds
            progressViewContainer.addSubview(btn)
            self.startBtn = btn
            let flash = CASpringAnimation(keyPath: "transform.scale.x")
            flash.damping = 7.0
            flash.stiffness = 200.0
            flash.fromValue = 0.15
            flash.toValue = 1
            flash.duration = 3
            flash.fillMode = .forwards
            flash.isRemovedOnCompletion = false
            progressViewContainer.layer.cornerRadius = 10
            progressViewContainer.layer.add(flash, forKey: nil)
        }
    }
    
    /*
    fileprivate func startBtmAnimation() {
        let jump = CASpringAnimation(keyPath: "position.x")
        jump.initialVelocity = 100.0
        jump.mass = 40.0
        jump.stiffness = 800.0
        jump.damping = 20.0
        jump.fromValue = progressViewContainer.layer.position.x + 1.0
        jump.toValue = progressViewContainer.layer.position.x
        jump.duration = 0.25
        progressViewContainer.layer.add(jump, forKey: nil)
        startBtn.frame.size = CGSize(width: bounds.width, height: UISize.progressViewContainerSize.height)
        startBtn.center = progressViewContainer.center
        startBtn.layer.opacity = 1
        
        let group = CAAnimationGroup()
        group.fillMode = .both
        group.duration = 1
        group.beginTime = CACurrentMediaTime() + 0.25
        group.isRemovedOnCompletion = false
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let flash = CASpringAnimation(keyPath: "transform.scale.x")
        flash.damping = 7.0
        flash.stiffness = 200.0
        flash.fromValue = 0.15
        flash.toValue = 1
        flash.duration = 3
        
        let borderFlash = CASpringAnimation(keyPath: "cornerRadius")
        borderFlash.damping = 7.0
        borderFlash.stiffness = 200.0
        borderFlash.fromValue = progressViewContainer.bounds.width * 0.5
        borderFlash.toValue = 8
        borderFlash.duration = 3
        startBtn.layer.cornerRadius = 10
        
        group.animations = [flash, borderFlash]
        startBtn.layer.add(group, forKey: nil)
        
        startBtn.layer.shadowColor = UIColor(hex: 0xb196ed)?.cgColor
        startBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        startBtn.layer.shadowRadius = 20
        startBtn.layer.shadowOpacity = 1
        startBtn.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: startBtn.frame.maxY, width: bounds.width, height: 5)).cgPath
    }
 
 */
}


