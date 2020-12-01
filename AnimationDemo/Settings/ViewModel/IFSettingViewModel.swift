//
//  IFSettingViewModel.swift
//  InFace
//
//  Created by lieon on 2020/11/30.
//  Copyright © 2020 Pinguo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class IFSettingViewModel {
    // input
    let viewDidLoad: PublishSubject<Void> = .init()
    // output
    let sectios: Driver<[SectionModel<String, IFSettingCellType>]>
    
    init() {
        //        let commonSettings: [IFSettingCellType] = [.common(IFSettingCommonCellData(icon: UIImage(named: "ic_settings_zpzl")!, title: "帮助反馈".localized(nil), arrow: UIImage(named: "ic_setting_arrow")!)),
        //                                                   .common(IFSettingCommonCellData(icon: UIImage(named: "ic_settings_hf")!, title: "恢复会员".localized(nil), arrow: UIImage(named: "ic_setting_arrow")!)),
        //                                                   .common(IFSettingCommonCellData(icon: UIImage(named: "ic_settings_zpzl")!, title: "照片质量设置".localized(nil), arrow: UIImage(named: "ic_setting_arrow")!))]
        //
        //        let vipStatus: IFSettingCellType = PSIAPStore.shared().vip.subscribeStatus == .valid ? .vipOrNot(IFSettingVipStatus.vip): .vipOrNot(IFSettingVipStatus.notVip)
        //        var items = [IFSettingCellType]()
        //        items.append(vipStatus)
        //        items.append(contentsOf: commonSettings)
                let commonSettings: [IFSettingCellType] = [.common(IFSettingCommonCellData(icon: UIImage(named: "ic_setting_bz")!, title: "帮助反馈", arrow: UIImage(named: "ic_setting_arrow")!)),
                                                           .common(IFSettingCommonCellData(icon: UIImage(named: "ic_settings_hf")!, title: "恢复会员", arrow: UIImage(named: "ic_setting_arrow")!)),
                                                           .common(IFSettingCommonCellData(icon: UIImage(named: "ic_settings_zpzl")!, title: "照片质量设置", arrow: UIImage(named: "ic_setting_arrow")!, isHiddenLine: true))]
                
        //        let vipStatus: IFSettingCellType = PSIAPStore.shared().vip.subscribeStatus == .valid ? .vipOrNot(IFSettingVipStatus.vip): .vipOrNot(IFSettingVipStatus.notVip)
                
        var items = [IFSettingCellType]()
        items.append(.vipOrNot(.vip))
        items.append(contentsOf: commonSettings)
        let section = SectionModel<String, IFSettingCellType>(model: "", items: items)
        
        sectios = viewDidLoad.asObservable()
            .map { [section] }
            .asDriver(onErrorJustReturn: [])

        
    }
    
}
