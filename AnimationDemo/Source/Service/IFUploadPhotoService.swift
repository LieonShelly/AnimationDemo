//
//  IFUploadPhotoService.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/16.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import Photos

class IFUploadPhotoService {
    fileprivate lazy var photos: [PHAsset] = []
    fileprivate var currentTokenStr: String = ""
    fileprivate lazy var queue = OperationQueue()
    fileprivate lazy var group = DispatchGroup()
    fileprivate lazy var isStop = false
    
    var totoal: Int {
        return photos.count
    }
    var uploadedCount: Int = 0
    
    func startUpload() {
        if currentTokenStr.isEmpty {
            getQiniuToken("name", callback: {[weak self] token in
                guard let weakSelf = self, let token = token else {
                    return
                }
                weakSelf.currentTokenStr = token
                
            })
        } else {
            
        }
    }
    
    func stopUpload() {
        isStop = true
        group.leave()
        group.notify(queue: .main) {
            
        }
    }
}

extension IFUploadPhotoService {
    func upload() {
        isStop = false
        let queue = DispatchQueue(label: "upload", qos: .default, attributes: .concurrent)
        queue.async {
            let semaphore = DispatchSemaphore(value: 3)
            let lock = NSLock()
            self.group.enter()
            for photo in 0 ..< 20 {
                semaphore.wait()
                self.group.enter()
                self.uploadSingle(PHAsset(), callback: { progress, url in
                    if let url = url {
                        lock.lock()
                        self.uploadedCount += 1
                        print(self.uploadedCount)
                        lock.unlock()
                    } else {
                        
                    }
                    self.group.leave()
                    semaphore.signal()
                })
            }
            self.group.notify(queue: .main) {
                
            }
        }
    }
    
    fileprivate func uploadSingle(_ asset: PHAsset, callback: ((_ progress: Float, _ url: String?) -> Void)?) {
        if isStop {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            callback?(1.0, "adsf")
        }
//        loadImage(asset, size: CGSize(width: 100, height: 100), complection: {[weak self]pic in
//            guard let weakSelf = self else {
//                return
//            }
//            guard let data = pic?.jpegData(compressionQuality: 0.8) else {
//                return
//            }
//            weakSelf.uploadQiniu(asset.burstIdentifier ?? "", fileData: data, callback: callback)
//        })
    }
    /// 上传资源
   fileprivate func uploadQiniu(_ fileName: String, fileData: Data, callback: ((_ progress: Float, _ url: String?) -> Void)) {
       
    }
    
    /// 获取七牛token
    fileprivate func getQiniuToken(_ fileName: String, callback: ((_ token: String?) -> Void)) {
        
    }
    
    /// 获取图片
    fileprivate func loadImage(_ asset: PHAsset, size: CGSize, complection: ((UIImage?)-> Void)) {
        
    }
}
