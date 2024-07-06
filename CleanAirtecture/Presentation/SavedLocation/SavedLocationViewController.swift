//
//  SavedLocationViewController.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//


import UIKit
import RxSwift

final class SavedLocationViewController: UIViewController {
    private let viewModel: SavedLocationViewModelProtocol
    private let onSelectLocation: (Location)-> Void
    private let disposeBag = DisposeBag()
    private let locationsTableView = {
        let tableView = UITableView()
        tableView.register(SavedLocationTableViewCell.self, forCellReuseIdentifier: SavedLocationTableViewCell.id)
        return tableView
    }()
    
    public init(viewModel: SavedLocationViewModelProtocol, onSelectLocation: @escaping (Location)-> Void) {
        self.viewModel = viewModel
        self.onSelectLocation = onSelectLocation
        super.init(nibName: nil, bundle: nil)
        
        setUI()
        bindViewModel()
        bindView()
    }
    
    private func setUI() {
        view.addSubview(locationsTableView)
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
        
        output.locations
            .observe(on: MainScheduler.instance)
            .bind(to: locationsTableView.rx.items) { tableView, _, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedLocationTableViewCell.id)
                    else { return UITableViewCell() }
                (cell as? SavedLocationTableViewCell)?.apply(location: element)
                return cell
        }.disposed(by: disposeBag)
        
    }
    
    private func bindView() {
        
        locationsTableView.rx.modelSelected(Location.self).bind { [weak self] location in
            self?.navigationController?.popViewController(animated: true)
            self?.onSelectLocation(location)
        }.disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        locationsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
