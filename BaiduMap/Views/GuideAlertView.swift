//
//  GuideAlertView.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/6/7.
//

import UIKit

class GuideAlertView: UIView {
    private var bgView: UIView!
    private var gaodeMapButton: UIButton!
    private var baiduMapButton: UIButton!
    private var cancelButton: UIButton!
    
    private var latitude: Double?
    private var longitude: Double?
    private var address = ""
    
    /// 外部可调用
    var gaodeMapButtonAciton: (() -> Void)?
    var baiduMapButtonAciton: (() -> Void)?
    var cancelButtonAciton: (() -> Void)?
    
    init(frame: CGRect, latitude: Double, longitude: Double, address: String) {
        super.init(frame: frame)
        
        self.initView()
        self.setupLayout()
        
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = .clear
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.color(.color_FFFFFF)
        bgView.layer.cornerRadius = 16.fit()
        bgView.layer.masksToBounds = true
        
        gaodeMapButton = UIButton.button(title: "高德地图", titleColor: UIColor.color(.color_24292B), fontSize: 16.fit(), backgroundColor: UIColor.color(.color_FFFFFF))
        gaodeMapButton.titleLabel?.font = UIFont.font(of: 16.fit(), weight: .medium)
        
        gaodeMapButton.addTarget(self, action: #selector(clickgaodeMapButton), for: .touchUpInside)
        
        baiduMapButton = UIButton.button(title: "百度地图", titleColor: UIColor.color(.color_24292B), fontSize: 16.fit(), backgroundColor: UIColor.color(.color_FFFFFF))
        baiduMapButton.titleLabel?.font = UIFont.font(of: 16.fit(), weight: .medium)
        
        baiduMapButton.addTarget(self, action: #selector(clickbaiduMapButton), for: .touchUpInside)
        
        cancelButton = UIButton.button(title: "取消", titleColor: UIColor.color(.color_24292B), fontSize: 16.fit(), backgroundColor: UIColor.color(.color_FFFFFF))
        cancelButton.titleLabel?.font = UIFont.font(of: 16.fit(), weight: .regular)
        cancelButton.layer.cornerRadius = 16.fit()
        cancelButton.layer.masksToBounds = true
        
        cancelButton.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        
        self.addSubview(bgView)
        bgView.addSubview(gaodeMapButton)
        bgView.addSubview(baiduMapButton)
        
        self.addSubview(cancelButton)
    }
    
    private func setupLayout() {
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalTo(16.fit())
            make.height.equalTo(123.fit())
        }
        
        baiduMapButton.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(61.fit())
        }
        
        gaodeMapButton.snp.makeConstraints { make in
            make.top.equalTo(baiduMapButton.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(61.fit())
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgView.snp.bottom).offset(16.fit())
            make.left.equalTo(16.fit())
            make.height.equalTo(64.fit())
        }
    }

    // MARK: - Actions
    
    /// 点击高德地图按钮
    @objc
    private func clickgaodeMapButton() {
        self.gaodeMapButtonAciton?()
        
        if let latitudeValue = latitude, let longitudeValue = longitude {
            if(UIApplication.shared.canOpenURL(URL(string:"iosamap://")!) == true) {
                "iosamap://path?sourceApplication=百度地图Demo&sid=BGVIS1&did=BGVIS2&sname=我的位置&dlat=\(latitudeValue)&dlon=\(longitudeValue)&dname=\(address)&dev=0&t=0".open()
                
            } else {
                print("====请安装高德地图")
                /// 提示安装高德地图
                HUD().showErrorStr(errorStr: "没有找到高德导航软件，请先安装")
            }
        }
    }
    
    /// 点击百度地图按钮
    @objc
    private func clickbaiduMapButton() {
        self.baiduMapButtonAciton?()
        if let latitudeValue = latitude, let longitudeValue = longitude {
            if(UIApplication.shared.canOpenURL(URL(string:"baidumap://")!) == true) {
                "baidumap://map/direction?destination=latlng:\(latitudeValue),\(longitudeValue)|name:\(address)&mode=driving&coord_type=gcj02".open()
                
            } else {
                print("====请安装百度地图")
                /// 提示安装百度地图
                HUD().showErrorStr(errorStr: "没有找到百度导航软件，请先安装")
            }
        }
    }
    
    /// 点击取消按钮
    @objc
    private func clickCancelButton() {
        self.cancelButtonAciton?()
    }
}

extension String {
    public func open() {
        if let url = URL(string: addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
