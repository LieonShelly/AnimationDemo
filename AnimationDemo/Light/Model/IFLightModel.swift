//
//  IFLightModel.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/3.
//  Copyright © 2021 lieon. All rights reserved.
//

import Foundation

enum IFLightMenuCellType {
    case origin(IFLightMennuOriginCellData)
    case custom(IFLightMennuOriginCellData)
    case recommend(IFLightMennuRecommendCellData)
}

struct IFLightMennuRecommendCellData {
    var iconURL: String?
    var title: String
}

struct IFLightMennuOriginCellData {
    var icon: UIImage
    var title: String
}
