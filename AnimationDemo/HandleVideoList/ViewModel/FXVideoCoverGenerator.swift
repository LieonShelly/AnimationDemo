//
//  FXVideoCoverGenerator.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//

import AVKit

/// 获取视频中的图片
class FXVideoCoverGenerator {
    static let shared: FXVideoCoverGenerator = FXVideoCoverGenerator()
    fileprivate let queue = DispatchQueue(label: "FXVideoGeneratorQueue", attributes: .concurrent)
    private init() {}
    
    /**
     判断内存中是否存在缓存的图片
     存在直接返回图片
     不存在。开启线程获取，获取成功，存缓存，存磁盘，然后放回图片
     */
    func generateThumbnailForVideo(_ url: URL, maximumSize: CGSize, completion: ((_ image: UIImage?, _ url: URL) -> Void)?) {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.maximumSize = maximumSize
        imageGenerator.appliesPreferredTrackTransform = true
        guard let imageRef = try? imageGenerator .copyCGImage(at: .zero, actualTime: nil) else {
            completion?(nil, url)
            return
        }
        
        let image = UIImage(cgImage: imageRef)
        completion?(image, url)
    }
    
    func getVideoSize(_ url: URL) -> CGSize {
        let asset = AVAsset(url: url)
        let tracks = asset.tracks
        var videoSize = CGSize(width: 0, height: 0)
        for track in tracks where track.naturalSize != .zero {
            videoSize = track.naturalSize
        }
        return videoSize
    }
}

