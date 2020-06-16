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
        }
        showPlayerCover()
        startPlay(model)

    }
    
    func startPlay(_ model: FXTutorialHandleVideoModel) {
        configPlayer(model)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let statusRawValue = change?[NSKeyValueChangeKey.newKey] as? Int, let status = AVPlayer.Status(rawValue: statusRawValue) {
            switch status {
            case .readyToPlay:
                hiddenPlayerCover()
                player?.play()
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
            if player == nil {
                 player = AVPlayer(playerItem: playerItem)
            } else {
                hiddenPlayerCover()
                player?.seek(to: .zero)
                player?.play()
                return
            }
            playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            (playerView.layer as? AVPlayerLayer)?.player = player
            (playerView.layer as? AVPlayerLayer)?.videoGravity = .resizeAspect
            NotificationCenter.default.addObserver(self, selector: #selector(didPlayEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
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
