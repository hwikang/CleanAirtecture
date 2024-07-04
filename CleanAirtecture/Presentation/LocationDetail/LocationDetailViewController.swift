//
//  LocationDetailViewController.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/3/24.
//

import UIKit
import RxSwift

final class LocationDetailViewController: UIViewController {
    private let viewModel: LocationDetailViewModelProtocol
    private let disposeBag = DisposeBag()

    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let aqiLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let locationLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let textField = {
        let textfield = UITextField()
        textfield.placeholder = "닉네임을 입력해주세요"
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    private let changeNicknameButton = {
        let button = UIButton(type: .system)
        button.setTitle("변경하기", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    public init(viewModel: LocationDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(nameLabel)
        view.addSubview(aqiLabel)
        view.addSubview(locationLabel)
        view.addSubview(textField)
        view.addSubview(changeNicknameButton)
        setConstraints()
    }
    
    private func bindViewModel() {
        nameLabel.text = "지역명" + viewModel.location.name
        aqiLabel.text = "AQI - " + viewModel.aqi.description
        locationLabel.text = "위도 - \(viewModel.location.latitude) 경도 - \(viewModel.location.longitude)"
        
        let output = viewModel.transform(input: LocationDetailViewModel.Input(nickname: textField.rx.text.orEmpty.distinctUntilChanged(),
                                                                 change: changeNicknameButton.rx.tap.asObservable()))
        output.errorMessage.bind { errorMessage in
            print(errorMessage)
        }.disposed(by: disposeBag)
        output.isChangeSuccess.bind { [weak self] isSuccess in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        aqiLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(aqiLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(30)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        changeNicknameButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
