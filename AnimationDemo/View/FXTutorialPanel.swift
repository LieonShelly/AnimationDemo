//
//  FXTutorialPanel.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/12.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

extension UIDevice {
    
    var isBelowOrEqual375Device: Bool {
        return UIScreen.main.bounds.width <= 375.0
    }
    
    var isiPhoneXSeries: Bool {
        if self.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return false
        }
        if #available(iOS 11.0, *) {
            guard let mainWindow = UIApplication.shared.keyWindow  else {
                return false
            }
            if mainWindow.safeAreaInsets.bottom > 0.0 {
                return true
            }
        }
        return false
    }
    
    var safeAreaInsets: UIEdgeInsets {
        if self.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return .zero
        }
        if #available(iOS 11.0, *) {
            guard let mainWindow = UIApplication.shared.keyWindow  else {
                return .zero
            }
            return mainWindow.safeAreaInsets
        }
        return .zero
    }
}

class HandleView: UIView {
    
}

class FXTutorialPanel: UIView {
    struct UISzie {
        static let handleViewMaxHeight: CGFloat = 300
        static let handleViewMinHeight: CGFloat = 64 + UIDevice.current.safeAreaInsets.top
    }
    let bag = DisposeBag()
    fileprivate lazy var clearView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate lazy var handleView: HandleView = {
        let view = HandleView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
    
    static func show() {
        let view = FXTutorialPanel()
        view.frame = keyWindow.bounds
        view.backgroundColor = .clear
        keyWindow.addSubview(view)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let handlePoint = handleView.convert(point, from: self)
        if handleView.point(inside: handlePoint, with: event) {
            return handleView
        }
        return nil
    }

}

extension FXTutorialPanel {
    fileprivate func configUI() {
        addSubview(clearView)
        addSubview(handleView)
        let tap = UITapGestureRecognizer()
        handleView.isUserInteractionEnabled = true
        handleView.addGestureRecognizer(tap)
        var isExpand: Bool = true
        tap.rx.event
            .subscribe(onNext: { (_) in
                self.showHadleView(isExpand)
                isExpand = !isExpand
            })
            .disposed(by: bag)
        handleView.snp.makeConstraints {
            $0.top.left.right.equalTo(0)
            $0.height.equalTo(UISzie.handleViewMaxHeight)
        }
        clearView.snp.makeConstraints {
            $0.left.bottom.right.equalTo(0)
            $0.top.equalTo(handleView.snp.bottom)
        }
    }
    
    fileprivate func showHadleView(_ isExpand: Bool = true) {
        handleView.snp.updateConstraints {
            $0.height.equalTo(isExpand ? UISzie.handleViewMaxHeight : UISzie.handleViewMinHeight)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}
