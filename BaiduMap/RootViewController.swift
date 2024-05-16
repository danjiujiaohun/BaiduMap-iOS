//
//  RootViewController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/4/30.
//

import UIKit

class RootViewController: MapViewController {
    private var topBgView: UIView!
    private var currentLocationLabel: UILabel!
    
    private var bottomBgView: UIView!
    private var locationButton: UIButton!
    private var lonInfoLabel: UILabel!
    private var latInfoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        setupLayout()
    }
    
    private func initView() {
        topBgView = UIView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.safeAreaTop + 48.fit()))
        topBgView.backgroundColor = UIColor.color(.color_FFFFFF)
        
        currentLocationLabel = UILabel.label("", textColor: UIColor.color(.color_24292B), font: UIFont.font(of: 16.fit(), weight: .regular))
        
        bottomBgView = UIView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.safeAreaBottom + 32.fit()))
        bottomBgView.backgroundColor = UIColor.color(.color_FFFFFF)
        
        locationButton = UIButton(type: .custom)
        locationButton.setImage(UIImage.image(.location_btn), for: .normal)
        locationButton.setImage(UIImage.image(.location_btn), for: .highlighted)
        locationButton.addTarget(self, action: #selector(clickLocationButton), for: .touchUpInside)
        
        lonInfoLabel = UILabel.label("当前经度：", textColor: UIColor.color(.color_24292B), font: UIFont.font(of: 14.fit(), weight: .medium))
        latInfoLabel = UILabel.label("当前纬度：", textColor: UIColor.color(.color_24292B), font: UIFont.font(of: 14.fit(), weight: .medium))
        
        view.addSubview(topBgView)
        topBgView.addSubview(currentLocationLabel)
        view.addSubview(bottomBgView)
        view.addSubview(locationButton)
        bottomBgView.addSubview(lonInfoLabel)
        bottomBgView.addSubview(latInfoLabel)
    }
    
    private func setupLayout() {
        topBgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(Common.screenWidth)
            make.height.equalTo(Common.safeAreaTop + 48.fit())
        }
        
        currentLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(Common.statusBarHeight + 8.fit())
            make.left.equalTo(32.fit())
        }
        
        bottomBgView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(Common.screenWidth)
            make.height.equalTo(Common.safeAreaBottom + 32.fit())
        }
        
        locationButton.snp.makeConstraints { make in
            make.right.equalTo(-16.fit())
            make.bottom.equalTo(bottomBgView.snp.top)
            make.size.equalTo(CGSize(width: 52.fit(), height: 52.fit()))
        }
        
        lonInfoLabel.snp.makeConstraints { make in
            make.left.equalTo(16.fit())
            make.top.equalTo(bottomBgView)
        }
        
        latInfoLabel.snp.makeConstraints { make in
            make.left.equalTo(lonInfoLabel)
            make.top.equalTo(lonInfoLabel.snp.bottom)
        }
    }
    
    //MARK: - 重写方法
    override func locationSuccess() {
        if let lon = currentLongitude, let lat = currentLatitude {
            lonInfoLabel.text = "当前用户经度：\(lon)"
            latInfoLabel.text = "当前用户纬度：\(lat)"
        }
        
        if let locationName = locationName {
            currentLocationLabel.text = locationName
        }
    }
    
    override func regionDidChange(latitude: Double, longitude: Double) {
        lonInfoLabel.text = "当前屏幕中心经度：\(longitude)"
        latInfoLabel.text = "当前屏幕中心纬度: \(latitude)"
    }
    
    override func getReverseGeoResultSuccess() {
        if let locationNameValue = self.locationName {
            currentLocationLabel.text = locationNameValue
        }
    }

    //MARK: - Action
    @objc
    private func clickLocationButton() {
        moveToUserLocation()
        mapView.zoomLevel = 17
        
    }
}
