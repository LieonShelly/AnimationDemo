//
//  ScaleBtnViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/12/12.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ScaleBtnViewController: UIViewController {
    let bag = DisposeBag()
    @IBOutlet weak var testView: UIView!
    fileprivate lazy var btn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()
    lazy var gradientView: FXGradientView = {
        let maxTrackView = FXGradientView()
        (maxTrackView.layer as! CAGradientLayer).colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        maxTrackView.alpha = 1
        maxTrackView.layer.cornerRadius = 23
        maxTrackView.layer.masksToBounds = true
        (maxTrackView.layer as! CAGradientLayer).startPoint = CGPoint(x: 0, y: 0.5)
        (maxTrackView.layer as! CAGradientLayer).endPoint = CGPoint(x: 1, y: 0.5)
        return maxTrackView
    }()
    
    fileprivate lazy var innerShapeLayer: CAShapeLayer = {
        let innerShapeLayer = CAShapeLayer()
        innerShapeLayer.fillColor =  UIColor.yellow.cgColor
        innerShapeLayer.backgroundColor = UIColor.clear.cgColor
        return innerShapeLayer
    }()
    fileprivate lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(1)
        return shadowView
    }()
    fileprivate lazy var leftshadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(1)
        return shadowView
    }()
    fileprivate lazy var topshadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(1)
        return shadowView
    }()
    fileprivate lazy var rightshadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(1)
        return shadowView
    }()
    let destCenter =  CGPoint(x: 200, y: 150)
    
    fileprivate var dot: FXOneCycleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        testView.layer.cornerRadius = 12
        testView.layer.masksToBounds = true
        view.addSubview(gradientView)
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(50)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        btn.rx.tap
            .asObservable()
            .subscribe(onNext: btnAction)
            .disposed(by: bag)
        
        let bar = FXTutorialHandleNaviBar()
        bar.layer.cornerRadius = 12
        bar.layer.masksToBounds = true
        view.addSubview(shadowView)
        view.addSubview(leftshadowView)
        view.addSubview(topshadowView)
        view.addSubview(rightshadowView)
        view.addSubview(bar)
        
        bar.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(76)
            $0.centerY.equalTo(view.snp.centerY).offset(200)
        }
        //        let pathframe = CGRect(x: 0, y: 0, width: view.bounds.width - 20 * 2, height: 50)
        //        innerShapeLayer.frame = pathframe
        //        innerShapeLayer.path = UIBezierPath(roundedRect: pathframe, cornerRadius: 12).cgPath
        //        btn.layer.addSublayer(innerShapeLayer)
        
        
        //        gradientView.snp.makeConstraints {
        //            $0.edges.equalTo(btn)
        //        }
        gradientView.layer.mask = innerShapeLayer
        let shadowSize: CGFloat = 3
        shadowView.snp.makeConstraints {
            $0.left.equalTo(bar.snp.left).offset(0)
            $0.right.equalTo(bar.snp.right).offset(0)
            $0.bottom.equalTo(bar.snp.bottom).offset(0)
            $0.height.equalTo(shadowSize)
        }
        leftshadowView.snp.makeConstraints {
            $0.left.equalTo(bar.snp.left).offset(0)
            $0.top.equalTo(bar.snp.top)
            $0.bottom.equalTo(bar.snp.bottom).offset(0)
            $0.width.equalTo(shadowSize)
        }
        topshadowView.snp.makeConstraints {
            $0.left.equalTo(bar.snp.left).offset(0)
            $0.right.equalTo(bar.snp.right).offset(0)
            $0.top.equalTo(bar.snp.top)
            $0.height.equalTo(shadowSize)
        }
        rightshadowView.snp.makeConstraints {
            $0.bottom.equalTo(bar.snp.bottom).offset(0)
            $0.right.equalTo(bar.snp.right).offset(0)
            $0.top.equalTo(bar.snp.top)
            $0.width.equalTo(shadowSize)
        }
        setShadowProperty(leftshadowView)
        setShadowProperty(shadowView)
        setShadowProperty(rightshadowView)
        setShadowProperty(topshadowView)
        
        
        //        let dotWidth: CGFloat = 50
        //        self.dot = FXOneCycleView(frame: CGRect(x: destCenter.x - dotWidth * 0.5, y: destCenter.y - dotWidth * 0.5, width: dotWidth, height: dotWidth))
        //        self.view.insertSubview(self.dot!, belowSubview: self.gradientView)
        //        self.dot!.alpha = 0
    }
    
    fileprivate func setShadowProperty(_ shadowView: UIView) {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.cornerRadius = 12
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    
    fileprivate func btnAction() {
        let morphedFrame = CGRect(x: (btn.frame.width - btn.frame.height) * 0.5,
                                  y: 0,
                                  width: btn.frame.height,
                                  height: btn.frame.height)
        let morphAnimation = CABasicAnimation(keyPath: "path")
        morphAnimation.duration = 0.25
        morphAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        morphAnimation.toValue = UIBezierPath(roundedRect: morphedFrame, cornerRadius: morphedFrame.height * 0.5).cgPath
        morphAnimation.fillMode = .forwards
        morphAnimation.isRemovedOnCompletion = false
        innerShapeLayer.add(morphAnimation, forKey: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0.25, options: [], animations: {
            self.gradientView.center = self.destCenter
        }, completion: {_ in
            
        })
        UIView.animate(withDuration: 0.25, delay: 0.5, options: [.curveEaseInOut], animations: {
            self.gradientView.alpha = 0
            self.dot!.alpha = 1
        }, completion: {_ in
            self.dot?.showAniamtion()
        })
    }
    
    
}

