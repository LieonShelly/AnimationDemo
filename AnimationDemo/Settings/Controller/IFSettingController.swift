//
//  IFSettingController.swift
//  InFace
//
//  Created by lieon on 2020/11/30.
//  Copyright © 2020 Pinguo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class IFSettingController: UIViewController {
    struct UISize {
        static let navTop: CGFloat = UIDevice.current.isiPhoneXSeries ? 44 : 24
        static let navH: CGFloat = 44
        static let vipH: CGFloat = 24 + 17 + 14 + 64 + 24
        static let notVipH: CGFloat = 24 + 64 + 24
        static let commonH: CGFloat = 56
        static let headerH: CGFloat = 210 - 24
        static let debugH: CGFloat = 56
    }
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.bounces = false
        return tableView
    }()
    fileprivate lazy var navBar: UIView = {
        let navBar = UIView()
        navBar.backgroundColor = .white
        return navBar
    }()
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_setting_back"), for: .normal)
        return btn
    }()
    fileprivate lazy var headerView: IFSettingHeaderView = {
        let headerView = IFSettingHeaderView()
        return headerView
    }()
    fileprivate let bag = DisposeBag()
    fileprivate let viewDidLoadInput = PublishSubject<Void>.init()
    lazy var  dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, IFSettingCellType>>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
        switch item {
        case .common(let data):
            let cell = tableView.dequeueCell(IFSettingCommonCell.self, for: indexPath)
            cell.config(data.icon, title: data.title, arrow: data.arrow, isHiddenLine: data.isHiddenLine)
            return cell
        case .vipOrNot(let vipStatus):
            let cell = tableView.dequeueCell(IFSettingVipStatusCell.self, for: indexPath)
            cell.config(vipStatus)
            return cell
        case .debug:
            break
        }
        return UITableViewCell()
    })
    convenience init(_ viewModel: IFSettingViewModel) {
        self.init()
        viewDidLoadInput.asObservable()
            .subscribe(onNext: {[weak self](_) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.configUI(viewModel)
                weakSelf.configVM(viewModel)
            })
            .disposed(by: bag)
        
        viewDidLoadInput.asObservable()
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadInput.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension IFSettingController {
    
    fileprivate func configUI(_ viewModel: IFSettingViewModel) {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.backgroundColor = .white
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UISize.headerH)
        tableView.tableHeaderView = headerView
        tableView.contentInset = UIEdgeInsets(top:  UISize.navH + UISize.navTop, left: 0, bottom: 0, right: 0)
        tableView.registerClassWithCell(IFSettingCommonCell.self)
        tableView.registerClassWithCell(IFSettingVipStatusCell.self)
        tableView.registerClassWithHeaderFooterView(IFSettingFooterView.self)
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(UISize.navH)
            $0.top.equalTo(UISize.navTop)
        }
        navBar.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(20)
        }
        closeBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
    
    fileprivate func configVM(_ viewModel: IFSettingViewModel) {
        
        viewModel.sectios
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}

extension IFSettingController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueHeaderFooterView(IFSettingFooterView.self)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section >= dataSource.sectionModels.count {
            return 0
        }
        let section = dataSource.sectionModels[indexPath.section]
        if indexPath.row >= section.items.count {
            return 0
        }
        let item = section.items[indexPath.row]
        switch item {
        case .common:
            return 56
        case .vipOrNot(let status):
            switch status {
            case .notVip:
                return 24 + 64 + 24
            case .vip:
                return 24 + 17 + 14 + 64 + 24
            }
        case .debug:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section >= dataSource.sectionModels.count {
            return 0
        }
        let sectionModel = dataSource.sectionModels[section]
        let items = sectionModel.items
        let vipCount = items.filter { $0.compareValue == IFSettingCellType.vipOrNot(.vip).compareValue}.count
        let notVipCount = items.filter { $0.compareValue == IFSettingCellType.vipOrNot(.notVip).compareValue}.count
        let debugCount = items.filter { $0.compareValue == IFSettingCellType.debug.compareValue}.count
        let commonCount = items.count - vipCount - notVipCount
        let minFooterH: CGFloat = 14 + 6 + 14 + 30 + 30
        var footerH = tableView.bounds.height
            - UISize.navTop
            - UISize.navH
            - UISize.headerH
            - UISize.commonH * CGFloat(commonCount)
            - UISize.vipH * CGFloat(vipCount)
            - UISize.notVipH * CGFloat(notVipCount)
            - UISize.debugH * CGFloat(debugCount)
        if footerH < minFooterH {
            footerH = minFooterH
        }
        return footerH
    }
}
