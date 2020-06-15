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
    fileprivate lazy var tableViewBg: BlurImageView = {
        let view = BlurImageView()
        view.visualEffectView.tint(UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 37 / 255.0, alpha: 1), blurRadius: 20, colorTintAlpha: 0.8)
        return view
    }()
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
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
        tableView.estimatedRowHeight = 200
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
            var videoURL: URL?
            guard let model = viewModel.sections.first else {
                return
            }
            switch model {
            case .commonSkill(let models):
                videoURL = models.first?.videoURL
            case .tutorilSkill(let models):
                videoURL = models.first?.videoURL
            }
            if let videoUrl = videoURL {
                FXVideoCoverGenerator.shared.generateThumbnailForVideo(videoUrl, maximumSize: self!.view.bounds.size) { (image, url) in
                    if videoUrl.absoluteString == url.absoluteString {
                        self?.tableViewBg.image = image
                    }
                }
            }
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
            cell.configData(rows[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooterView(FXTutorialVideoListHeader.self)
         let sectonModel = viewModel.sections[section]
         header.titlelabel.text = sectonModel.title
        switch sectonModel {
        case .tutorilSkill:
            header.titlelabel.snp.updateConstraints {
                $0.bottom.top.equalTo(0)
            }
            header.contentView.layoutIfNeeded()
        case .commonSkill:
            header.titlelabel.snp.updateConstraints {
                $0.top.equalTo(36 * 0.5)
                $0.bottom.equalTo(-20 * 0.5)
            }
            header.contentView.layoutIfNeeded()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectonModel = viewModel.sections[section]
        switch sectonModel {
        case .tutorilSkill:
            return 22
        case .commonSkill:
            return 36 * 0.5 + 22 + 20 * 0.5
        }
    }
    
    
    /// 计算视频的高度 
    static func playerHeight(_ videoURL: URL, relativeWidth: CGFloat) -> CGFloat {
        let idealImageSize = FXVideoCoverGenerator.shared.getVideoSize(videoURL)
        if idealImageSize.width == 0 || idealImageSize.height == 0 {
            return 0
        }
        let realImageHeight = relativeWidth * idealImageSize.height / idealImageSize.width
        return realImageHeight
    }
}
