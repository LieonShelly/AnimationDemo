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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            cell.titlelabel.text = "卡但是返回卡萨丁暗示法开始大富科技接口和水电费静安寺快递费卡还是短发看哈收到货熬枯受淡话费卡和第三方"
            return cell
        case .commonSkill(let rows):
            let cell = tableView.dequeueCell(FXTutoriaComonSkillVideoCell.self, for: indexPath)
            cell.configData(rows[indexPath.row])
            cell.titlelabel.text = "\(indexPath.section) - \(indexPath.row)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectonModel = viewModel.sections[indexPath.section]
        switch sectonModel {
        case .tutorilSkill(let rows):
            let model = rows[indexPath.row]
            if let videoUrl = model.videoURL {
                let imageWidth = UIScreen.main.bounds.width -  FXTutorialManulVideoHandleCell.UISize.playerHorizonInset * 2
                let imageHeight = FXTutorialHandleVideoListVC.playerHeight(videoUrl, relativeWidth: imageWidth)
                return FXTutorialManulVideoHandleCell.OtherUISize.titleTop +
                    FXTutorialManulVideoHandleCell.OtherUISize.playerTop +
                    FXTutorialManulVideoHandleCell.OtherUISize.playerBottom +
                    imageHeight
            }
        case .commonSkill(let rows):
            let model = rows[indexPath.row]
            if let videoUrl = model.videoURL {
                let imageWidth = UIScreen.main.bounds.width - FXTutoriaComonSkillVideoCell.UISize.playerHorizonInset * 2
                let imageHeight = FXTutorialHandleVideoListVC.playerHeight(videoUrl, relativeWidth: imageWidth)
                let containerH = imageHeight + FXTutoriaComonSkillVideoCell.OtherUISize.titleBgHeight
                return FXTutoriaComonSkillVideoCell.OtherUISize.containerTop +
                    containerH +
                    FXTutoriaComonSkillVideoCell.OtherUISize.containerBottom
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        let sectonModel = viewModel.sections[indexPath.section]
        switch sectonModel {
        case .tutorilSkill:
            return UITableView.automaticDimension
        case .commonSkill(let rows):
            let model = rows[indexPath.row]
            if let videoUrl = model.videoURL {
                let imageWidth = UIScreen.main.bounds.width - FXTutoriaComonSkillVideoCell.UISize.playerHorizonInset * 2
                let imageHeight = FXTutorialHandleVideoListVC.playerHeight(videoUrl, relativeWidth: imageWidth)
                let containerH = imageHeight + FXTutoriaComonSkillVideoCell.OtherUISize.titleBgHeight
                return FXTutoriaComonSkillVideoCell.OtherUISize.containerTop +
                    containerH +
                    FXTutoriaComonSkillVideoCell.OtherUISize.containerBottom
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooterView(FXTutorialVideoListHeader.self)
         let sectonModel = viewModel.sections[section]
         header.titlelabel.text = sectonModel.title
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = viewModel.sections[section]
        switch sectionModel {
        case .tutorilSkill:
            return 7
        default:
            break
        }
        return 0.0001
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
