//
//  BookHistoryViewController.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//

import UIKit
import RxSwift

final class BookHistoryViewController: UIViewController {
    private let viewModel: BookHistoryViewModelProtocol
    private let coordinator: BookHistoryCoordinatorProtocol
    private let disposeBag = DisposeBag()
    private let historyTableView = {
        let tableView = UITableView()
        tableView.register(BookHistoryTableViewCell.self, forCellReuseIdentifier: BookHistoryTableViewCell.id)
        return tableView
    }()
    
    public init(viewModel: BookHistoryViewModelProtocol, coordinator: BookHistoryCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
        setUI()
        bindViewModel()
        bindView()
    }
    
    private func setUI() {
        view.addSubview(historyTableView)
        setConstraints()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform()
        output
            .errorMessage
            .observe(on: MainScheduler.instance)
            .bind { [weak self] errorMessage in
                let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                alert.addAction(action)
                self?.present(alert, animated: true)
            }.disposed(by: disposeBag)
        
        output.bookHistory
            .observe(on: MainScheduler.instance)
            .bind(to: historyTableView.rx.items) { tableView, _, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: BookHistoryTableViewCell.id)
                    else { return UITableViewCell() }
                (cell as? BookHistoryTableViewCell)?.apply(info: element)
                return cell
        }.disposed(by: disposeBag)
        
    }
    
    private func bindView() {
        
        historyTableView.rx.itemSelected.bind { [weak self] indexPath in
            guard let info = self?.viewModel.getBookInfo(index: indexPath.item) else { return }
            let locationA = Location(latitude: info.a.latitude, longitude: info.a.longitude, name: info.a.name)
            let locationB = Location(latitude: info.b.latitude, longitude: info.b.longitude, name: info.b.name)
            self?.coordinator.backToMapVC(locationA: locationA, locationB: locationB)
        }.disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        historyTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
