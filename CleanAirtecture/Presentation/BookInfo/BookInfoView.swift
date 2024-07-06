//
//  BookInfoView.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//

import UIKit

public final class BookInfoView: UIView {
    private let title: String
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
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
    
    public init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setUI()
    }
    
    public func apply(info: BookInfo) {
        nameLabel.text = "이름 - " + info.name
        aqiLabel.text = "AQI - \(info.aqi)"
        locationLabel.text = "위도 - \(info.latitude) 경도 - \(info.longitude)"
    }
    
    private func setUI() {
        titleLabel.text = title
        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(aqiLabel)
        addSubview(locationLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        aqiLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(aqiLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
