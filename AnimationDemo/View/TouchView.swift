
//
//  TouchView.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/11.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TouchView: UIView {
    var currentHandlePoints: [CGPoint] = []
    lazy var path: UIBezierPath = UIBezierPath()
    fileprivate lazy var allPath: [UIBezierPath] = []
    var gestureCallback:((UIPanGestureRecognizer) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addGesture()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        UIColor.yellow.setStroke()
        path.stroke()
    }
    
    func clear() {
        allPath.removeAll()
        path = UIBezierPath()
        setNeedsDisplay()
    }
}

extension TouchView {
    fileprivate func createShapLayer() -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.strokeColor = UIColor.yellow.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineJoin = .round
        shape.lineCap = .round
        shape.lineWidth = 20
        shape.frame = bounds
        return shape
    }
    
    fileprivate func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 10
        return path
    }
    
    fileprivate func addGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(_:)))
        addGestureRecognizer(pan)
        
    }
    
    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        gestureCallback?(pan)
        let location = pan.location(in: self)
        switch pan.state {
        case .began:
            let path = createPath()
            path.move(to: location)
            self.path = path
            currentHandlePoints.removeAll()
            allPath.append(path)
            currentHandlePoints.append(location)
        case .changed:
            path.addLine(to: location)
            setNeedsDisplay()
            currentHandlePoints.append(location)
        default:
            break
        }
    }
    
}

class TouchRecordView: TouchView {
    fileprivate lazy var dot: UIView = {
        let dot = UIView()
        return dot
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addot()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addot()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func addot() {
        dot.bounds.size = CGSize(width: 20, height: 20)
        dot.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        dot.layer.cornerRadius = 10
        dot.layer.borderColor =  UIColor.lightGray.withAlphaComponent(0.7).cgColor
        dot.layer.borderWidth = 1
        addSubview(dot)
    }
    
    override func panAction(_ pan: UIPanGestureRecognizer) {
        let location = pan.location(in: self)
        dot.center = location
        super.panAction(pan)
        
    }
    
    
}



extension Bundle {
    ///
    /// 默认获取教程图片资源
    ///
    /// - Parameters:
    ///     - bundleName: 执行bundle，默认是FXTutorial
    ///     - fileName: 图片资源名称（可以不传@3x，内部处理）
    ///     - fileType: 默认PNG
    /// - Returns: 图片路径
    static func getFilePath(_ bundleName: String = "FXTutorial",
                            fileName: String,
                            fileType: String = "png") -> String {
        if let str = Bundle.main.path(forResource: fileName + "@3x", ofType: fileType) {
            return str
        } else if let str = Bundle.main.path(forResource: fileName, ofType: fileType) {
            return str
        }
        return ""
    }
}



import Foundation
import UIKit
import AVKit

public enum SimpleVideViewPlayType {
    case none
    case backToBegin
    case cycle
    case reverse
}

public class SimpleVideoView : UIView {
    public var playEndCallback: (() -> Void)?
    public var playerLayer : AVPlayerLayer!
    private let KEY_PATH =  "status"
    
    public var playType: SimpleVideViewPlayType = .cycle
    
    var canPlayReversly: Bool {
        return playerLayer.player?.currentItem?.canPlayReverse ?? false
    }
    
    var isReversing: Bool = false
    public var reverse: Bool {
        get {
            return canPlayReversly && playerLayer.player?.rate == 0
        }
        set {
            if canPlayReversly {
                playerLayer.player?.rate = newValue ? -1.0 : 1.0
                isReversing = newValue
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        playerLayer = AVPlayerLayer()
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
    }
    
    deinit {
        endPlay()
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        if layer == self.layer {
            playerLayer.bounds = layer.bounds
            playerLayer.position = CGPoint.init(x: layer.bounds.midX, y: layer.bounds.midY)
        }
    }
    
    public func loadUrl(url videoURL: URL) {
        let asset = AVURLAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer.init(playerItem: playerItem)
      
        playerLayer.player = player
    }

    public func startPlay() {
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerLayer.player?.currentItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        playerLayer.player?.play()
    }
    
    public func endPlay() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerLayer.player?.currentItem)
        playerLayer.player?.pause()
    }
    
    @objc func enterForeground() {
        playerLayer.player?.play()
    }
    
    func endPlayForReset() {
        endPlay()
        playerLayer.player?.seek(to: CMTime.zero)
    }

    @objc func playToEndTime() {
        playEndCallback?()
        switch playType {
        case .backToBegin:
            playerLayer.player?.seek(to: CMTime.zero)
        case .cycle:
            playerLayer.player?.seek(to: CMTime.zero)
            playerLayer.player?.play()
        case .reverse:
//            endPlay()
//            playerLayer.player?.seek(to: playerLayer.player?.currentTime() ?? kCMTimeZero)
            reverse = !isReversing
//            playerLayer.player?.play()
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
