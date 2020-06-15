//
//  PlayerViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/28.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController {
    var player: FXTutorialPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = FXTutorialPlayerView(frame: view.bounds)
        view.addSubview(player)
        let path = Bundle.main.path(forResource: "tmp571253848.mp4", ofType: nil)
        let url = URL(fileURLWithPath: path!)
        player.config(url)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}

class FXPlayerView: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}


import Foundation
import UIKit

class FXTutorialPlayerView: UIView {
    fileprivate lazy var player: AVPlayer = AVPlayer()
    fileprivate var playerItem: AVPlayerItem?
    
    struct UISize {
        static let bottomHeight: CGFloat = 56
        static let btnHeight: CGFloat = 32
    }
    fileprivate lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.layer.cornerRadius = 16
        bottomView.clipsToBounds = true
        return bottomView
    }()
    fileprivate lazy var slider: FXTutorialPlayerSlider = {
        let slider = FXTutorialPlayerSlider()
        return slider
    }()
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .yellow
        return btn
    }()
    fileprivate lazy var playBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .yellow
        return btn
    }()
    fileprivate var timeObserver: Any?
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    func config(_ url: URL) {
        releasePlayer()
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        playerItem = item
        (layer as! AVPlayerLayer).player = player
        playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main) { [weak self](time) in
            guard let weakSelf = self, let totalTime = weakSelf.playerItem?.duration else {
                return
            }
            let currentTime = time.seconds
            let progress = currentTime / totalTime.seconds
            weakSelf.slider.setProgress(CGFloat(progress))
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let statusRawValue = change?[NSKeyValueChangeKey.newKey] as? Int, let status = AVPlayer.Status(rawValue: statusRawValue) {
            switch status {
            case .readyToPlay:
                player.play()
            case .failed:
                print("failed")
            case .unknown:
                print("unknown")
            default:
                break
            }
        }
    }
    
    func releasePlayer() {
        playerItem?.removeObserver(self, forKeyPath: "status")
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }
    
    deinit {
        releasePlayer()
    }
}

extension FXTutorialPlayerView {
    fileprivate func configUI() {
        backgroundColor = .black
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: UIScreen.main.bounds.width - 15 * 2,
                                     height: UISize.bottomHeight)
        gradientLayer.colors = [
            UIColor(hex: 0x656565)!.cgColor,
            UIColor(hex: 0x454545)!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        bottomView.layer.addSublayer(gradientLayer)
        addSubview(bottomView)
        bottomView.addSubview(playBtn)
        bottomView.addSubview(closeBtn)
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalTo(-(UIDevice.current.safeAreaInsets.bottom + 20))
            $0.left.equalTo(28)
            $0.right.equalTo(-28)
            $0.height.equalTo(UISize.bottomHeight)
        }
        closeBtn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: UISize.btnHeight, height: UISize.btnHeight))
            $0.right.equalTo(-15)
            $0.centerY.equalTo(bottomView.snp.centerY)
        }
        playBtn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: UISize.btnHeight, height: UISize.btnHeight))
            $0.right.equalTo(closeBtn.snp.left).inset(-15)
            $0.centerY.equalTo(bottomView.snp.centerY)
        }
        layoutIfNeeded()
        let sliderHeight: CGFloat = 50
        slider = FXTutorialPlayerSlider(frame: CGRect(x: 15,
                                                      y: (bottomView.bounds.height - sliderHeight) * 0.5 ,
                                                      width: playBtn.frame.origin.x - 20,
                                                      height: sliderHeight))
        bottomView.addSubview(slider)
        playBtn.addTarget(self, action: #selector(playBtnAction), for: .touchUpInside)
        slider.valueChangeCallback = changeProgress
        slider.setProgress(0)
    }
    
    @objc fileprivate func playBtnAction() {
        if playBtn.isSelected {
            pauseAction()
        } else {
            playAction()
        }
    }
    fileprivate func playAction() {
        playBtn.isSelected = true
        player.play()
        
    }
    
    fileprivate func pauseAction() {
        player.pause()
        playBtn.isSelected = false
    }

    fileprivate func changeProgress(_ progress: CGFloat) {
        if let duration = player.currentItem?.duration {
            let playTime = Double(progress) * duration.seconds
            let seektime = CMTime(seconds: playTime, preferredTimescale: 1)
            player.seek(to: seektime) { (_) in
            }
        }
    }
    
}



