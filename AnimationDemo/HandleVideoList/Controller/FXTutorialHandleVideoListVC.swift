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
    struct UISize {
        static let closeTop: CGFloat = 37
        static let closeBtnHeight: CGFloat = 30
        static let closeBtnLeft: CGFloat = 20 - 7
        static let navbarH: CGFloat = UIDevice.current.isiPhoneXSeries ? 81 : 64
        static let closeBtnBottom: CGFloat = 10
        static let tabInsetTop: CGFloat = UIDevice.current.isiPhoneXSeries ? closeTop + closeBtnHeight - 8: closeTop + closeBtnHeight - 25
        static let tabInsetbottom: CGFloat = 46
    }
    fileprivate let bag = DisposeBag()
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "进阶技巧"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.customFont(ofSize: 18, isBold: false)
        return titleLabel
    }()
    fileprivate lazy var navbar: VisualEffectView = {
        let blurBg = VisualEffectView()
        blurBg.blurRadius = 20.fitiPhone5sSerires
        blurBg.colorTint = UIColor.black.withAlphaComponent(0.45)
        blurBg.colorTintAlpha = 1
        return blurBg
    }()
    fileprivate lazy var tableViewBg: BlurImageView = {
        let view = BlurImageView()
        view.visualEffectView.tint(UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 37 / 255.0, alpha: 1), blurRadius: 20, colorTintAlpha: 0.75)
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
        closeBtn.setImage(UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_tutorial_video_cancel@3x")), for: .normal)
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
        view.addSubview(navbar)
        view.addSubview(closeBtn)
        view.addSubview(titleLabel)
        tableView.snp.makeConstraints{
            $0.edges.equalTo(0)
        }
        closeBtn.rx.tap
            .subscribe(onNext: {[weak self] (_) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
        navbar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: UISize.navbarH)
        closeBtn.snp.makeConstraints {
            $0.left.equalTo(UISize.closeBtnLeft)
            $0.size.equalTo(CGSize(width: UISize.closeBtnHeight, height: UISize.closeBtnHeight))
            $0.bottom.equalTo(navbar.snp.bottom).offset(-UISize.closeBtnBottom)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(closeBtn.snp.centerY)
        }
        tableView.contentInset = UIEdgeInsets(top: UISize.tabInsetTop, left: 0, bottom: UISize.tabInsetbottom, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -UISize.tabInsetTop)
        tableViewBg.backgroundColor = .black
        tableViewBg.frame = view.bounds
        tableView.backgroundView = tableViewBg
        tableView.dataSource = self
        tableView.registerClassWithCell(FXTutorialManulVideoHandleCell.self)
        tableView.registerClassWithCell(FXTutoriaComonSkillVideoCell.self)
        tableView.registerClassWithHeaderFooterView(FXTutorialVideoListHeader.self)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
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
            return 5 * 0.5 + 22 + 20 * 0.5
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = viewModel.sections[section]
        switch sectionModel {
        case .tutorilSkill:
            return 16
        default:
            break
        }
        return 0.0001
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var alpha = scrollView.contentOffset.y * 1 / UISize.navbarH + (UISize.tabInsetTop) / UISize.navbarH
        alpha = alpha >= 1 ? 1 : alpha
        print(alpha)
        navbar.alpha = alpha
        titleLabel.alpha = alpha
        navbar.blurRadius = 20 * alpha
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
