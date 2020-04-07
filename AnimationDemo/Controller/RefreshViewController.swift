//
//  RefreshViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/31.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh

class RefreshViewController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    fileprivate lazy var aniamteView: UIView = {
        let aniamteView = UIView()
        aniamteView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        return aniamteView
    }()
    fileprivate var currentAnimateCell: ContrastCell?
    fileprivate lazy var models: [CellEntity] = {
        var models: [CellEntity] = []
         models.append(CellEntity(false))
         models.append(CellEntity(true))
         models.append(CellEntity(false))
        for _ in (0 ... 100) {
            models.append(CellEntity(true))
        }
        return models
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        tableView.registerClassWithCell(ContrastCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_header = IFRefreshHeader(refreshingBlock: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.tableView.mj_header?.endRefreshing()
            }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cells = tableView.visibleCells
        for cell in cells {
            (cell as? ContrastCell)?.contrastView.startAnimation(with: .leftToRightSlash)
        }
    }
}

extension RefreshViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ContrastCell.self, for: indexPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollingCellOutScreen()
    }
    
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
//            handleScrollPlay()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//         handleScrollPlay()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && currentAnimateCell == nil {
            self.currentAnimateCell = cell as? ContrastCell
        }
    }
    
}

extension RefreshViewController {
    /// 获取当前距离有效区域中心点最近的cell
    fileprivate func getMinCenterCell() -> UITableViewCell? {
        var minDelat = CGFloat.infinity
        let screenCenterY = aniamteView.frame.midY
        var minCell: UITableViewCell?
        for cell in self.tableView.visibleCells where cell is ContrastCell {
            let cellCenter = CGPoint(x: cell.frame.origin.x, y: cell.frame.size.height * 0.5 + cell.frame.origin.y)
            guard let coorPoint = cell.superview?.convert(cellCenter, to: nil) else {
                continue
            }
            let detaTemp = abs(coorPoint.y - screenCenterY)
            if detaTemp < minDelat {
                minCell = cell
                minDelat = detaTemp
            }
        }
        return minCell
    }
    
    /// 处理滑动停止时，播放动效
    fileprivate func handleScrollPlay() {
        let minCell = getMinCenterCell()
        guard let cell = minCell as? ContrastCell, currentAnimateCell != cell else {
            return
        }
        if currentAnimateCell != nil {
            currentAnimateCell?.contrastView.shoulRepeatAniamtion(false)
        }
         cell.contrastView.startAnimation(with: .staticLeftRight)
        currentAnimateCell = cell
    }
    
    fileprivate func handleScrollingCellOutScreen() {
        guard let currentAnimateCell = currentAnimateCell else {
            return
        }
        //当前显示区域内容
        let visiableContentZone = aniamteView.frame
        let velocityY = tableView.panGestureRecognizer.velocity(in: view).y
        
        // 向上滚动， 底部的点Y小于x有效区域的maxY ，则认为当前cel离开了有效区域, 那么就替换为新的cell为 currentAnimateCell, 新的cell是 currentAnimateCell的下一g个cell
        if velocityY < 0 {
            let playingCellFrame = currentAnimateCell.frame
            let cellBottomPoint = CGPoint(x: playingCellFrame.origin.x, y: playingCellFrame.size.height + playingCellFrame.origin.y)
            // 坐标系转换（转换到 window坐标）
            guard  let coorPoint = currentAnimateCell.superview?.convert(cellBottomPoint, to: nil) else {
                return
            }
            if coorPoint.y <= visiableContentZone.maxY {
                currentAnimateCell.contrastView.shoulRepeatAniamtion(false)
                guard let currentIndexPath = tableView.indexPath(for: currentAnimateCell) else {
                    return
                }
                self.currentAnimateCell = tableView.cellForRow(at: IndexPath(row: currentIndexPath.row + 1, section: currentIndexPath.section)) as? ContrastCell
                self.currentAnimateCell?.contrastView.startAnimation(with: .easeInEaseOut)
            } else {
                
            }
        } else if velocityY > 0 {  // 向下滚动， 顶部的点Y小于x有效区域的minY时，则认为当前cel离开了有效区域
            let playingCellFrame = currentAnimateCell.frame
            let orginPoint = CGPoint(x: playingCellFrame.origin.x, y: playingCellFrame.origin.y)
            guard let coorPoint = currentAnimateCell.superview?.convert(orginPoint, to: nil) else {
                return
            }
            if coorPoint.y >= visiableContentZone.minY {
                  currentAnimateCell.contrastView.shoulRepeatAniamtion(false)
                guard let currentIndexPath = tableView.indexPath(for: currentAnimateCell) else {
                    return
                }
                self.currentAnimateCell = tableView.cellForRow(at: IndexPath(row: currentIndexPath.row - 1, section: currentIndexPath.section)) as? ContrastCell
                self.currentAnimateCell?.contrastView.startAnimation(with: .easeInEaseOut)
            } else {
                
            }
        }
        
    }
    
    // 当前播放的动效的cell是否划出屏幕
    func playingCellIsInContentZone() -> Bool {
        guard let currentAnimateCell = currentAnimateCell else {
            return false
        }
        //当前显示区域内容
        let visiableContentZone = aniamteView.frame
        let velocityY = tableView.panGestureRecognizer.velocity(in: view).y
        
        // 向上滚动， 底部的点Y小于x有效区域的minY
        if velocityY < 0 {
            let playingCellFrame = currentAnimateCell.frame
            let cellBottomPoint = CGPoint(x: playingCellFrame.origin.x, y: playingCellFrame.size.height + playingCellFrame.origin.y)
            // 坐标系转换（转换到 window坐标）
            guard  let coorPoint = currentAnimateCell.superview?.convert(cellBottomPoint, to: nil) else {
                return false
            }
            return coorPoint.y <= visiableContentZone.minY
        } else if velocityY > 0 {  // 向下滚动， 顶部的点Y小于x有效区域的maxY
            let playingCellFrame = currentAnimateCell.frame
            let orginPoint = CGPoint(x: playingCellFrame.origin.x, y: playingCellFrame.origin.y)
            guard let coorPoint = currentAnimateCell.superview?.convert(orginPoint, to: nil) else {
                return false
            }
            return coorPoint.y >= visiableContentZone.maxY
        } else {
            return false
        }
    }
}

/**
同学们，从上周的打卡记录来看，发现大家健身打卡的积极性不是很高，可能是由于是疫情过后的第一周打卡，大家还没有及时调整过来，所以决定上周的健身打卡就作为我们健身打卡的热身周，从本周正式开始算每天的打卡记录，大家觉得这样可行不？
 */
class CellEntity {
    var isShowContranstView: Bool
    
    init(_ isShowContranstView: Bool) {
        self.isShowContranstView = isShowContranstView
    }
}

class ContrastCell: UITableViewCell {
  lazy var contrastView: FXTutorialImageContrastView = FXTutorialImageContrastView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contrastView)
        contrastView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.bottom.equalTo(-5)
            $0.top.equalTo(5)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contrastView.prepareForReuse()
    }

}
