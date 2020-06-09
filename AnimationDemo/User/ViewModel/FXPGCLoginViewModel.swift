//
//  FXPGCLoginViewModel.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/5/28.
//

import RxSwift
import RxCocoa
import RxDataSources

class FXPGCLoginViewModel {
    let bag = DisposeBag()
    struct Input {
        let viewDidLoad: PublishSubject<Void> = .init()
        let loginBtnTap: PublishSubject<Void> = .init()
    }
    struct Output {
        let rows: Driver<[SectionModel<String, FXLoginTableData>]>
    }
    
    func transform(input: Input) -> Output {
        var accountUI = FXLoginUIModel()
        accountUI.placeHolder = "请输入手机号"
        accountUI.title = "手机号"
        
        var passwordUI = FXLoginUIModel()
        passwordUI.placeHolder = "请输入密码"
        passwordUI.title = "密码"
        
        let btnUI = FXLoginUIModel()
        Observable.combineLatest(accountUI.textInput.asObservable(), passwordUI.textInput.asObservable()) { (accoount, password) ->  Bool in
            guard let account = accoount, let password = password else {
                return false
            }
            return account.count >= 11 && password.count > 4
        }.bind(to: btnUI.isEnable)
            .disposed(by: bag)

        let datas = input.viewDidLoad
            .map { [SectionModel<String, FXLoginTableData>(model: "", items: [FXLoginTableData.title, .account(accountUI), .password(passwordUI), .loginBtn(btnUI)] )] }
            .asDriver(onErrorJustReturn: [])
        
        input.loginBtnTap
            .asObservable()
            .map { (accountUI.textInput.value, passwordUI.textInput.value)}
            .filter { $0.0 != nil && $0.1 != nil }
        
        return Output(rows: datas)
    }
    
    deinit {
        debugPrint("deinit - FXPGCLoginViewModel")
    }

}
