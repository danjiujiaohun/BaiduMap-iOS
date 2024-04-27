//
//  RootViewController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/4/23.
//

import UIKit
import BaiduMapAPI_Map

class RootViewController: BaseViewController, BMKMapViewDelegate {
    private var mapView: BMKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configurationBMK()
        initView()
    }
    
    private func configurationBMK() {
        /**
          百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
          默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
          如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
          */
        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_COMMON) {
            NSLog("经纬度类型设置成功")
        } else {
            NSLog("经纬度类型设置失败")
        }
    }
    
    private func initView() {
        self.view.backgroundColor = UIColor.color(.color_FFFFFF)
        
        mapView = BMKMapView(frame: .zero)
        mapView.zoomLevel = 17
        mapView.showMapScaleBar = true
        mapView.isChangeCenterWithDoubleTouchPointEnabled = true
        mapView.gesturesEnabled = true
        mapView.delegate = self
        
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
