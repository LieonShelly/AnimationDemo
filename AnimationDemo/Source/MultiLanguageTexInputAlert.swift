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
            [ TextInputModel(keyboardType: 0, keyboardDesc: "简体中文", inputContent: nil, textPlaceholder: "字数不超过200字", textInputLength: 2000, isSelect: true),
                   TextInputModel(keyboardType: 0, keyboardDesc: "繁体中文", inputContent: nil, textPlaceholder: "字数不超过300字", textInputLength: 3000),
                   TextInputModel(keyboardType: 1, keyboardDesc: "美式英文", inputContent: nil, textPlaceholder: "字数不超过100字", textInputLength: 1000),
                   TextInputModel(keyboardType: 2, keyboardDesc: "英式中文", inputContent: nil, textPlaceholder: "字数不超过50字", textInputLength: 5000),
                   TextInputModel(keyboardType: 3, keyboardDesc: "日文", inputContent: nil, textPlaceholder: "字数不超过120字", textInputLength: 1200),
                   TextInputModel(keyboardType: 4, keyboardDesc: "韩文", inputContent: nil, textPlaceholder: "字数不超过150字", textInputLength: 1500)])
    }()
   fileprivate let transition = PopAnimator()
    
    static func show(_ presenter: UIViewController) {
        let vcc = MultiLanguageTexInputAlert()
        vcc.transitioningDelegate = vcc
        vcc.modalPresentationStyle = .custom
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
    weak var transitionContext: UIViewControllerContextTransitioning!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        containerView.superview?.backgroundColor = .clear
        var herbView: UIView!
        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale") //CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.stiffness = 200
        scaleAnimation.damping = 10
        scaleAnimation.duration = scaleAnimation.settlingDuration
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = true
        scaleAnimation.delegate = self
        var finalFrame: CGRect = .zero
        if presenting {
            herbView = transitionContext.view(forKey: .to)!
            scaleAnimation.fromValue = 0
            scaleAnimation.toValue = 1
            let toVC = transitionContext.viewController(forKey: .to)
            finalFrame = transitionContext.finalFrame(for: toVC!)
            
        } else {
            herbView = transitionContext.view(forKey: .from)!
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = 0
            let fromVC = transitionContext.viewController(forKey: .from)
            finalFrame = transitionContext.finalFrame(for: fromVC!)
            herbView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        herbView.frame = finalFrame
        containerView.backgroundColor = .clear
        containerView.addSubview(herbView)
        containerView.bringSubviewToFront(herbView)
        herbView.layer.add(scaleAnimation, forKey: nil)
    }
    

}

extension PopAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        transitionContext.completeTransition(true)
        if !presenting {
            dismissCompletion?(flag)
        }
    }
}
