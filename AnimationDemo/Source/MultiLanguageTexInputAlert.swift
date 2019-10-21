//
//  MultiLanguageTexInputAlert.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/21.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxSwiftExt
import IQKeyboardManagerSwift

class MultiLanguageTexInputAlert: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textPlaceholder: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    let bag = DisposeBag()
    @IBOutlet weak var inputViewCenterY: NSLayoutConstraint!
    let selectedModel: BehaviorRelay<TextInputModel?> = .init(value: nil)
    fileprivate lazy var datas: BehaviorRelay<[TextInputModel]> = {
        return BehaviorRelay<[TextInputModel]>(value:
            [ TextInputModel(keyboardType: 0, keyboardDesc: "简体中文", inputContent: nil, textPlaceholder: "字数不超过200字", textInputLength: 20, isSelect: true),
                   TextInputModel(keyboardType: 0, keyboardDesc: "繁体中文", inputContent: nil, textPlaceholder: "字数不超过300字", textInputLength: 30),
                   TextInputModel(keyboardType: 1, keyboardDesc: "美式英文", inputContent: nil, textPlaceholder: "字数不超过100字", textInputLength: 10),
                   TextInputModel(keyboardType: 2, keyboardDesc: "英式中文", inputContent: nil, textPlaceholder: "字数不超过50字", textInputLength: 5),
                   TextInputModel(keyboardType: 3, keyboardDesc: "日文", inputContent: nil, textPlaceholder: "字数不超过120字", textInputLength: 12),
                   TextInputModel(keyboardType: 4, keyboardDesc: "韩文", inputContent: nil, textPlaceholder: "字数不超过150字", textInputLength: 15)])
    }()
   fileprivate let transition = PopAnimator()
    
    static func show(_ presenter: UIViewController) {
        let vcc = MultiLanguageTexInputAlert()
        vcc.transitioningDelegate = vcc
        presenter.present(vcc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congfigUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
}

extension MultiLanguageTexInputAlert {
    fileprivate func congfigUI() {
        view.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.registerNibWithCell(PadTypeCollectionViewCell.self)
        datas.bind(to: collectionView.rx.items(cellIdentifier: String(describing: PadTypeCollectionViewCell.self), cellType: PadTypeCollectionViewCell.self)) { (row, element, cell) in
            cell.config(element)
        }
        .disposed(by: bag)
        
        datas.map { $0.first }
            .unwrap()
            .bind(to: selectedModel)
            .disposed(by: bag)

        textView.rx.text.orEmpty
            .asObservable()
            .map { !$0.isEmpty }
            .bind(to: textPlaceholder.rx.isHidden)
            .disposed(by: bag)
        
        func selected(_ indexPath: IndexPath) {
             var models = datas.value
             datas.accept(models)
             for(index, value) in models.enumerated() {
                 var newValue = value
                 newValue.isSelect = false
                 models[index] = newValue
             }
             var selectedModel = models[indexPath.row]
             selectedModel.isSelect = true
             models[indexPath.row] = selectedModel
             datas.accept(models)
            self.selectedModel.accept(selectedModel)
        }

        collectionView.rx.itemSelected
          .map { $0 }
          .subscribe(onNext: selected)
          .disposed(by: bag)
        
        collectionView.rx.modelSelected(TextInputModel.self)
            .asObservable()
            .bind(to: selectedModel)
            .disposed(by: bag)
    
        let selectedModel = self.selectedModel
        let textChange = textView.rx.text.orEmpty
            .map { (text) -> String in
                let length = selectedModel.value?.textInputLength ?? 0
                if text.count >= length {
                    return String(text[..<text.index(text.startIndex, offsetBy: length)])
                }
                return text
            }
        
         textChange
            .bind(to: textView.rx.text)
            .disposed(by:bag)
        
        textChange
            .map { (text) -> TextInputModel? in
                var model = selectedModel.value
                model?.inputContent = text
                return model
            }
            .unwrap()
            .bind(to: self.selectedModel)
            .disposed(by: bag)

        selectedModel.asObservable()
            .unwrap()
            .map { $0.inputContent}
            .bind(to: textView.rx.text)
            .disposed(by: bag)
        
        selectedModel.asObservable()
        .unwrap()
            .map { $0.textPlaceholder}
            .bind(to: textPlaceholder.rx.text)
            .disposed(by: bag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .asObservable()
            .map { $0.userInfo }
            .unwrap()
            .subscribe(onNext: { (_) in
                debugPrint(self.selectedModel.value ?? "")
            })
            .disposed(by: bag)
        
        closeBtn.rx.tap
            .subscribe(onNext: { [weak self](_) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
        
        let alert = DefaultWireframe(self)
        enterBtn.rx.tap
            .mapToVoid()
            .flatMap {
                alert.promptAlert(title: nil, message: String(describing: self.selectedModel.value!))
            }
            .subscribe()
            .disposed(by: bag)
    }
}


extension MultiLanguageTexInputAlert: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let keyboardDesc = datas.value[indexPath.row].keyboardDesc ?? ""
        let textWidth = keyboardDesc.width(fontSize: 15) + 20
        return CGSize(width: textWidth, height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


extension MultiLanguageTexInputAlert: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

fileprivate class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.0
    var presenting: Bool = true
    var originFrame: CGRect = .zero
    var dismissCompletion: ((Bool) -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        var herbView: UIView!
        if presenting {
            herbView = transitionContext.view(forKey: .to)!
        } else {
            herbView = transitionContext.view(forKey: .from)!
        }
        containerView.backgroundColor = .clear
        let intialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
        
        let xScaleFactor = presenting ? intialFrame.width / finalFrame.width : finalFrame.width / intialFrame.width
        let yScaleFactor = presenting ? intialFrame.height / finalFrame.height : finalFrame.height / intialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }
        containerView.addSubview(herbView)
        containerView.bringSubviewToFront(herbView)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
        }) { (_) in
            transitionContext.completeTransition(true)
            if !self.presenting {
                self.dismissCompletion?(true)
            }
        }
    }
    

}
