//
//  LoadingViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/12/27.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.black
        return btn
    }()
    fileprivate lazy var recoverBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("恢复会员", for: .normal)
       return btn
   }()
    fileprivate lazy var subscribeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("立即订阅", for: .normal)
        btn.backgroundColor = UIColor.black
        return btn
    }()
    fileprivate lazy var startBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("开始试用", for: .normal)
        btn.backgroundColor = UIColor.black
         return btn
    }()
    fileprivate lazy var privacyBtn: UIButton = {
         let btn = UIButton(type: .system)
         btn.setTitle("隐私政策", for: .normal)
         btn.backgroundColor = UIColor.black
          return btn
     }()
    fileprivate lazy var conditionBtn: UIButton = {
         let btn = UIButton(type: .system)
         btn.setTitle("试用条款", for: .normal)
         btn.backgroundColor = UIColor.black
          return btn
     }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func setupUI() {
        view.addSubview(closeBtn)
        view.addSubview(recoverBtn)
    }
    
}

class FXTutorialLaunchLoadingView: UIView {
    struct UISize {
        static let dotSize: CGSize = CGSize(width: 10, height: 10)
    }
    fileprivate lazy var dot0: FXGradientView = createDot()
    fileprivate lazy var dot1: FXGradientView = createDot()
    fileprivate lazy var dot2: FXGradientView = createDot()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dot0.alpha = 0.8
        dot2.alpha = 0.8
        addSubview(dot0)
        addSubview(dot1)
        addSubview(dot2)
        dot1.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)//.offset(-5)
            $0.size.equalTo(UISize.dotSize)
        }
        dot0.snp.makeConstraints {
            $0.centerY.equalTo(dot1.snp.centerY)//.offset(5)
            $0.right.equalTo(dot1.snp.left).offset(-10)
            $0.size.equalTo(UISize.dotSize)
        }
        dot2.snp.makeConstraints {
            $0.centerY.equalTo(dot1.snp.centerY)//.offset(-5)
            $0.left.equalTo(dot1.snp.right).offset(10)
            $0.size.equalTo(UISize.dotSize)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
}

extension FXTutorialLaunchLoadingView {
    fileprivate func createDot() -> FXGradientView {
        let dot = FXGradientView()
        (dot.layer as! CAGradientLayer).colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        (dot.layer as! CAGradientLayer).startPoint = CGPoint(x: 0, y: 0.5)
        (dot.layer as! CAGradientLayer).endPoint = CGPoint(x: 1, y: 0.5)
        dot.layer.cornerRadius = UISize.dotSize.width * 0.5
        dot.layer.masksToBounds = true
        return dot
    }
    
    func loading() {
        let position = CAKeyframeAnimation(keyPath: "position.y")
        position.timingFunction = CAMediaTimingFunction(name: .linear)
        position.repeatCount = .infinity
        position.duration = 0.25
        position.fillMode = .backwards
        position.autoreverses = true
        position.calculationMode = .linear
        position.values = [dot0.center.y + 7, dot0.center.y - 7]
        position.duration = 0.25
        dot0.layer.add(position, forKey: nil)
        
        position.fillMode = .forwards
        position.values = [dot1.center.y + 7, dot1.center.y - 7]
        position.duration = 0.29
        position.beginTime = CACurrentMediaTime() + 0.1
        dot1.layer.add(position, forKey: nil)
    
        position.values = [dot2.center.y + 7, dot2.center.y - 7]
        position.duration = 0.33
        position.beginTime = CACurrentMediaTime() + 0.2
        dot2.layer.add(position, forKey: nil)
    }
    
    fileprivate func createPostionAnima() -> CABasicAnimation {
        let position = CABasicAnimation(keyPath: "position.y")
        position.fromValue = bounds.height * 0.5
        position.toValue = bounds.height * 0.5 - 10
        position.timingFunction = CAMediaTimingFunction(name: .linear)
        position.repeatCount = .infinity
        position.duration = 1
        position.fillMode = .both
        position.autoreverses = true
        return position
    }
}
