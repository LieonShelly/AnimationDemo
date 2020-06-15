//
//  FXTutorialManulVideoHandleCell.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//  教程技巧Cell

import UIKit
import AVKit

class FXTutorialManulVideoHandleCell: UITableViewCell {
    struct UISize {
        static let playerHorizonInset: CGFloat = UIDevice.current.isiPhoneXSeries ? 50 : 20
    }
    fileprivate lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    fileprivate lazy var playerCoverView: UIImageView = {
        let playerCoverView = UIImageView()
        playerCoverView.layer.cornerRadius = 15
        playerCoverView.layer.masksToBounds = true
        return playerCoverView
    }()
    fileprivate lazy var playerView: FXPlayerView = {
        let playerView = FXPlayerView()
        playerView.layer.cornerRadius = 15
        playerView.layer.masksToBounds = true
        playerView.backgroundColor = .red
        return playerView
    }()
    fileprivate lazy var shadowView: FXShadowView = {
        let shadowView = FXShadowView()
        return shadowView
    }()
    fileprivate var timeObserver: Any?
    fileprivate var player: AVPlayer?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(titlelabel)
        contentView.addSubview(shadowView)
        contentView.addSubview(playerView)
        contentView.addSubview(playerCoverView)
       
        titlelabel.snp.makeConstraints {
            $0.top.equalTo(4)
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
        }
        playerView.snp.makeConstraints {
            $0.top.equalTo(titlelabel.snp.bottom).offset(20)
            $0.left.equalTo(UISize.playerHorizonInset)
            $0.right.equalTo(-UISize.playerHorizonInset)
            $0.bottom.equalTo(-35 * 0.5)
            $0.height.equalTo(100)
        }
        shadowView.snp.makeConstraints {
            $0.edges.equalTo(playerView.snp.edges).inset(-0)
        }
        playerCoverView.snp.makeConstraints {
            $0.edges.equalTo(playerView.snp.edges)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FXTutorialManulVideoHandleCell {
    func configData(_ model: FXTutorialHandleVideoModel) {
        titlelabel.text = model.text
        if let videoUrl = model.videoURL {
            FXVideoCoverGenerator.shared.generateThumbnailForVideo(videoUrl) { (image, url) in
                if videoUrl.absoluteString == url.absoluteString {
                    self.playerCoverView.image = image
                }
            }
            let imageHeight = FXTutorialHandleVideoListVC.playerHeight(videoUrl, relativeWidth: UIScreen.main.bounds.width - UISize.playerHorizonInset * 2)
            playerView.snp.updateConstraints {
                $0.height.equalTo(imageHeight)
            }
            let assset = AVAsset(url: videoUrl)
            let playerItem = AVPlayerItem(asset: assset)
            if player == nil {
                player = AVPlayer(playerItem: playerItem)
            } else {
                player?.replaceCurrentItem(with: playerItem)
            }
            playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            (playerView.layer as? AVPlayerLayer)?.player = player
            (playerView.layer as? AVPlayerLayer)?.videoGravity = .resizeAspect
            timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(10), timescale: 1000), queue: DispatchQueue.main) { [weak self](time) in
                guard let weakSelf = self, let totalTime = weakSelf.player?.currentItem?.duration, !totalTime.seconds.isNaN else {
                    return
                }
                let currentTime = time.seconds
                let progress = currentTime / totalTime.seconds
                
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let statusRawValue = change?[NSKeyValueChangeKey.newKey] as? Int, let status = AVPlayer.Status(rawValue: statusRawValue) {
            switch status {
            case .readyToPlay:
                player?.play()
                playerCoverView.isHidden = true
            default:
                playerCoverView.isHidden = false
            }
        }
    }
}
 class FXShadowView: UIView {

    fileprivate var cornerRadius: CGFloat = 22
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowPath = path
        layer.shadowColor = UIColor(hex: 0x020207)!.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 7)
        layer.shadowRadius = 15
    }
    
}