class FXTutorialPlayerSlider: UIView {
    struct UISize {
        static let dotViewWidth: CGFloat = 16
        static let bgViewHeight: CGFloat = 4
        static let maxTrackWidth: CGFloat = 30
        static let dotSize: CGSize = CGSize(width: 16, height: 16)
        static let whiteDotSize: CGSize = CGSize(width: 8, height: 8)
      }
      
    var valueChangeCallback: ((CGFloat) -> Void)?
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white.withAlphaComponent(0.11)
        bgView.layer.cornerRadius = 2
        bgView.layer.masksToBounds = true
        return bgView
    }()
    fileprivate lazy var maxTrackView: FXGradientView = {
        let maxTrackView = FXGradientView()
        (maxTrackView.layer as! CAGradientLayer).colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        maxTrackView.layer.cornerRadius = 2
        maxTrackView.layer.masksToBounds = true
        (maxTrackView.layer as! CAGradientLayer).startPoint = CGPoint(x: 0, y: 0.5)
        (maxTrackView.layer as! CAGradientLayer).endPoint = CGPoint(x: 1, y: 0.5)
        return maxTrackView
    }()
    
    fileprivate lazy var dotView: UIView = {
        let dotView = UIView()
        return dotView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let whiteDot = UIView()
        whiteDot.backgroundColor = .white
        whiteDot.layer.cornerRadius = UISize.whiteDotSize.height * 0.5
        whiteDot.layer.masksToBounds = true
        addSubview(bgView)
        addSubview(maxTrackView)
        addSubview(dotView)
        dotView.addSubview(whiteDot)
        
        bgView.frame.origin.y = (bounds.height - UISize.bgViewHeight) * 0.5
        bgView.frame.origin.x = 0
        bgView.frame.size.width = bounds.width
        bgView.frame.size.height = UISize.bgViewHeight
        
        maxTrackView.frame.origin.x = 0
        maxTrackView.frame.origin.y = (bounds.height - UISize.bgViewHeight) * 0.5
        maxTrackView.frame.size = CGSize(width: UISize.maxTrackWidth, height: UISize.bgViewHeight)
        
        dotView.frame = CGRect(x: maxTrackView.frame.maxX,
                               y: (bounds.height - UISize.dotSize.height) * 0.5,
                               width: UISize.dotSize.width,
                               height: UISize.dotSize.height)
        
        whiteDot.frame = CGRect(x: (dotView.frame.width - UISize.whiteDotSize.width) * 0.5,
                                y: (dotView.frame.height - UISize.whiteDotSize.height) * 0.5,
                                width: UISize.whiteDotSize.width,
                                height: UISize.whiteDotSize.height)
        
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(panAction(_:)))
        dotView.isUserInteractionEnabled = true
        dotView.addGestureRecognizer(pan)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}

extension FXTutorialPlayerSlider {
  
    @objc
    fileprivate func panAction(_ ges: UIPanGestureRecognizer) {
        var location = ges.location(in: ges.view!)
        location = convert(location, from: ges.view!)
        var locatiox = location.x
        if locatiox >= bounds.width - UISize.whiteDotSize.width * 0.5 {
            locatiox = bounds.width - UISize.whiteDotSize.width * 0.5
        } else if locatiox <= dotView.frame.width * 0.5 {
            locatiox = UISize.whiteDotSize.width * 0.5
        }
        switch ges.state {
        case .began:
            UIView.animate(withDuration: 0.25, delay: 0,
                           options: [.transitionCrossDissolve], animations: {
                            self.maxTrackView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            self.dotView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            self.maxTrackView.frame.origin.x = 0
                            self.maxTrackView.frame.size.width = locatiox
                            self.dotView.center.x = locatiox
            }, completion: { _ in })
        case .changed:
            UIView.animate(withDuration: 0.25, delay: 0,
                           options: [.transitionCrossDissolve], animations: {
                            self.maxTrackView.frame.origin.x = 0
                            self.dotView.center.x = locatiox
                            self.maxTrackView.frame.size.width = locatiox
            }, completion: { _ in })
            
            
        case .ended:
            UIView.animate(withDuration: 0.25, delay: 0,
                           options: [.transitionCrossDissolve], animations: {
                            self.maxTrackView.transform = .identity
                            self.dotView.transform = .identity
                            self.maxTrackView.frame.origin.x = 0
                            self.maxTrackView.frame.size.width = locatiox
            }, completion: { _ in
                let progress = locatiox / (self.bounds.width - UISize.whiteDotSize.width)
                print("progress:\(progress)")
                self.valueChangeCallback?(progress)
            })
        default:
            break
        }
    }
    
