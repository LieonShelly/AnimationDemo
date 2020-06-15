//
//  FXTutorialHandleVideoListVC.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FXTutorialHandleVideoListVC: UIViewController {
    fileprivate lazy var tableViewBg: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()
    fileprivate lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.backgroundColor = .blue
        return closeBtn
    }()
    fileprivate var viewModel: FXTutorialHandleVideoListVM!
    
    convenience init(_ viewModel: FXTutorialHandleVideoListVM) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configVM(viewModel)
    }
    
}

extension FXTutorialHandleVideoListVC {
    fileprivate func configUI() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(closeBtn)
        tableView.snp.makeConstraints{
            $0.edges.equalTo(0)
        }
        closeBtn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.left.equalTo(20 - 7)
            $0.top.equalTo(37)
        }
        tableViewBg.backgroundColor = .black
        tableViewBg.frame = view.bounds
        tableView.backgroundView = tableViewBg
        tableView.dataSource = self
        tableView.registerClassWithCell(FXTutorialManulVideoHandleCell.self)
        tableView.registerClassWithCell(FXTutoriaComonSkillVideoCell.self)
        tableView.registerClassWithHeaderFooterView(FXTutorialVideoListHeader.self)
    }
    
    fileprivate func configVM(_ viewModel: FXTutorialHandleVideoListVM) {
        self.viewModel.configData {[weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension FXTutorialHandleVideoListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectonModel = viewModel.sections[indexPath.section]
        switch sectonModel {
        case .tutorilSkill(let rows):
            let cell = tableView.dequeueCell(FXTutorialManulVideoHandleCell.self, for: indexPath)
            cell.configData(rows[indexPath.row])
            return cell
        case .commonSkill(let rows):
            let cell = tableView.dequeueCell(FXTutoriaComonSkillVideoCell.self, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectonModel = viewModel.sections[indexPath.section]
        return UITableView.automaticDimension
    }
    
    
    /// 计算视频的高度
    /// - Parameters:
    ///   - relativeWidth: 相对宽度
    /// - Returns: 等比的相对高度
    static func playerHeight(_ videoURL: URL, relativeWidth: CGFloat) -> CGFloat {
        let idealImageSize = FXVideoCoverGenerator.shared.getVideoSize(videoURL)
        if idealImageSize.width == 0 || idealImageSize.height == 0 {
            return 0
        }
        let realImageHeight = relativeWidth * idealImageSize.height / idealImageSize.width
        return realImageHeight
    }
}