extension ScaleBtnViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        btn.layer.cornerRadius = btn.frame.size.height * 0.5
    }
}



class FXTutorialHandleNaviBar: UIView {
    struct UISize {
        static let gradientHeight: CGFloat = 12
    }
    fileprivate lazy var blurView: FXTutorialBlurView = {
        let blurView = FXTutorialBlurView(withRadius: 20)
        return blurView
    }()
    class GraientView: UIView {
        class GraientViewLayer: CAGradientLayer {
            override var colors: [Any]? {
                get {
                    return [
                        UIColor(hex: 0x54d5ef)!.withAlphaComponent(0).cgColor,
                        UIColor(hex: 0x54ecef)!.cgColor,
                        UIColor(hex: 0xd79afb)!.cgColor,
                        UIColor(hex: 0xff82ff)!.cgColor,
                        UIColor(hex: 0xd795fb)!.cgColor,
                        UIColor(hex: 0x54d5ef)!.cgColor,
                        UIColor(hex: 0x54d5ef)!.withAlphaComponent(0).cgColor,
                    ]
                }
                set { }
            }
            
            override var startPoint: CGPoint {
                set {}
                get {
                    return CGPoint(x: 0, y: 0.5)
                }
            }
            
            override var endPoint: CGPoint {
                set { }
                get { return CGPoint(x: 1, y: 0.5) }
            }
            
            override var locations: [NSNumber]? {
                set { }
                get { return [0, 0.22, 0.4, 0.5, 0.61, 0.77, 1] }
            }
            
        }
        
        override class var layerClass: AnyClass {
            return GraientViewLayer.self
        }
    }
    fileprivate lazy var bottomLine: GraientView = GraientView()
    fileprivate lazy var innerShapeLayer: CAShapeLayer = {
        let innerShapeLayer = CAShapeLayer()
        innerShapeLayer.fillColor = UIColor.clear.cgColor
        innerShapeLayer.strokeColor = UIColor.red.cgColor
        return innerShapeLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = CGRect(x: 0,
                                y: 0,
                                width: bounds.width,
                                height: bounds.height)
        bottomLine.frame = CGRect(x: 0,
                                  y: bounds.height - UISize.gradientHeight,
                                  width:  bounds.width,
                                  height: UISize.gradientHeight)
        
        
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let shapeFrame =  CGRect(x: 0,
                                 y: 0,
                                 width:  bounds.width,
                                 height: UISize.gradientHeight)
        innerShapeLayer.frame = shapeFrame
        let radius = shapeFrame.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(withCenter: CGPoint(x: radius, y: 0),
                    radius: radius,
                    startAngle: .pi,
                    endAngle: .pi / 2,
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: bounds.width - radius, y: radius))
        path.addArc(withCenter: CGPoint(x:  bounds.width - radius, y: 0),
                    radius: radius,
                    startAngle: .pi / 2,
                    endAngle: 0, clockwise: false)
        innerShapeLayer.path = path.cgPath
        bottomLine.layer.mask = innerShapeLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
}

extension FXTutorialHandleNaviBar {
    fileprivate func configUI() {
        addSubview(blurView)
        addSubview(bottomLine)
        backgroundColor = .clear
    }
}
