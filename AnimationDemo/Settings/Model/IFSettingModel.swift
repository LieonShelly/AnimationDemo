//
//  IFSettingModel.swift
//  InFace
//
//  Created by lieon on 2020/11/30.
//  Copyright © 2020 Pinguo. All rights reserved.
//

import Foundation
//import SimpleKeychain
import RxDataSources

enum IFSettingCellType {
    case vipOrNot(IFSettingVipStatus)
    case common(IFSettingCommonCellData)
    case debug
    
    var compareValue: String {
        switch self {
        case .vipOrNot(let status):
            switch status {
            case .notVip:
                return "notVip"
            case .vip:
                return "vip"
            }
        case .common:
            return "common"
        case .debug:
            return "debug"
        }
    }
}

//struct IFSettingSectionModel: SectionModel<String, IFSettingCellType> { }

struct IFSettingCommonCellData {
    var icon: UIImage
    var title: String
    var arrow: UIImage
    var isHiddenLine: Bool = false
}


enum IFSettingVipStatus {
    case vip
    case notVip
    
    var data: IFSettingVipStatusData {
        switch self {
        case .vip:
            return IFSettingVipStatusData.vipData
        case .notVip:
            return IFSettingVipStatusData.notVipData
        }
    }
}

struct IFSettingVipStatusData {
    var title: String
    var subTitle: String
    
    static var notVipData: IFSettingVipStatusData {
        let title = "立即成为VIP"//.localized(nil)
//        var subTitle: String {
//            let plan = IFManager.getABPlan(.level_vip_sideEntranceTip).pid
//            switch plan {
//            case .plan_vip_sideEntranceTip0:
//                return "解锁全部功能".localized(nil)
//            case .plan_vip_sideEntranceTip1:
//                return "畅享所有功能".localized(nil)
//            case .plan_vip_sideEntranceTip2:
//                return "试用全部功能".localized(nil)
//            default:
//                return A0SimpleKeychain().string(forKey: "iap_product_id") == nil ?
//                    "免费试用3天".localized(nil)
//                    :
//                    "解锁全部功能".localized(nil)
//            }
//        }
        let data = IFSettingVipStatusData(title: title, subTitle:  "免费试用3天")
        return data
    }
    
    static var vipData: IFSettingVipStatusData {
//        let title = "欢迎您，Inface Vip".localized(nil)
//        let vipByTheTime = "  \("尽情享受全部功能与素材".localized())\n  \("有效期至：".localized())" + "2019年12月31号"
        let data = IFSettingVipStatusData(title: "欢迎你，VIP用户", subTitle: "尽情享受全部功能与素材  有效期至:2019年12月31号")
        return data
    }
}
