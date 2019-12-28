//
//  BtnProgressViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class BtnProgressViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var imageVIew: UIImageView!
    var progressView: FXTutorialProgressView!
    @IBOutlet weak var animateView: UIView!
    var tag: Int = 0
    var arcView: FXArcView!
    override func viewDidLoad() {
        super.viewDidLoad()
        animateView.backgroundColor = .white
        progressView = FXTutorialProgressView(frame: CGRect(x: 20, y: animateView.center.y - 50, width: view.bounds.width - 40, height: 46))
        animateView.addSubview(progressView)
        progressView.reloadBtnAction = {[weak self] in
            self?.progressView.setProgress(1, hasError: false)
        }
//        let testView = FXWhiteCycleView(frame: CGRect(x: 20, y: animateView.center.y - 50, width: 46, height: 46))
//        animateView.addSubview(testView)
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        progressView.setProgress(0.9, hasError: true)
         
        
    }
    
    @IBAction func sliderProgreeAction(_ sender: UISlider) {
//        progressView.setProgress(CGFloat(sender.value), hasError: tag == 1)
        progressView.gradientView.showAnimation()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        tag = sender.tag
    }
    
}


class FXTutorialProgressView: UIView {
    var reloadBtnAction: (() -> Void)?
    var startBtnAction: (() -> Void)?
    struct UISize {
        static let progressBorder: CGFloat = 23
        static let progressLinWidth: CGFloat = 10
        static let progressViewContainerSize: CGSize = CGSize(width: 46, height: 46)
    }
    fileprivate lazy var progressContentView: UIView = {
        let progressContentView = UIView()
        progressContentView.layer.masksToBounds = true
        progressContentView.layer.cornerRadius = 10
        return progressContentView
    }()
    fileprivate lazy var shadowView: UIView = {
        let progressContentView = UIView()
        progressContentView.backgroundColor = .white
        return progressContentView
    }()
    fileprivate lazy var titleLabel: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("加载中...", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    lazy var backView: FXGradientView = {
        let maxTrackView = FXGradientView()
        (maxTrackView.layer as! CAGradientLayer).colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        (maxTrackView.layer as! CAGradientLayer).startPoint = CGPoint(x: 0, y: 0.5)
        (maxTrackView.layer as! CAGradientLayer).endPoint = CGPoint(x: 1, y: 0.5)
        return maxTrackView
    }()
    fileprivate lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return whiteView
    }()
    
    lazy var gradientView: FXArcView = {
        let maxTrackView = FXArcView()
        return maxTrackView
    }()
    fileprivate var isProgress: Bool = false
    
