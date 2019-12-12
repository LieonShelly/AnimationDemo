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
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()
    
    fileprivate lazy var innerShapeLayer: CAShapeLayer = {
           let innerShapeLayer = CAShapeLayer()
         innerShapeLayer.lineWidth = 1
           return innerShapeLayer
    }()
    fileprivate lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return shadowView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        testView.layer.cornerRadius = 12
        testView.layer.masksToBounds = true
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
        view.addSubview(bar)
        
        bar.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(76)
            $0.centerY.equalTo(view.snp.centerY).offset(200)
        }
    
        shadowView.snp.makeConstraints {
            $0.left.equalTo(bar.snp.left).offset(0)
            $0.right.equalTo(bar.snp.right).offset(0)
            $0.top.bottom.equalTo(bar)
        }
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.cornerRadius = 12
        shadowView.layer.shadowOffset = CGSize(width: -10, height: 10)
    }


    fileprivate func btnAction() {

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
