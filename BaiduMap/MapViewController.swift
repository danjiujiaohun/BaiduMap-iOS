//
//  MapViewController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/4/23.
//

import UIKit
import BaiduMapAPI_Map
import BaiduMapAPI_Search
import BaiduMapAPI_Utils
import BMKLocationKit

class MapViewController: BaseViewController,
                          BMKMapViewDelegate,
                          BMKLocationAuthDelegate,
                          BMKGeneralDelegate,
                          BMKLocationManagerDelegate,
                          BMKGeoCodeSearchDelegate {
    private(set) var mapView: BMKMapView!
    
    /// BMKUserLocation实例
    private var userLocation: BMKUserLocation!
    
    /// BMKLocationManager实例
    private var locationManager: BMKLocationManager!
    
    /// 逆地理编码检索实例
    private var search: BMKGeoCodeSearch!
    
    /// 逆地理编码检索选项
    private var reverseGeoCodeOption: BMKReverseGeoCodeSearchOption!
    
    /// 中间的定位指针
    private var annotation: BMKPointAnnotation!
    
    /// 中心点标识
    private var centerAnnotationViewIdentifier = "com.map.center.annotation"
    
    /// 当前用户定位的经度
    var currentUserLongitude: Double?
    
    /// 当前用户定位的纬度
    var currentUserLatitude: Double?
    
    /// 当前的中心经度
    var currentLongitude: Double?
    
    /// 当前的中心纬度
    var currentLatitude: Double?
    
    /// 城市名称
    var cityName: String?
    
    /// 城市编码
    var cityCode: String?
    
    /// 定位地点名称
    var locationName: String?
    
    var locationAddress: String?
    
    // 当前定位的poiName
    var poiName = ""
    
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
        createCenterAnnotation()
        
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    private func configurationBMK() {
        let appKey = "EAFiA03ZVrX8NysNoUOM0eHtUYyePxrk"
        
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: appKey, authDelegate: self)
        
        DispatchQueue.global(qos: .background).async {
            // 设置为YES时才能创建BMKSearchBase及其子类对象，否则返回nil，将影响地图SDK所有检索组件功能的使用
            BMKMapManager.setAgreePrivacy(true)
            // 要使用百度地图，请先启动BMKMapManager
            let mapManager = BMKMapManager()
            // 启动引擎并设置AK并设置delegate
            if !(mapManager.start(appKey, generalDelegate: self)) {
                NSLog("启动引擎失败")
            } else {
                NSLog("启动引擎成功")
            }
            
            /**
              百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
              默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
              如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
              */
            if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_BD09LL) {
                NSLog("经纬度类型设置成功")
            } else {
                NSLog("经纬度类型设置失败")
            }
        }
        
        userLocation = BMKUserLocation()
        
        locationManager = BMKLocationManager()
        locationManager.delegate = self
        // 设置返回位置的坐标系类型 默认为 BMKLocationCoordinateTypeGCJ02。
        locationManager.coordinateType = BMKLocationCoordinateType.BMK09LL
        //设置距离过滤参数
        locationManager.distanceFilter = 100
        //设置预期精度参数 默认为 kCLLocationAccuracyBest。
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //设置应用位置类型 默认为 CLActivityTypeAutomotiveNavigation。
        locationManager.activityType = CLActivityType.automotiveNavigation
        //设置是否自动停止位置更新
        locationManager.pausesLocationUpdatesAutomatically = false
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        locationManager.allowsBackgroundLocationUpdates = false
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        locationManager.locationTimeout = 10
        //设置获取地址信息超时时间
        locationManager.reGeocodeTimeout = 10
        ///连续定位是否返回逆地理信息，默认YES。
        locationManager.locatingWithReGeocode = true
        
        search = BMKGeoCodeSearch()
        search.delegate = self
        
        reverseGeoCodeOption = BMKReverseGeoCodeSearchOption()
        /// 是否访问最新版行政区划数据（仅对中国数据生效
        reverseGeoCodeOption.isLatestAdmin = true
    }
    
    private func initView() {
        isNavBarisHidden = true
        
        mapView = BMKMapView(frame: self.view.frame)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = BMKUserTrackingModeHeading
        mapView.zoomLevel = 17
        mapView.delegate = self
        mapView.isOverlookEnabled = false
        mapView.gesturesEnabled = true
        
        self.view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(Common.screenWidth)
            make.bottom.equalToSuperview()
        }
    }
    
    private func createCenterAnnotation() {
        if annotation == nil {
            annotation = MapCenterAnnotation.init()
        }
        
        annotation.isLockedToScreen = true
        annotation.screenPointToLock = CGPoint(x: view.frame.width/2, y: (view.frame.height-Common.safeAreaBottom)/2)
        
        if let annotation = annotation {
            mapView.addAnnotation(annotation)
        }
    }
    
    /// 地图中心移动到用户所在位置
    public func moveToUserLocation(){
        if userLocation.location != nil{
            mapView.setCenter(userLocation.location.coordinate, animated: true)
        } else {
            startLocation()
        }
    }
    
    /// 暴露的方法-定位成功
    func locationSuccess() {
        
    }
    
    /// 暴露的方法-开始定位
    func startLocation() {
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    /// 暴露的方法-地图有拖拽
    func regionDidChange(latitude: Double, longitude: Double) {
        
    }
    
    /// 暴露方法-逆地理编码成功
    func getReverseGeoResultSuccess() {
        
    }
    
    // MARK: - BMKLocationManagerDelegate
    /**
     @brief 该方法为BMKLocationManager提供设备朝向的回调方法
     @param manager 提供该定位结果的BMKLocationManager类的实例
     @param heading 设备的朝向结果
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        userLocation.heading = heading
        mapView.updateLocationData(userLocation)
        
    }
    
    /**
     @brief 连续定位回调函数
     @param manager 定位 BMKLocationManager 类
     @param location 定位结果，参考BMKLocation
     @param error 错误信息。
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        if let error = error?.localizedDescription {
            print(error)
            locationManager.stopUpdatingLocation()
        }
        
        if let l = location?.location,
           let rgcData = location?.rgcData,
           let adCode = rgcData.adCode,
           let city = rgcData.city,
           let pt = rgcData.poiList.first {
            userLocation.location = l
            // 实现该方法，否则定位图标不出现
            mapView.updateLocationData(userLocation)
            mapView.setCenter(userLocation.location.coordinate, animated: true)
            
            currentUserLatitude = l.coordinate.latitude
            currentUserLongitude = l.coordinate.longitude
            
            cityName = city
            cityCode = adCode
            
            locationName = pt.name
            locationAddress = pt.addr
            
            self.locationSuccess()
        }
        
    }
    
    func bmkLocationManagerDidChangeAuthorization(_ manager: BMKLocationManager) {
        if manager.authorizationStatus() == .authorizedAlways || manager.authorizationStatus() == .authorizedWhenInUse {
            startLocation()
            
        } else if manager.authorizationStatus() == .denied {
            print("暂无定位权限")
            
        }
    }
    
    // MARK: - BMKMapViewDelegate
    func mapView(_ mapView: BMKMapView, viewFor annotation: BMKAnnotation) -> BMKAnnotationView? {
        if annotation.isKind(of: MapCenterAnnotation.self) {
            /// 中心点标注
            var annotationView: MapCenterAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: centerAnnotationViewIdentifier) as? MapCenterAnnotationView
            
            if annotationView == nil {
                annotationView = MapCenterAnnotationView.init(annotation: annotation, reuseIdentifier: centerAnnotationViewIdentifier)
            }
            
            annotationView?.centerOffset = CGPoint(x: 0, y: 1.fit())
            
            return annotationView
        }
        
        return nil
    }

    func mapView(_ mapView: BMKMapView, regionWillChangeAnimated animated: Bool) {
        print("=====开始拖动地图")
    }
    
    func mapView(_ mapView: BMKMapView, regionDidChangeAnimated animated: Bool) {
        print("=====拖动了地图")
        currentLatitude = mapView.centerCoordinate.latitude
        currentLongitude = mapView.centerCoordinate.longitude
        regionDidChange(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        /// 逆地理编码检索
        reverseGeoCodeOption.location = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude)
        search.reverseGeoCode(reverseGeoCodeOption)
        
        if search.reverseGeoCode(reverseGeoCodeOption) == true {
            print("=======检索发送成功")
            
        } else {
            print("=======检索发送失败")
        }
    }
    
    // MARK: - BMKGeoCodeSearchDelegate
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            print("=======")
            print("=======城市：\(result.addressDetail.city)")
            print("=======城市编码：\(result.addressDetail.adCode)")
            print("=======地址：\(result.address)")
            
            cityName = result.addressDetail.city
            cityCode = result.addressDetail.adCode
            
            if let region = result.poiRegions.first {
                poiName = region.regionName
                
            } else if var list = result.poiList {
                list.sort { item1, item2 in
                    return item1.distance < item2.distance
                }
                poiName = list.first?.name ?? ""
            }
            
            locationName = poiName
            locationAddress = result.address
            
            getReverseGeoResultSuccess()
            
        } else {
            print("=======检索失败")
        }
    }
}
