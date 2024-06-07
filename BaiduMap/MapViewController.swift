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
import BaiduMapAPI_Base

class MapViewController: BaseViewController,
                          BMKMapViewDelegate,
                          BMKLocationAuthDelegate,
                          BMKGeneralDelegate,
                          BMKLocationManagerDelegate,
                          BMKGeoCodeSearchDelegate,
                          BMKRouteSearchDelegate {
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
    
    /// 路线搜索BMKRouteSearch实例
    private var routeSearch: BMKRouteSearch!
    
    /// 当前用户定位的经度
    var currentUserLongitude: Double?
    
    /// 当前用户定位的纬度
    var currentUserLatitude: Double?
    
    /// 当前用户定位地点名称
    var currentUserLocationName: String?
    
    /// 当前用户定位地点uid
    var currentUserLocationUid: String?
    
    /// 当前搜索地址目的地的经度
    var currentEndLongitude: Double?
    
    /// 当前搜索地址目的地的纬度
    var currentEndLatitude: Double?
    
    /// 当前搜索地址目的地的名称
    var currentEndLocationName: String?
    
    /// 当前搜索地址目的地的uid
    var currentEndLocationUid: String?
    
    /// 当前的中心经度
    var currentLongitude: Double?
    
    /// 当前的中心纬度
    var currentLatitude: Double?
    
    /// 当前中心地点名称
    var currentLocationName: String?
    
    /// 当前中心地点Uid
    var currentLocationUid: String?
    
    /// 城市名称
    var cityName: String?
    
    /// 城市编码
    var cityCode: String?
    
    /// 定位地点名称
    var locationName: String?
    
    var locationAddress: String?
    
    // 当前定位的poiName
    var poiName = ""
    
    // 当前定位的uid
    var poiUid = ""
    
    //地图下方的不可见BottomOffset 用于调整地图居中位置
    public var bottomOffset:CGFloat = 50
    
    public var searchPathAction:((Int32,Int32) -> Void)?
    
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

        requestLocationAuthorization()
        configurationBMK()
        initView()
        createCenterAnnotation()
        
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    private func requestLocationAuthorization() {
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
    }
    
    private func configurationBMK() {
        let appKey = "EAFiA03ZVrX8NysNoUOM0eHtUYyePxrk"
        
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: appKey, authDelegate: self)
        
        DispatchQueue.global(qos: .background).async { [self] in
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
            
            search = BMKGeoCodeSearch()
            search.delegate = self
            
            reverseGeoCodeOption = BMKReverseGeoCodeSearchOption()
            /// 是否访问最新版行政区划数据（仅对中国数据生效
            reverseGeoCodeOption.isLatestAdmin = true
            
            routeSearch = BMKRouteSearch()
            routeSearch.delegate = self
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
    
    /// 地图中心移动到指定位置
    public func moveToCustomLocation(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        mapView.setCenter(location.coordinate, animated: true)
    }
    
    /// 地图中心移出地图路线，展示中心标注
    public func reShowCenterAnnotationView() {
        mapView.removeOverlays(mapView.overlays ?? [BMKOverlay]())
        
        annotation.isLockedToScreen = true
        annotation.screenPointToLock = CGPoint(x: view.frame.width/2, y: (view.frame.height-Common.safeAreaBottom)/2)
        
        if let annotation = annotation {
            mapView.addAnnotation(annotation)
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
    
    /// 暴露方法-搜索驾车路线
    func searchDrivingRoute(startLocationName: String?, endLocationName: String?) {
        print("导航起始地：\(startLocationName)")
        print("导航目的地：\(endLocationName)")
        if endLocationName == currentLocationName {
            searchPath(cityName: "杭州市", isExchangeEndLocation: false)
            
        } else if startLocationName == currentLocationName {
            searchPath(cityName: "杭州市", isExchangeEndLocation: true)
        }
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
            
            currentUserLocationName = pt.name
            currentUserLocationUid = pt.uid
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
    
    /// 画出导航路径
    func mapView(_ mapView: BMKMapView, viewFor overlay: BMKOverlay) -> BMKOverlayView? {
        if overlay.isKind(of: BMKPolyline.self) {
            //初始化一个overlay并返回相应的BMKPolylineView的实例
            let polylineView = BMKPolylineView(overlay: overlay)
            //设置polylineView的画笔（边框）颜色
            polylineView?.strokeColor = UIColor.color(.color_F76400).withAlphaComponent(0.6)
            //设置polylineView的线宽度
            polylineView?.lineWidth = 4.0
            polylineView?.lineJoinType = kBMKLineJoinBerzier
            
            return polylineView
        }
        return nil
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
                poiUid = region.regionUID
                
            } else if var list = result.poiList {
                list.sort { item1, item2 in
                    return item1.distance < item2.distance
                }
                poiName = list.first?.name ?? ""
                poiUid = list.first?.uid ?? ""
            }
            
            currentLocationName = poiName
            currentLocationUid = poiUid
            
            locationName = poiName
            locationAddress = result.address
            
            getReverseGeoResultSuccess()
            
        } else {
            print("=======检索失败")
        }
    }
    
    //MARK: - BMKRouteSearchDelegate
    func searchPath(cityName: String, isExchangeEndLocation: Bool) {
        /*
         线路检索节点信息类，一个路线检索节点可以通过经纬度坐标或城市名加地名确定
         实例化线路检索节点信息类对象
         */
        let start = BMKPlanNode()
        // 起点名称
        start.name = currentUserLocationName
        // 导航地址暂定都为杭州市，后续进行迭代更改 注：cityName和cityID同时指定时，优先使用cityID
        start.cityName = "杭州市"
        // 起点经纬度
        start.pt = CLLocationCoordinate2D(latitude: currentUserLatitude ?? 0.0, longitude: currentUserLongitude ?? 0.0)
        
        //实例化线路检索节点信息类对象
        let end = BMKPlanNode()
        //终点名称
        end.name = currentLocationName
        //终点所在城市，注：cityName和cityID同时指定时，优先使用cityID
        end.cityName = "杭州市"
        //终点经纬度
        end.pt = CLLocationCoordinate2D(latitude: currentLatitude ?? 0.0, longitude: currentLongitude ?? 0.0)
        
        // 保存搜索目的地的相关信息
        // 目的地名称
        currentEndLocationName = currentLocationName
        // 目的地经纬度和uid
        currentEndLatitude = currentLatitude
        currentEndLongitude = currentLongitude
        currentEndLocationUid = currentLocationUid
        
        
        //初始化请求参数类BMKDrivingRoutePlanOption的实例
        let drivingRoutePlanOption = BMKDrivingRoutePlanOption()
        if !isExchangeEndLocation {
            //检索的起点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
            drivingRoutePlanOption.from = start
            //检索的终点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
            drivingRoutePlanOption.to = end
            
        } else {
            //检索的起点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
            drivingRoutePlanOption.from = end
            //检索的终点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
            drivingRoutePlanOption.to = start
        }
        
        /**
         发起驾乘路线检索请求，异步函数，返回结果在BMKRouteSearchDelegate的onGetDrivingRouteResult中
         */
        let flag = routeSearch.drivingSearch(drivingRoutePlanOption)
        if flag {
            print("=====驾车检索成功")
            
        } else {
            print("=====驾车检索失败")
        }
    }
    
    func onGetDrivingRouteResult(_ searcher: BMKRouteSearch!, result: BMKDrivingRouteResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            /// 成功获取结果
            // 清除之前的标记和规划的路径
            mapView.removeAnnotations(mapView.annotations ?? [BMKAnnotation]())
            
            var pointCount = 0
            // 获取所有驾车路线中的第一条路线
            var routeline = BMKDrivingRouteLine()
            if result.routes.count > 0 {
                routeline = result.routes[0]
            }
            
            // 遍历驾车路线中的所有路段
            for(_, item) in routeline.steps.enumerated() {
                //获取驾车路线中的每条路段
                let step: BMKDrivingStep = item as! BMKDrivingStep
                //初始化标注类BMKPointAnnotation的实例
                let annotation = BMKPointAnnotation()
                //设置标注的经纬度坐标为子路段的入口经纬度
                annotation.coordinate = step.entrace.location
                //设置标注的标题为子路段的说明
                annotation.title = step.entraceInstruction
                /**
                 
                 当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
                 来生成标注对应的View
                 @param annotation 要添加的标注
                 */
//                mapView.addAnnotation(annotation)
                //统计路段所经过的地理坐标集合内点的个数
                pointCount += Int(step.pointsCount)
            }
            //+polylineWithPoints: count:指定的直角坐标点数组
            var points = [BMKMapPoint](repeating: BMKMapPoint(x: 0, y: 0), count: pointCount)
            var count = 0
             //遍历驾车路线中的所有路段
            for(_, item) in routeline.steps.enumerated() {
                //获取驾车路线中的每条路段
                let step: BMKDrivingStep = item as! BMKDrivingStep
                //遍历每条路段所经过的地理坐标集合点
                for index in 0..<Int(step.pointsCount) {
                    //将每条路段所经过的地理坐标点赋值给points
                    points[count].x = step.points[index].x
                    points[count].y = step.points[index].y
                    count += 1
                }
            }
            
            drawLine(routeLine: routeline, points: &points)
                
        } else {
            /// 检索失败
            print(result.description)
        }
    }
    
    //在地图上划出路径(等待两条路径规划完成后，一起画出来)
    func drawLine(routeLine:BMKDrivingRouteLine,points:inout [BMKMapPoint]){
        mapView.removeOverlays(mapView.overlays ?? [BMKOverlay]())
        if let polyline = BMKPolyline(points: &points, count: UInt(points.count)){
            mapView.add(polyline)
        }
        mapViewFitPolyline(points, mapView)
        
        searchPathAction?(routeLine.distance,routeLine.duration.minutes)
    }
    
    //根据polyline设置地图范围
    func mapViewFitPolyline(_ points: [BMKMapPoint], _ mapView: BMKMapView) {
        var leftTop_x: Double = 0
        var leftTop_y: Double = 0
        var rightBottom_x: Double = 0
        var rightBottom_y: Double = 0
        if points.count < 1 {
            return
        }
        let pt: BMKMapPoint = points[0]
        leftTop_x = pt.x
        leftTop_y = pt.y
        //左上方的点lefttop坐标（leftTop_x，leftTop_y）
        rightBottom_x = pt.x
        rightBottom_y = pt.y
        
        for index in 1..<points.count {
            let point: BMKMapPoint = points[Int(index)]
            if (point.x < leftTop_x) {
                leftTop_x = point.x
            }
            if (point.x > rightBottom_x) {
                rightBottom_x = point.x
            }
            if (point.y < leftTop_y) {
                leftTop_y = point.y
            }
            if (point.y > rightBottom_y) {
                rightBottom_y = point.y
            }
        }
        var rect: BMKMapRect = BMKMapRect()
        rect.origin = BMKMapPointMake(leftTop_x, leftTop_y)
        rect.size = BMKMapSizeMake(rightBottom_x - leftTop_x, rightBottom_y - leftTop_y)
//        let padding: UIEdgeInsets = UIEdgeInsets.init(top: 30, left: 30, bottom: bottomOffset + 30, right: 30)
        let padding: UIEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        mapView.fitVisibleMapRect(rect, edgePadding: padding, withAnimated: true)
    }
}
