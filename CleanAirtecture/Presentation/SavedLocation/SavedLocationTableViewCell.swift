//
//  SavedLocationTableViewCell.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//


import UIKit

final class SavedLocationTableViewCell: UITableViewCell {
    static let id = "SavedLocationTableViewCell"
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    private let nicknameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let locationLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(locationLabel)
        setConstraints()
    }
    
    public func apply(location: Location) {
        titleLabel.text = location.name
        locationLabel.text = "위도 - \(location.latitude) 경도 - \(location.longitude)"
        nicknameLabel.text = location.nickname
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
