//
//  suggestionLocationCell.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/5/17.
//

import UIKit

class suggestionLocationCell: UITableViewCell {
    private var locationTitleLabel: UILabel!
    private var locationAddressLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = UIColor.color(.color_FFFFFF)
        
        locationTitleLabel = UILabel.label("", textColor: UIColor.color(.color_24292B), font: UIFont.font(of: 14.fit(), weight: .medium))
        
        locationAddressLabel = UILabel.label("", textColor: UIColor.color(.color_9DA2A5), font: UIFont.font(of: 12.fit(), weight: .regular))
        
        contentView.addSubview(locationTitleLabel)
        contentView.addSubview(locationAddressLabel)
    }
    
    private func setupLayout() {
        locationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(4.fit())
            make.left.equalTo(16.fit())
            make.right.lessThanOrEqualTo(-16.fit())
        }
        
        locationAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(locationTitleLabel.snp.bottom).offset(4.fit())
            make.left.equalTo(16.fit())
            make.right.lessThanOrEqualTo(-16.fit())
        }
    }
    
    func updateCellInfo(locationTitle: String, locationAddress: String) {
        locationTitleLabel.text = locationTitle
        locationAddressLabel.text = locationAddress
    }

}