    func setProgress(_ progress: CGFloat) {
        let locationX = (self.bounds.width - UISize.whiteDotSize.width) * progress
        maxTrackView.frame.origin.x = 0
        dotView.center.x = locationX
        maxTrackView.frame.size.width = locationX
    }
}


class FXGradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}




//
//  FXAnimtaeLayer.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2019/11/27.
//

import Foundation
import UIKit

class FXAnimtaeLayer: UIView {
    struct UISize {
        static let dotRadius: CGFloat = 20
        static let unitDistance: CGFloat = 10
        static let scaleMaxDistance: CGFloat = 300
        static let scaleMinDistance: CGFloat = 100
        static let scaleDelata: CGFloat = 300
        
    }
    fileprivate var animationCompletion: ((Bool) -> Void)?
    fileprivate lazy var dot1: UIView = {
        let dot = UIView()
        dot.backgroundColor = .clear
        dot.layer.opacity = 0
        return dot
    }()
    
    fileprivate lazy var dot2: UIView = {
        let dot = UIView()
        dot.backgroundColor = .clear
        dot.layer.opacity = 0
        return dot
    }()
    fileprivate var lastViewCenter: CGPoint = .zero
    fileprivate var lastAngle: CGFloat = 45
    fileprivate var lastScale: CGFloat = 1
    fileprivate var lastTwoPointDistance: CGFloat = 0
    fileprivate var initialTwoPoinitDistance: CGFloat = 0
    convenience init(_ viewCenter: CGPoint) {
        self.init(frame: UIScreen.main.bounds)
//        isUserInteractionEnabled = false
        self.lastViewCenter = viewCenter
        let dot1Position = CGPoint(x: viewCenter.x - 50, y: viewCenter.y + 50)
        let dot2Position = dot1Position.symmetricPoint(with: viewCenter)
        dot1.center = dot1Position
        dot2.center = dot2Position
        lastTwoPointDistance = dot1Position.distance(with: dot2Position)
        initialTwoPoinitDistance = lastTwoPointDistance
        dot1.bounds = CGRect(x: 0, y: 0, width: UISize.dotRadius * 2, height: UISize.dotRadius * 2)
        dot2.bounds = CGRect(x: 0, y: 0, width: UISize.dotRadius * 2, height: UISize.dotRadius * 2)
        let dot1Layer = createDotlayer()
        dot1Layer.frame = dot1.bounds
        let dot2Layer = createDotlayer()
        dot2Layer.frame = dot2.bounds
        dot1.layer.addSublayer(dot1Layer)
        dot2.layer.addSublayer(dot2Layer)
        addSubview(dot1)
        addSubview(dot2)
        self.lastViewCenter = viewCenter
        self.lastAngle = 45
        self.lastScale = 1
        backgroundColor = UIColor.red
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = self.transform.rotated(by: -0.5722887166607017)
    }

    
}


