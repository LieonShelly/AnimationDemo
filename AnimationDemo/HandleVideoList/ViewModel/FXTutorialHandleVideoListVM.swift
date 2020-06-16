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
        let videoURL0 = URL(fileURLWithPath:  Bundle.main.path(forResource: "vertical_scroll_texture_touch_clear.mp4", ofType: nil) ?? "")
        let videoURL1 = URL(fileURLWithPath:  Bundle.main.path(forResource: "vertical_scroll_contrast.mp4", ofType: nil) ?? "")
        let videoURL2 = URL(fileURLWithPath:  Bundle.main.path(forResource: "vertical_scroll_cut_into_horizontal_perspective.mp4", ofType: nil) ?? "")
        let videoURL3 = URL(fileURLWithPath:  Bundle.main.path(forResource: "vertical_scroll_cut_into_vertical_perspective.mp4", ofType: nil) ?? "")
        let videoURL4 = URL(fileURLWithPath:  Bundle.main.path(forResource: "vertical_scroll_face_exact_fix_ease_up.mp4", ofType: nil) ?? "")
        let videoURL5 = URL(fileURLWithPath:  Bundle.main.path(forResource: "vertical_scroll_face_exact_fix_light_eye.mp4", ofType: nil) ?? "")
        let videoURL6 = URL(fileURLWithPath:  Bundle.main.path(forResource: "vertical_scroll_face_exact_fix_light_skin.mp4", ofType: nil) ?? "")
        let videoURL7 = URL(fileURLWithPath:  Bundle.main.path(forResource: "vertical_scroll_face_exact_fix_light_white.mp4", ofType: nil) ?? "")
        let videoURL8 = URL(fileURLWithPath:  Bundle.main.path(forResource: "vertical_scroll_face_exact_fix_shadow.mp4", ofType: nil) ?? "")
        let videoURL9 = URL(fileURLWithPath:  Bundle.main.path(forResource: "vertical_scroll_face_exact_fix_skin.mp4", ofType: nil) ?? "")
        let coverImagePath = Bundle.main.path(forResource: "vertical_scroll_texture_touch_clear_cover.jpg", ofType: nil)
        sections.append(.commonSkill(
            [FXTutorialHandleVideoModel(videoURL0, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧", coverImg: coverImagePath),
             FXTutorialHandleVideoModel(videoURL1, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧", coverImg: coverImagePath),
             FXTutorialHandleVideoModel(videoURL2, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧", coverImg: coverImagePath),
             FXTutorialHandleVideoModel(videoURL3, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧", coverImg: coverImagePath),
             FXTutorialHandleVideoModel(videoURL4, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧", coverImg: coverImagePath),
             FXTutorialHandleVideoModel(videoURL5, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧", coverImg: coverImagePath),
             FXTutorialHandleVideoModel(videoURL6, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧", coverImg: coverImagePath),
             FXTutorialHandleVideoModel(videoURL7, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧", coverImg: coverImagePath),
             FXTutorialHandleVideoModel(videoURL8, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧", coverImg: coverImagePath),
             FXTutorialHandleVideoModel(videoURL9, text: "必须GET的奇妙画笔使用技巧 奇妙画笔使用技巧", coverImg: coverImagePath)]
            ))
        finish?()
    }
}
