//
//  BookHistoryTableViewCell.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//

import UIKit

final class BookHistoryTableViewCell: UITableViewCell {
    static let id = "BookHistoryTableViewCell"
    private let bookInfoViewA = BookInfoView(title: "A")
    private let bookInfoViewB = BookInfoView(title: "B")
    private let priceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bookInfoViewA)
        contentView.addSubview(bookInfoViewB)
        contentView.addSubview(priceLabel)
        setConstraints()
    }
    
    public func apply(info: BookResultInfo) {
        bookInfoViewA.apply(info: info.a)
        bookInfoViewB.apply(info: info.b)
        priceLabel.text = "가격 - \(info.price)"
    }
    
    private func setConstraints() {
        bookInfoViewA.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        bookInfoViewB.snp.makeConstraints { make in
            make.top.equalTo(bookInfoViewA.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(bookInfoViewB.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
