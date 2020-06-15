//
//  FXTutorialHandleVideoListVM.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation

class FXTutorialHandleVideoListVM {
    lazy var sections: [FXTutorialHandleVideoListUIType] = []
    fileprivate var inputVideo: FXTutorialHandleVideoModel?
    
    /// 外部传入的教程video
    init(_ videoModel: FXTutorialHandleVideoModel? = nil) {
        self.inputVideo = videoModel
    }
    
    /// 加载数据
    func configData(_ finish: (() -> Void)?) {
        if let inputVideo = self.inputVideo {
            sections.append(.tutorilSkill([inputVideo]))
        }
        // vertical_scroll_texture_touch_clear
        let videoPath = Bundle.main.path(forResource: "vertical_scroll_texture_touch_clear.mp4", ofType: nil)
        let videoURL = URL(fileURLWithPath: videoPath ?? "")
        sections.append(.commonSkill(
            [FXTutorialHandleVideoModel(videoURL, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧"),
             FXTutorialHandleVideoModel(videoURL, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧")]
            ))
        finish?()
    }
}
