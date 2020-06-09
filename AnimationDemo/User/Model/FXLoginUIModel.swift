//
//  FXLoginUIModel.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/5/28.
//

import RxSwift
import RxCocoa

struct FXLoginUIModel {
    var title: String?
    var placeHolder: String?
    let textInput: BehaviorRelay<String?> = .init(value: nil)
    let btnTap: PublishSubject<Void> = .init()
    let isEnable: BehaviorRelay<Bool> = .init(value: true)
    
}

enum FXLoginTableData {
    case title
    case account(FXLoginUIModel)
    case password(FXLoginUIModel)
    case loginBtn(FXLoginUIModel)
}
