//
//  FXTutorialManulVideoBaseCell.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//

import AVKit

class FXTutorialManulVideoBaseCell: UITableViewCell {
    struct UISize {
        static let playerHorizonInset: CGFloat = UIDevice.current.isiPhoneXSeries ? 50 : 20
    }
    lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    lazy var playerCoverView: UIImageView = {
        let playerCoverView = UIImageView()
        playerCoverView.layer.cornerRadius = 15
        playerCoverView.layer.masksToBounds = true
        return playerCoverView
    }()
    lazy var playerView: FXPlayerView = {
        let playerView = FXPlayerView()
        playerView.layer.cornerRadius = 15
        playerView.layer.masksToBounds = true
        return playerView
    }()
    lazy var shadowView: FXShadowView = {
        let shadowView = FXShadowView()
        return shadowView
    }()
    var player: AVPlayer?
    fileprivate var timeObserver: Any?
    fileprivate var videoData: FXTutorialHandleVideoModel?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configData(_ model: FXTutorialHandleVideoModel) {
        self.videoData = model
        titlelabel.text = model.text
        if let videoUrl = model.videoURL {
            let imageWidth = UIScreen.main.bounds.width - UISize.playerHorizonInset * 2
            let imageHeight = FXTutorialHandleVideoListVC.playerHeight(videoUrl, relativeWidth: imageWidth)
            if let coverImg = model.coverImg {
                playerCoverView.image = UIImage(contentsOfFile: coverImg)
            } else {
                FXVideoCoverGenerator.shared.generateThumbnailForVideo(videoUrl, maximumSize:CGSize(width: imageWidth, height: imageHeight) ) { (image, url) in
                    if videoUrl.absoluteString == url.absoluteString {
                        self.playerCoverView.image = image
                    }
                }
            }
            if playerView.bounds.height != imageHeight {
                playerView.snp.updateConstraints {
                    $0.height.equalTo(imageHeight)
                }
                contentView.layoutIfNeeded()
            }
        }
        startPlay(model)
    }
    
    func startPlay(_ model: FXTutorialHandleVideoModel) {
        configPlayer(model)
    }
    
    func pausePlay() {
        guard let duration = player?.currentItem?.duration.seconds, !duration.isNaN else {
            return
        }
        let time = CMTime(seconds: duration, preferredTimescale: 1)
        player?.pause()
        player!.seek(to: time, completionHandler: { _ in
            print("pausePlay - pausePlay - currentTime \(self.player?.currentItem?.currentTime().seconds ?? 0)")
            self.player?.play()
            print("pausePlay - pausePlay - currentTime \(self.player?.currentItem?.currentTime().seconds ?? 0)")
        })
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let statusRawValue = change?[NSKeyValueChangeKey.newKey] as? Int, let status = AVPlayer.Status(rawValue: statusRawValue), let model = videoData {
            switch status {
            case .readyToPlay:
                switch model.status {
                case .idle:
                    player?.play()
                default:
                    guard let duration = player?.currentItem?.duration.seconds, !duration.isNaN else {
                        return
                    }
                    player?.pause()
                    let time = CMTime(value: CMTimeValue(10000 * duration * model.status.progress), timescale: 10000)
                    player!.seek(to: time, completionHandler: { _ in
                        self.player?.play()
                    })
                }
                hiddenPlayerCover()
            default:
                showPlayerCover()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
}

extension FXTutorialManulVideoBaseCell {
    @objc
    fileprivate func didPlayEnd() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    fileprivate func configPlayer(_ model: FXTutorialHandleVideoModel) {
        self.videoData = model
        if let videoUrl = model.videoURL {
            let playerItem = AVPlayerItem(url: videoUrl)
            player = AVPlayer(playerItem: playerItem)
            playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            (playerView.layer as? AVPlayerLayer)?.player = player
            (playerView.layer as? AVPlayerLayer)?.videoGravity = .resizeAspect
            NotificationCenter.default.addObserver(self, selector: #selector(didPlayEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(10), timescale: 1000), queue: DispatchQueue.main) { [weak self](time) in
                let currentTime = time.seconds
                guard let weakSelf = self, let totalTime = weakSelf.player?.currentItem?.duration, !totalTime.seconds.isNaN else {
                    return
                }
                let progress = currentTime / totalTime.seconds
                //                model.status = .inProgress(progress)
            }
        }
    }
    
    fileprivate func showPlayerCover() {
        UIView.animate(withDuration: 0.25, delay: 00, options: [.curveEaseInOut], animations: {
            self.playerCoverView.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func hiddenPlayerCover() {
        UIView.animate(withDuration: 0.25, delay: 00, options: [.curveEaseInOut], animations: {
            self.playerCoverView.alpha = 0
        }, completion: nil)
    }
}
