//
//  RootViewController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/4/30.
//

import UIKit

class RootViewController: MapViewController {
    private var locationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        setupLayout()
    }
    
    private func initView() {
        locationButton = UIButton(type: .custom)
        locationButton.setImage(UIImage.image(.location_btn), for: .normal)
        locationButton.setImage(UIImage.image(.location_btn), for: .highlighted)
        locationButton.addTarget(self, action: #selector(clickLocationButton), for: .touchUpInside)
        
        view.addSubview(locationButton)
        
    }
    
    private func setupLayout() {
        locationButton.snp.makeConstraints { make in
            make.right.equalTo(-16.fit())
            make.bottom.equalTo(-(Common.safeAreaBottom + 16.fit()))
            make.size.equalTo(CGSize(width: 52.fit(), height: 52.fit()))
        }
    }

    //MARK: - Action
    @objc
    private func clickLocationButton() {
        moveToUserLocation()
        mapView.zoomLevel = 17
        
    }
}
