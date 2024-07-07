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
    private let onChangeNickname: ()-> Void
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
    public init(viewModel: LocationDetailViewModelProtocol, onChangeNickname: @escaping ()-> Void) {
        self.viewModel = viewModel
        self.onChangeNickname = onChangeNickname
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
       
        let output = viewModel.transform(input: LocationDetailViewModel.Input(nickname: textField.rx.text.orEmpty.distinctUntilChanged(),
                                                                 change: changeNicknameButton.rx.tap.asObservable()))
        
        output.locationData.bind { [weak self] location, aqi in
            self?.nameLabel.text = "지역명 - " + location.name
            self?.aqiLabel.text = "AQI - " + aqi.description
            self?.locationLabel.text = "위도 - \(location.latitude) 경도 - \(location.longitude)"
            self?.textField.becomeFirstResponder()
            self?.textField.text = location.nickname

        }.disposed(by: disposeBag)
        output.errorMessage.bind { [weak self] errorMessage in
            self?.presentError(errorMessage: errorMessage)
        }.disposed(by: disposeBag)
        output.isChangeSuccess.bind { [weak self] isSuccess in
            if isSuccess {
                self?.onChangeNickname()
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.presentError(errorMessage: "닉네임 변경에 실패하였습니다.")

            }
        }.disposed(by: disposeBag)
    }
    
    private func presentError(errorMessage: String) {
        let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
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
