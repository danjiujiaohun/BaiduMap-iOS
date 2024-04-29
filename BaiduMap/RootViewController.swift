//
//  RootViewController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/4/23.
//

import UIKit
import BaiduMapAPI_Map
import BaiduMapAPI_Search
import BaiduMapAPI_Utils
import BMKLocationKit

class RootViewController: BaseViewController,
                          BMKMapViewDelegate,
                          BMKLocationAuthDelegate,
                          BMKGeneralDelegate {
    private var mapView: BMKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /// 当mapView即将被隐藏的时候调用，存储当前mapView的状态
        mapView.viewWillDisappear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configurationBMK()
        initView()
    }
    
    private func configurationBMK() {
        let appKey = "EAFiA03ZVrX8NysNoUOM0eHtUYyePxrk"
        
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: appKey, authDelegate: self)
        
        DispatchQueue.global(qos: .background).async {
            // 要使用百度地图，请先启动BMKMapManager
            let mapManager = BMKMapManager()
            // 启动引擎并设置AK并设置delegate
            if !(mapManager.start(appKey, generalDelegate: self)) {
                NSLog("启动引擎失败")
            }
            
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
    }
    
    private func initView() {
        self.view.backgroundColor = UIColor.color(.color_FFFFFF)
        
//        mapView = BMKMapView(frame: .zero)
//        mapView.zoomLevel = 17
//        mapView.showMapScaleBar = true
//        mapView.isChangeCenterWithDoubleTouchPointEnabled = true
//        mapView.gesturesEnabled = true
//        mapView.delegate = self
        mapView = BMKMapView(frame: .zero)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = BMKUserTrackingModeHeading
        mapView.zoomLevel = 17
        mapView.delegate = self
        mapView.isOverlookEnabled = false
        mapView.isRotateEnabled = false
        mapView.gesturesEnabled = true
        
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
