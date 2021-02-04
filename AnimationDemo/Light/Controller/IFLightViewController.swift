//
//  IFLightViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/3.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class IFLightViewController: UIViewController {
    struct Test {
       static let apiURL: String = "http://bmall-qa.camera360.com/api/inface/3dlight?UTCOffset=25200&appName=inface&appVersion=3.0.0&appVersionCode=300&appkey=uku4m1rw5yno8ms4&appname=inface&appversion=3.0.0&channel=appstore&device=iPhone72&deviceId=41C4A6F2-E4E0-467C-B5F6-D52CC4494670&geoinfo=0.0000000.000000&initStamp=0.000000&latitude=0&localTime=1563958923.756093&locale=zh&longitude=0&mcc=510&mnc=11&platform=ios&sig=2d42e4ef41bd40c0fd9c59f7d2a3ee47&systemVersion=12.3.1&timeZone=Asia/Jakarta"
    }
    fileprivate let bag = DisposeBag()
    fileprivate lazy var toolbar: MenuCommonToolbarView = {
        let view = MenuCommonToolbarView()
        return view
    }()
    fileprivate lazy var contentView: MenuCommonContentView = {
        let view = MenuCommonContentView()
        return view
    }()
    fileprivate lazy var titleCateView: MennuCommonTitleCategoryView = {
        let view = MennuCommonTitleCategoryView()
        return view
    }()
    fileprivate lazy var bottomView: MenuCommonBottomView = {
        let view = MenuCommonBottomView()
        return view
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    fileprivate lazy var lists: [IFLightMenuSectionType] = []
    fileprivate var materialData: Material?
    fileprivate let origin = IFLightMennuOriginCellData(icon: UIImage(named: "girl0")!, title: "原图")
    fileprivate let custom = IFLightMennuOriginCellData(icon: UIImage(named: "girl0")!, title: "自定义")
    let transition = RevealAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configData()
      
    }
    
    fileprivate func configUI() {
        view.backgroundColor = .gray
        view.addSubview(toolbar)
        view.addSubview(contentView)
        contentView.addSubview(titleCateView)
        contentView.addSubview(bottomView)
        contentView.addSubview(collectionView)
        bottomView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(50)
            $0.bottom.equalTo(-UIDevice.current.safeAreaInsets.bottom)
        }
        collectionView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(80)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        titleCateView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(40)
            $0.bottom.equalTo(collectionView.snp.top)
            $0.top.equalTo(0)
        }
        toolbar.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(50)
            $0.bottom.equalTo(contentView.snp.top)
        }
        contentView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
        }
        
        collectionView.registerClassWithCell(MenuCommonPicTitleCell.self)
        collectionView.registerClassWithCell(MenuLightCustomCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        titleCateView.selectedAction = {[weak self] index in
            guard let weakSelf = self else {
                return
            }
            guard let cates = weakSelf.materialData?.categories, !cates.isEmpty, let pkgs = weakSelf.materialData?.packages, let items = weakSelf.materialData?.items else {
                return
            }
            let firstCate = cates[index]
            guard let firstPkgs = firstCate.packages else {
                return
            }
            let currentPks = pkgs.filter { firstPkgs.contains($0.packageID ?? "")}
            var allItems: [IFLightMenuSectionType] = []
            for pkg in currentPks where pkg.items != nil {
               let currentItems = items.filter { (item) -> Bool in
                    guard let itemId = item.itemID else {
                        return false
                    }
                    return pkg.items!.contains(itemId)
                }
                allItems.append(.recommend(currentItems))
            }
            weakSelf.lists.removeAll()
            weakSelf.lists.append(.origin([weakSelf.origin]))
            weakSelf.lists.append(.custom([weakSelf.custom]))
            weakSelf.lists.append(contentsOf: allItems)
            weakSelf.collectionView.reloadData()
            weakSelf.bottomView.config(cates[index].categoryName ?? "")
        }
    }
    
    fileprivate func configData() {
        lists.append(.origin([origin]))
        lists.append(.custom([custom]))
        URLSession.shared.rx.data(request: URLRequest(url: URL(string: Test.apiURL)!))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self]data in
                guard let weakSelf = self else {
                    return
                }
                let decoder = JSONDecoder()
                guard let response = try? decoder.decode(MaterialResponse<Material>.self, from: data) else {
                    return
                }
                guard let cates = response.data?.categories, !cates.isEmpty, let pkgs = response.data?.packages, let items = response.data?.items else {
                    return
                }
                let cateTitls = cates.map { $0.categoryName ?? "" }
                let firstCate = cates[0]
                guard let firstPkgs = firstCate.packages else {
                    return
                }
                let currentPks = pkgs.filter { firstPkgs.contains($0.packageID ?? "")}
                for pkg in currentPks where pkg.items != nil {
                   let currentItems = items.filter { (item) -> Bool in
                        guard let itemId = item.itemID else {
                            return false
                        }
                        return pkg.items!.contains(itemId)
                    }
                    weakSelf.lists.append(.recommend(currentItems))
                }
                weakSelf.titleCateView.config(cateTitls)
                weakSelf.collectionView.reloadData()
                weakSelf.bottomView.config(cateTitls.first ?? "")
                weakSelf.materialData = response.data
            })
            .disposed(by: bag)
    }
    
}

extension IFLightViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = lists[section]
        return sectionType.sections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = lists[indexPath.section]
        switch data {
        case .origin(let entity):
            let cell = collectionView.dequeueCell(MenuCommonPicTitleCell.self, for: indexPath)
            cell.icon.image = entity[indexPath.item].icon
            cell.titleLabel.text = entity[indexPath.item].title
            return cell
        case .custom(let entity):
            let cell = collectionView.dequeueCell(MenuLightCustomCell.self, for: indexPath)
            cell.icon.image = entity[indexPath.item].icon
            cell.titleLabel.text = entity[indexPath.item].title
            return cell
        case .recommend(let entity):
            let cell = collectionView.dequeueCell(MenuCommonPicTitleCell.self, for: indexPath)
            cell.icon.kf.setImage(with: URL(string: entity[indexPath.item].itemIcon!)!)
            cell.titleLabel.text = entity[indexPath.item].itemName
            return cell
        }
    }
}

extension IFLightViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = lists[indexPath.section]
        switch sectionType {
        case .origin(let entity):
            print("原图点击")
        case .custom(let entity):
            print("自定义点击")
        case .recommend(let entitys):
            print("在线预设点击")
            let entity = entitys[indexPath.row]
            if entity.isLocal {
                
            } else {
                
            }
        }
        let paramVC = IFLightParamViewController()
        navigationController?.delegate = self
        navigationController?.pushViewController(paramVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
    
}


extension IFLightViewController: UINavigationControllerDelegate {
  func navigationController(_
    navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) ->
    UIViewControllerAnimatedTransitioning? {
      transition.operation = operation
      return transition
  }
}


class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {

  let animationDuration = 0.25
  var operation: UINavigationController.Operation = .push

  weak var storedContext: UIViewControllerContextTransitioning?

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    storedContext = transitionContext
    if let toVC = transitionContext.viewController(forKey: .to) {
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
    }
    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
  }
}
