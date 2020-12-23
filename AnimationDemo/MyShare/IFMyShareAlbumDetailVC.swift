//
//  IFMyShareAlbumDetailVC.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IFMyShareAlbumDetailVC: UIViewController {
    struct UISize {
        static let navTop: CGFloat = UIDevice.current.isiPhoneXSeries ? 44 : 0
        static let navH: CGFloat = 44
    }
    fileprivate lazy var navBar: UIView = {
        let navBar = UIView()
        navBar.backgroundColor = .clear
        return navBar
    }()
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_myshare_back"), for: .normal)
        return btn
    }()
    fileprivate lazy var bgView: IFMyShareAlbumDetailBgView = {
        let bgView = IFMyShareAlbumDetailBgView()
        return bgView
    }()
    fileprivate let bag = DisposeBag()
    fileprivate lazy var timeView: IFMyShareAlbumDetailTimeLineView = {
        let view = IFMyShareAlbumDetailTimeLineView()
        return view
    }()
    fileprivate lazy var qrView: IFMyShareAlbumDetailQRView = {
        let qrView = IFMyShareAlbumDetailQRView()
        return qrView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

extension IFMyShareAlbumDetailVC {
    fileprivate func configUI() {
        view.addSubview(bgView)
        view.addSubview(navBar)
        bgView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        navBar.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(UISize.navH)
            $0.top.equalTo(UISize.navTop)
        }
        closeBtn
            .rx
            .tap
            .subscribe(onNext: {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.navigationController?.popViewController(animated: true)
                
            })
            .disposed(by: bag)
        navBar.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(20)
        }
        view.addSubview(timeView)
        timeView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(UIDevice.current.isiPhoneXSeries ? 21 : 6)
            $0.left.right.equalTo(0)
            $0.height.equalTo(52 + 20 + 22 + 1 + 17)
        }
        view.addSubview(qrView)
        qrView.snp.makeConstraints {
            $0.left.equalTo(27)
            $0.right.equalTo(-27)
            $0.top.equalTo(timeView.snp.bottom).offset(UIDevice.current.isiPhoneXSeries ? 33 : 23)
            $0.bottom.equalTo(UIDevice.current.isiPhoneXSeries ? -59 : -24)
        }
        // 分享按钮点击
        qrView.wechatBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                
                
            })
            .disposed(by: bag)
        
        timeView.config(30)
    }
}