    fileprivate lazy var startBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    fileprivate lazy var reloadBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle(" 加载失败，点击刷新", for: .normal)
        btn.backgroundColor = .red
        return btn
    }()
    fileprivate lazy var reloadBgView: UIView = {
        let reloadBgView = UIView()
        reloadBgView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return reloadBgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        addSubview(shadowView)
        addSubview(progressContentView)
        progressContentView.addSubview(backView)
        progressContentView.addSubview(whiteView)
        progressContentView.addSubview(gradientView)
        progressContentView.addSubview(reloadBgView)
        progressContentView.addSubview(titleLabel)
        progressContentView.addSubview(startBtn)
        progressContentView.addSubview(reloadBtn)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isProgress {
            gradientView.frame = CGRect(x: -UISize.progressBorder, y: 0, width: bounds.width, height: bounds.height)
            progressContentView.frame = bounds
            shadowView.frame = CGRect(x: 10, y: 10, width: bounds.width - 10 * 2, height: bounds.height - 10 * 2)
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 8)
            shadowView.layer.shadowRadius = 20
            shadowView.layer.shadowOpacity = 0.8
            shadowView.layer.shadowColor = UIColor(hex: 0xB196ED)?.cgColor
            backView.frame = progressContentView.bounds
            whiteView.frame = progressContentView.bounds
            titleLabel.frame = progressContentView.bounds
            reloadBtn.frame = CGRect(x: 0, y: -progressContentView.bounds.height, width: progressContentView.bounds.width, height: progressContentView.bounds.height)
            reloadBgView.frame = CGRect(x: 0, y: -progressContentView.bounds.height, width: progressContentView.bounds.width, height: progressContentView.bounds.height)
            startBtn.frame = CGRect(x: 0, y: -progressContentView.bounds.height, width: progressContentView.bounds.width, height: progressContentView.bounds.height)
        }
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
    
    func setProgress(_ progress: CGFloat, hasError: Bool = false) {
        isProgress = true
        gradientView.frame.size.width = (self.bounds.width  + UISize.progressBorder * 2) * progress
        titleLabel.setTitle("加载中...", for: .normal)
        if progress >= 1 && !hasError {
            startBtn.setTitle("开始", for: .normal)
            UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
                self.gradientView.frame.size.width = self.bounds.width + UISize.progressBorder * 2
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0.35, usingSpringWithDamping: 0.7, initialSpringVelocity: -15, options: [.transitionCrossDissolve], animations: {
                self.startBtn.frame.origin.y = 0
                self.titleLabel.frame.origin.y = self.bounds.height
            }, completion: { _ in
                self.startBtn.addTarget(self, action: #selector(self.startnAction), for: .touchUpInside)
            })
        } else if hasError {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.transitionCrossDissolve],
                           animations: {
                            self.gradientView.frame.size.width = self.bounds.width + UISize.progressBorder * 2
            }, completion: nil)
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.transitionCrossDissolve], animations: {
                self.reloadBtn.frame.origin.y = 0
                self.reloadBgView.frame.origin.y = -10
                self.reloadBgView.frame.size.height = self.bounds.height + 10
                self.titleLabel.frame.origin.y = self.bounds.height
            }, completion: { _ in
                self.reloadBtn.addTarget(self, action: #selector(self.reloadAction), for: .touchUpInside)
            })
        }
    }
    
    @objc fileprivate func reloadAction() {
        titleLabel.setTitle(" 加载失败，点击刷新", for: .normal)
        gradientView.frame.size.width = 0
        startBtn.frame.origin.y = -bounds.height
        reloadBtn.frame.origin.y = -bounds.height
        reloadBgView.frame.origin.y = -(self.bounds.height + 10)
        reloadBgView.frame.size.height = self.bounds.height + 10
        titleLabel.isHidden = false
        titleLabel.frame.origin.y = 0
        reloadBtn.removeTarget(self, action: #selector(self.reloadAction), for: .touchUpInside)
        reloadBtnAction?()
    }
    
    @objc fileprivate func startnAction() {
        startBtnAction?()
        startBtn.removeTarget(self, action: #selector(startnAction), for: .touchUpInside)
    }
    
}

class FXArcView: UIView {
    fileprivate lazy var cycView:  FXGradientView = {
        let maxTrackView = FXGradientView()
        (maxTrackView.layer as! CAGradientLayer).colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        (maxTrackView.layer as! CAGradientLayer).startPoint = CGPoint(x: 0, y: 0.5)
        (maxTrackView.layer as! CAGradientLayer).endPoint = CGPoint(x: 1, y: 0.5)
        return maxTrackView
    }()
    fileprivate lazy var whiteCycleView0: FXWhiteCycleView = {
        let whiteCycleView = FXWhiteCycleView()
        return whiteCycleView
    }()
    fileprivate lazy var whiteCycleView1: FXWhiteCycleView = {
        let whiteCycleView = FXWhiteCycleView()
        return whiteCycleView
    }()
    fileprivate lazy var whiteCycleView2: FXWhiteCycleView = {
        let whiteCycleView = FXWhiteCycleView()
        return whiteCycleView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        cycView.backgroundColor = .red
        layer.masksToBounds = true
        addSubview(cycView)
        cycView.addSubview(whiteCycleView2)
         cycView.addSubview(whiteCycleView1)
        cycView.addSubview(whiteCycleView0)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cycleWidth: CGFloat = 100
        cycView.layer.cornerRadius = cycleWidth * 0.5
        cycView.layer.masksToBounds = true
        let postionX: CGFloat = -10
        cycView.frame = CGRect(x: postionX,
                               y: 0,
                               width: bounds.width + abs(postionX),
                               height: cycleWidth)
        cycView.center.y = bounds.height * 0.5
        let size = cycView.bounds.size
        let whiteCyclePositionX: CGFloat = -size.width
        whiteCycleView2.frame = CGRect(origin: CGPoint(x: whiteCyclePositionX, y: 0), size: size)
        whiteCycleView1.frame = CGRect(origin: CGPoint(x: whiteCycleView2.frame.origin.x - 30 , y: 0), size: size)
        whiteCycleView0.frame = CGRect(origin: CGPoint(x: whiteCycleView1.frame.origin.x - 30, y: 0), size: size)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        superview?.willMove(toSuperview: newSuperview)
    }
    
   func showAnimation() {
        let position =  CABasicAnimation(keyPath: "position.x")
        position.fromValue = -30
        position.toValue = bounds.width + 30
        position.fillMode = .removed
        position.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        position.duration = 0.5
        whiteCycleView2.layer.add(position, forKey: nil)
        position.duration = 0.35
        whiteCycleView1.layer.add(position, forKey: nil)
        position.duration = 0.25
        whiteCycleView0.layer.add(position, forKey: nil)
    }

}


class FXWhiteCycleView: UIView {
    
    fileprivate lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.cyan.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        layer.anchorPoint = CGPoint(x: 1, y: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let lineWidth: CGFloat = 15
        shapeLayer.lineWidth = lineWidth
        let radius: CGFloat = 80
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.width - radius - lineWidth * 0.5, y: bounds.height * 0.5),
                                radius: radius,
                                startAngle: .pi * 7 / 4,
                                endAngle: .pi / 4,
                                clockwise: true)
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
}
