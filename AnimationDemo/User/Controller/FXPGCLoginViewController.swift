//
//  FXPGCLoginViewController.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/5/28.
//  UGC达人登录页

import RxSwift
import RxCocoa
import RxDataSources

class FXPGCLoginViewController: UIViewController {
    fileprivate let bag = DisposeBag()
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()
    fileprivate  var viewModel: FXPGCLoginViewModel!
    let viewDidLoadInput: PublishSubject<Void> = .init()
    
    convenience init(_ viewModel: FXPGCLoginViewModel) {
        self.init()
        self.viewModel = viewModel
        let input = FXPGCLoginViewModel.Input()
        viewDidLoadInput.bind(to: input.viewDidLoad).disposed(by: bag)
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, FXLoginTableData>>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .title:
                let cell = tableView.dequeueCell(FXLoginTitleCell.self, for: indexPath)
                return cell
            case .account(let model):
                let cell = tableView.dequeueCell((FXLoginTextInputCell.self).self, for: indexPath)
                cell.textField.placeholder = model.placeHolder
                cell.titleLabel.text = model.title
                cell.textField.rx.text.orEmpty.bind(to: model.textInput).disposed(by: cell.bag)
                cell.textField.text = model.textInput.value
                cell.textField.keyboardType = .numberPad
                cell.textField.isSecureTextEntry = false
                return cell
            case .password(let model):
                let cell = tableView.dequeueCell((FXLoginTextInputCell.self).self, for: indexPath)
                cell.textField.placeholder = model.placeHolder
                cell.titleLabel.text = model.title
                cell.textField.rx.text.orEmpty.bind(to: model.textInput).disposed(by: cell.bag)
                cell.textField.text = model.textInput.value
                cell.textField.isSecureTextEntry = true
                cell.textField.keyboardType = .default
                return cell
            case .loginBtn(let model):
                let cell = tableView.dequeueCell(FXLoginBtnCell.self, for: indexPath)
                cell.btn.isEnabled = model.isEnable.value
                model.isEnable.bind(to: cell.btn.rx.isEnabled).disposed(by: cell.bag)
                return cell
            }
        })
        
        let output = viewModel.transform(input: input)
        output.rows
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.registerClassWithCell(FXLoginBtnCell.self)
        tableView.registerClassWithCell(FXLoginTitleCell.self)
        tableView.registerClassWithCell(FXLoginTextInputCell.self)
        tableView.registerClassWithCell(UITableViewCell.self)
        view.addSubview(tableView)
        viewDidLoadInput.onNext(())
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    
    
}

extension FXPGCLoginViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
