//
//  HomeViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var items: [ListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }
}

extension HomeViewController {
    
    fileprivate func setupUI() {
        title = "动画列表"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassWithCell(UITableViewCell.self) //
        let expandView  = ListItem("ExpandViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = ExpandViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let refresh = ListItem("RefreshViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = RefreshViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        
        let image = ListItem("FXTutorialImageContrastVC", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = FXTutorialImageContrastVC()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let icon = ListItem("IConViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = IConViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let tap = ListItem("点击类", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = TapAnimationViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let pinch = ListItem("捏合类", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = PinchViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let move = ListItem("移动类", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = PanViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let flip = ListItem("VC翻转类", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = FlipViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let input = ListItem("多语言文本输入框", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            MultiLanguageTexInputAlert.show(weakSelf)
        })
        let pop = ListItem("提示气泡", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = TipPopViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let test = ListItem("测试控制器", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = TestViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let btn = ListItem("按钮类", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = BtnViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        
        let press = ListItem("长按放大图片", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = LongPressViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let touch = ListItem("互动教程模拟", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = DemoTouchViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let record = ListItem("ScreenRecordViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = ScreenRecordViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let banner = ListItem("Banner", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = BannerViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let progress = ListItem("SLider", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = ProgressViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let BLur = ListItem("BLur", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = FlurViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let customViewController = ListItem("CustomViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = CustomViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let btnProgressViewController = ListItem("ProgressBtn", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = BtnProgressViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        
        let playerViewController = ListItem("player", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = PlayerViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let swipeViewController = ListItem("Swipe", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = SwipeViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let scaleBtnViewController = ListItem("ScaleBtnViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = ScaleBtnViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let loadingVC = ListItem("Laoding", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = LoadingViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let iAPViewController = ListItem("IAPViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = IAPViewController()
            vcc.modalPresentationStyle = .fullScreen
            weakSelf.present(vcc, animated: true, completion: nil)
        })
        let newAnimatedViewController = ListItem("NewAnimatedViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = NewAnimatedViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        /// HookViewController
        let hookViewController = ListItem("HookViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = HookViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        // ImagePickerViewController
        let picker = ListItem("ImagePickerViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = ImagePickerViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        //GradientBtnVC
        let gradient = ListItem("GradientBtnVC", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = GradientBtnVC()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        // FXPGCLoginViewController
        let loginVC = ListItem("FXPGCLoginViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = FXPGCLoginViewController(FXPGCLoginViewModel())
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        // GradientBorderVc
        let gvc = ListItem("GradientBorderVc", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = GradientBorderVc()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        // FXUploadAlerTestVC
        let alert = ListItem("FXUploadAlerTestVC", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = FXUploadAlerTestVC()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let videoList = ListItem("videoList", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let videoPath = Bundle.main.path(forResource: "video_vip_headerView_x.mp4", ofType: nil)
            let videoURL = URL(fileURLWithPath: videoPath ?? "")
            let inputModel = FXTutorialHandleVideoModel(videoURL, text: "阿士大夫就水电费阿萨德鼓风机阿士大夫")
            let vm = FXTutorialHandleVideoListVM(inputModel)
            let vcc = FXTutorialHandleVideoListVC(vm)
            vcc.modalPresentationStyle = .fullScreen
            weakSelf.present(vcc, animated: true, completion: nil)
        })
        let card = ListItem("CardViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = CardViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        // SegmentVC
        let segmentVC = ListItem("SegmentVC", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = SegmentVC()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        // PageViewController
        let pageVc = ListItem("PageViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = PageViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        // StickerCrossViewController
        let crossVC = ListItem("StickerCrossViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = StickerCrossViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        // FX3dLightVC
        let r3dLightVC = ListItem("FX3dLightVC", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = FX3dLightVC()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let maskViewController = ListItem("MaskViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = MaskViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        //
        let settingVC = ListItem("IFSettingController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = IFSettingController(IFSettingViewModel())
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        
        let shareVC = ListItem("IFMyShareAlbumDetailVC", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = IFMyShareAlbumDetailVC()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let emptyVC = ListItem("EmptyViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = EmptyViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        
        let clipVC = ListItem("ClipViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = ClipViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        
        let triangleVC = ListItem("TriangleViewController", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = TriangleViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let freeAlert = ListItem("freeAlert", handler: { [weak self] in
            let vcc = IFFreeChanceAlert()
            vcc.display(willShow: nil, didShow: nil, willDismiss: nil, didDismiss: nil)
        })
        let resultAlert = ListItem("resultAlert", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = IFFreeChanceSuccessAlert()
            vcc.display(willShow: nil, didShow: nil, willDismiss: nil, didDismiss: nil)
        })
        items.append(freeAlert)
        items.append(resultAlert)
        items.append(triangleVC)
        items.append(clipVC)
        items.append(emptyVC)
        items.append(shareVC)
        items.append(settingVC)
        items.append(maskViewController)
        items.append(r3dLightVC)
        items.append(crossVC)
        items.append(pageVc)
        items.append(segmentVC)
        items.append(card)
        items.append(videoList)
         items.append(alert)
        items.append(gvc)
        items.append(loginVC)
        items.append(gradient)
        items.append(expandView)
        items.append(refresh)
        items.append(image)
        items.append(picker)
        items.append(icon)
        items.append(hookViewController)
        items.append(tap)
        items.append(pinch)
        items.append(move)
        items.append(flip)
        items.append(input)
        items.append(pop)
        items.append(test)
        items.append(btn)
        items.append(press)
        items.append(touch)
        items.append(record)
        items.append(banner)
        items.append(progress)
        items.append(BLur)
        items.append(customViewController)
        items.append(btnProgressViewController)
        items.append(playerViewController)
        items.append(swipeViewController)
        
        items.append(scaleBtnViewController)
        items.append(loadingVC)
        items.append(iAPViewController)
        
        items.append(newAnimatedViewController)
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        UIColor(hex: 0xff0000)!.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        print("hue:\(hue) - saturation: \(saturation) - brightness:\(brightness) ")
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let handler = items[indexPath.row].handler
        handler?()
    }
}

class ListItem {
    var name: String
    var handler: (() -> Void)?
    
    init(_ name: String, handler: (() -> Void)?) {
        self.name = name
        self.handler = handler
    }
}