extension FXAnimtaeLayer {
    func startShow(completion: ((Bool) -> Void)? = nil) {
        dot1.layer.opacity = 1
        dot2.layer.opacity = 1
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [0, 1.5, 1]
        scale.duration = 0.3
        scale.calculationMode = CAAnimationCalculationMode(rawValue: "linear")
        scale.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "easeOut"))
        scale.fillMode = CAMediaTimingFillMode(rawValue: "backwards")
        scale.isRemovedOnCompletion = false
        scale.setValue("show", forKey: "name")
        scale.delegate = self
        dot1.layer.add(scale, forKey: nil)
        dot2.layer.add(scale, forKey: nil)
        self.animationCompletion = completion
    }
    
    func change(_ viewCenter: CGPoint,
                angle: CGFloat? = nil,
                angleIncrease: Bool? = nil,
                scale: CGFloat? = nil,
                scaleIncrease: Bool? = nil) {
        if viewCenter != lastViewCenter { /// 移动两个点
            self.center = viewCenter
        }
        if let angle = angle {
            self.transform = self.transform.rotated(by: angle)
        }
        if let scale = scale, scale != lastScale, let scaleIncrease = scaleIncrease {
            var currentDistance: CGFloat = lastTwoPointDistance
            if scaleIncrease {
                currentDistance = initialTwoPoinitDistance + UISize.scaleMinDistance * scale
            } else if scale < 1 {
                currentDistance = initialTwoPoinitDistance - UISize.scaleMinDistance * (1 - scale)
                currentDistance = currentDistance <= 0 ? 0 : currentDistance
            }
            let dot2Postion = CGPoint(x: viewCenter.x + sqrt(currentDistance * currentDistance / 8),
                                    y: viewCenter.y - sqrt(currentDistance * currentDistance / 8))
            let dot1Postion = CGPoint(x: viewCenter.x - sqrt(currentDistance * currentDistance / 8),
                                    y: viewCenter.y + sqrt(currentDistance * currentDistance / 8))
            dot1.center = dot1Postion
            dot2.center = dot2Postion
            lastTwoPointDistance = dot1Postion.distance(with: dot2Postion)
            lastScale = scale
        }
    }
    
    func endShow(completion: ((Bool) -> Void)? = nil) {
        let dismissGroup = CAAnimationGroup()
        dismissGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "linear"))
        dismissGroup.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        dismissGroup.isRemovedOnCompletion = false
        dismissGroup.duration = 0.3
        dismissGroup.delegate = self
        dismissGroup.setValue("dismissGroup", forKey: "name")
        
        let dismissOpacity = CABasicAnimation(keyPath: "opacity")
        dismissOpacity.fromValue = 1
        dismissOpacity.toValue = 0
        
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1.5, 0]
        dismissGroup.animations = [scale, dismissOpacity]
        dot2.layer.add(dismissGroup, forKey: nil)
        dot1.layer.add(dismissGroup, forKey: nil)
        self.animationCompletion = completion
    }
    
    
}

extension FXAnimtaeLayer: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationCompletion?(flag)
        if let name = anim.value(forKey: "name") as? String, name == "dismissGroup"{
            dot2.layer.removeAllAnimations()
            dot1.layer.removeAllAnimations()
            layer.removeAllAnimations()
            dot1.layer.opacity = 0
            dot2.layer.opacity = 0
        }
    }
}

extension FXAnimtaeLayer {
    
    fileprivate func createMoveAnimation() -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "position")
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "linear"))
        anim.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        anim.isRemovedOnCompletion = false
        anim.duration = 0.05
        return anim
    }
    
    fileprivate func createRotateAnimation() -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        return anim
    }
    
    fileprivate func makeScaleAnimation(_ endScale: CGFloat) -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.toValue = endScale
        return anim
    }
    
    fileprivate func createAnimationGroup() -> CAAnimationGroup {
        let dismissGroup = CAAnimationGroup()
        dismissGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "linear"))
        dismissGroup.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        dismissGroup.isRemovedOnCompletion = false
        dismissGroup.beginTime = CACurrentMediaTime() + 0.2 + 0.15
        dismissGroup.duration = 0.05
        dismissGroup.delegate = self
        return dismissGroup
    }
    
    fileprivate func createDotlayer() -> FXTutorialDot{
        let dotLayer = FXTutorialDot()
        dotLayer.borderColor = UIColor.white.cgColor
        dotLayer.cornerRadius = UISize.dotRadius
        return dotLayer
    }
}



extension CGPoint {

    func distance(with point: CGPoint) -> CGFloat {
        let xsqure = abs(x - point.x) * abs(x - point.x)
        let ysqure = abs(y - point.y) * abs(y - point.y)
        return sqrt(xsqure + ysqure)
    }
}
