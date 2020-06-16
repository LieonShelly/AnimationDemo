//
//  FXTutorialHandleVideoListModel.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation


class FXTutorialHandleVideoModel {
    enum PlayerStatus {
        case pause(Double)
        case inProgress(Double)
        case idle
        
        var progress: Double {
            switch self {
            case .pause(let value):
                return value
            case .inProgress(let value):
                return value
            case .idle:
                return 0
            }
        }
    }
    var videoURL: URL?
    var text: String?
    var status: PlayerStatus = .inProgress(0.5)
    var coverImg: String?
    
    init(_ videoURL: URL? = nil, text: String? = nil, coverImg: String? = nil) {
        self.videoURL = videoURL
        self.text = text
        self.coverImg = coverImg
    }
}

enum FXTutorialHandleVideoListUIType {
    case tutorilSkill([FXTutorialHandleVideoModel])
    case commonSkill([FXTutorialHandleVideoModel])
    
    var dataCount: Int {
        switch self {
        case .tutorilSkill(let models):
            return models.count
        case .commonSkill(let models):
            return models.count
        }
    }
    
    var title: String {
        switch self {
        case .tutorilSkill:
            return "教程技巧"
        case .commonSkill:
            return "通用技巧"
        }
    }
}
