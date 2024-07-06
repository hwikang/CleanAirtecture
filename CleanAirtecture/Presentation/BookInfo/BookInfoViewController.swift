//
//  BookInfoViewController.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/5/24.
//

import UIKit
import RxSwift

final class BookInfoViewController: UIViewController {
    private let viewModel: BookInfoViewModelProtocol
    private let disposeBag = DisposeBag()
    private let bookInfoViewA = BookInfoView(title: "A")
    private let bookInfoViewB = BookInfoView(title: "B")
    private let priceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let bookButton = {
        let button = UIButton(type: .system)
        button.setTitle("예약 완료", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    public init(viewModel: BookInfoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(bookInfoViewA)
        view.addSubview(bookInfoViewB)
        view.addSubview(priceLabel)
        view.addSubview(bookButton)
        
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
        output
            .bookResultInfo
            .observe(on: MainScheduler.instance)
            .bind { [weak self] bookResultInfo in
                print(bookResultInfo)
                self?.bookInfoViewA.apply(info: bookResultInfo.a)
                self?.bookInfoViewB.apply(info: bookResultInfo.b)
                self?.priceLabel.text = "가격 - \(bookResultInfo.price.truncateValue())"
            }.disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        bookInfoViewA.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        bookInfoViewB.snp.makeConstraints { make in
            make.top.equalTo(bookInfoViewA.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(bookButton.snp.top).offset(-20)

        }
        bookButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
