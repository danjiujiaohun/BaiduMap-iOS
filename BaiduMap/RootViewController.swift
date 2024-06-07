//
//  RootViewController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/4/30.
//

import UIKit
import BaiduMapAPI_Base
import BaiduMapAPI_Map
import BaiduMapAPI_Search
import BaiduMapAPI_Utils

class RootViewController: MapViewController {
    private var searchTopBgView: UIView!
    private var currentLocationLabel: UILabel!
    private var arrowImageView: UIImageView!
    
    private var naviTopBgView: UIView!
    private var naviStartTextField: UITextField!
    private var naviEndTextField: UITextField!
    private var exchangeButton: UIButton!
    
    private var naviTimeBgView: UIView!
    private var naviTimeDescriptionLabel: UILabel!
    
    private var bottomBgView: UIView!
    private var locationButton: UIButton!
    private var lonInfoLabel: UILabel!
    private var latInfoLabel: UILabel!
    
    private var navigationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        setupLayout()
    }
    
    private func initView() {
        searchTopBgView = UIView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.safeAreaTop + 48.fit()))
        searchTopBgView.backgroundColor = UIColor.color(.color_FFFFFF)
        
        let tapSearchTopBgView = UITapGestureRecognizer(target: self, action: #selector(clickTopBgView))
        searchTopBgView.addGestureRecognizer(tapSearchTopBgView)
        searchTopBgView.isUserInteractionEnabled = true
        
        currentLocationLabel = UILabel.label("", textColor: UIColor.color(.color_24292B), font: UIFont.font(of: 16.fit(), weight: .regular))
        arrowImageView = UIImageView(image: UIImage.image(.arrow_icon))
        
        naviTopBgView = UIView(frame: CGRect(x: 0, y: -(Common.safeAreaTop + 120.fit()), width: Common.screenWidth, height: Common.safeAreaTop + 120.fit()))
        naviTopBgView.backgroundColor = UIColor.color(.color_FFFFFF)
        
        naviStartTextField = UITextField()
        naviStartTextField.backgroundColor = UIColor.color(.color_9DA2A5).withAlphaComponent(0.1)
        naviStartTextField.layer.cornerRadius = 8.fit()
        naviStartTextField.layer.masksToBounds = true
        naviStartTextField.text = "当前位置"
        naviStartTextField.font = UIFont.font(of: 14.fit(), weight: .regular)
        naviStartTextField.textColor = UIColor.color(.color_24292B)
        naviStartTextField.textAlignment = .left
        naviStartTextField.returnKeyType = .done
        naviStartTextField.delegate = self
        
        naviEndTextField = UITextField()
        naviEndTextField.backgroundColor = UIColor.color(.color_9DA2A5).withAlphaComponent(0.1)
        naviEndTextField.layer.cornerRadius = 8.fit()
        naviEndTextField.layer.masksToBounds = true
        naviEndTextField.placeholder = "输入您想要导航的目的地"
        naviEndTextField.font = UIFont.font(of: 14.fit(), weight: .regular)
        naviEndTextField.textColor = UIColor.color(.color_24292B)
        naviEndTextField.textAlignment = .left
        naviEndTextField.returnKeyType = .done
        naviEndTextField.delegate = self
        
        exchangeButton = UIButton(type: .custom)
        exchangeButton.setImage(UIImage.image(.exchange_icon), for: .normal)
        exchangeButton.setImage(UIImage.image(.exchange_icon), for: .highlighted)
        exchangeButton.addTarget(self, action: #selector(clickExchangeBtn), for: .touchUpInside)
        
        naviTimeBgView = UIView(frame: CGRect(x: 0, y: -(Common.safeAreaTop + 48.fit()), width: Common.screenWidth, height: Common.safeAreaTop + 48.fit()))
        naviTimeBgView.backgroundColor = UIColor.color(.color_FFFFFF)
        
        naviTimeDescriptionLabel = UILabel.label("", textColor: UIColor.color(.color_24292B), font: UIFont.font(of: 14.fit(), weight: .regular))
        
        bottomBgView = UIView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.safeAreaBottom + 32.fit()))
        bottomBgView.backgroundColor = UIColor.color(.color_FFFFFF)
        
        locationButton = UIButton(type: .custom)
        locationButton.setImage(UIImage.image(.location_btn), for: .normal)
        locationButton.setImage(UIImage.image(.location_btn), for: .highlighted)
        locationButton.addTarget(self, action: #selector(clickLocationButton), for: .touchUpInside)
        
        lonInfoLabel = UILabel.label("当前经度：", textColor: UIColor.color(.color_24292B), font: UIFont.font(of: 14.fit(), weight: .medium))
        latInfoLabel = UILabel.label("当前纬度：", textColor: UIColor.color(.color_24292B), font: UIFont.font(of: 14.fit(), weight: .medium))
        
        navigationButton = UIButton(type: .custom)
        navigationButton.frame = CGRect(x: 0, y: 0, width: 68.fit(), height: 32.fit())
        navigationButton.backgroundColor = UIColor.color(.color_FF8100)
        navigationButton.setTitle("去导航", for: .normal)
        navigationButton.titleLabel?.font = UIFont.font(of: 14.fit(), weight: .regular)
        navigationButton.setTitleColor(UIColor.color(.color_FFFFFF), for: .normal)
        navigationButton.layer.cornerRadius = 16.fit()
        navigationButton.layer.masksToBounds = true
        navigationButton.addTarget(self, action: #selector(clickNavigationBtn), for: .touchUpInside)
        navigationButton.isHidden = true
        
        view.addSubview(searchTopBgView)
        searchTopBgView.addSubview(currentLocationLabel)
        searchTopBgView.addSubview(arrowImageView)
        
        view.addSubview(naviTopBgView)
        naviTopBgView.addSubview(naviStartTextField)
        naviTopBgView.addSubview(naviEndTextField)
        naviTopBgView.addSubview(exchangeButton)
        
        view.addSubview(naviTimeBgView)
        naviTimeBgView.addSubview(naviTimeDescriptionLabel)
        
        view.addSubview(bottomBgView)
        view.addSubview(locationButton)
        bottomBgView.addSubview(lonInfoLabel)
        bottomBgView.addSubview(latInfoLabel)
        bottomBgView.addSubview(navigationButton)
    }
    
    private func setupLayout() {
        currentLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(Common.statusBarHeight + 8.fit())
            make.left.equalTo(32.fit())
            make.right.lessThanOrEqualTo(-40.fit())
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(currentLocationLabel)
            make.right.equalTo(-32.fit())
            make.size.equalTo(CGSize(width: 12.fit(), height: 20.fit()))
        }
        
        naviStartTextField.snp.makeConstraints { make in
            make.top.equalTo(Common.safeAreaTop)
            make.left.equalTo(32.fit())
            make.right.equalTo(-64.fit())
            make.height.equalTo(40.fit())
        }
        
        naviEndTextField.snp.makeConstraints { make in
            make.top.equalTo(naviStartTextField.snp.bottom).offset(8.fit())
            make.left.right.equalTo(naviStartTextField)
            make.height.equalTo(naviStartTextField)
        }
        
        exchangeButton.snp.makeConstraints { make in
            make.right.equalTo(-16.fit())
            make.centerY.equalTo(Common.safeAreaTop + 44.fit())
            make.size.equalTo(CGSize(width: 44.fit(), height: 44.fit()))
        }
        
        naviTimeDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(Common.safeAreaTop + 8.fit())
            make.centerX.equalToSuperview()
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
        
        navigationButton.snp.makeConstraints { make in
            make.top.equalTo(bottomBgView).offset(6.fit())
            make.right.equalTo(-12.fit())
            make.size.equalTo(CGSize(width: 68.fit(), height: 32.fit()))
        }
    }
    
    //MARK: - Method
    /// 更新当前选中的地址
    private func updateCurrentLocation(currentLocationText: String) {
        self.currentLocationLabel.text = currentLocationText
    }
    
    /// 是否展示导航摁钮
    private func isShowNavigationButton() {
        if (truncateFloat(currentUserLatitude, toPrecision: 4) != truncateFloat(currentLatitude, toPrecision: 4) ||
            truncateFloat(currentUserLongitude, toPrecision: 4) != truncateFloat(currentLongitude, toPrecision: 4)) {
            navigationButton.isHidden = false
            
        } else {
            navigationButton.isHidden = true
        }
    }
    
    public func truncateFloat(_ value: Double?, toPrecision precision: Int) -> Double {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = precision
        formatter.maximumFractionDigits = precision
        let stringValue = formatter.string(from: NSNumber(value: value ?? 0.0)) ?? ""
        return Double(stringValue) ?? 0.0
    }
    
    /// 向上平移
    func toUpTranslation(targetView: UIView, y: CGFloat) {
        let animation = CABasicAnimation(keyPath: "position")
        /// 开始的位置
        animation.fromValue = CGPoint(x: targetView.layer.position.x, y: targetView.layer.position.y)
        /// 移动到的位置
        animation.toValue = CGPoint(x: targetView.layer.position.x, y: y)
        
        /// 动画持续时间
        animation.duration = 0.3
        /// 动画填充模式
        animation.fillMode = .forwards
        /// 动画完成不删除
        animation.isRemovedOnCompletion = false
        
        /// 添加动画
        targetView.layer.add(animation, forKey: "animation")
        
        /// 重新设置坐标
        targetView.center = CGPoint(x: targetView.layer.position.x, y: y)
    }
    
    /// 向下平移
    func toDownTranslation(targetView: UIView, y: CGFloat) {
        let animation = CABasicAnimation(keyPath: "position")
        /// 开始的位置
        animation.fromValue = CGPoint(x: targetView.layer.position.x, y: targetView.layer.position.y)
        /// 移动到的位置
        animation.toValue = CGPoint(x: targetView.layer.position.x, y: y)
        
        /// 动画持续时间
        animation.duration = 0.3
        /// 动画填充模式
        animation.fillMode = .forwards
        /// 动画完成不删除
        animation.isRemovedOnCompletion = false
        
        /// 添加动画
        targetView.layer.add(animation, forKey: "animation")
        
        /// 重新设置坐标
        targetView.center = CGPoint(x: targetView.layer.position.x, y: y)
    }
    
    /// 向左平移
    func toLeftTranslation(targetView: UIView, x: CGFloat) {
        let animation = CABasicAnimation(keyPath: "position")
        /// 开始的位置
        animation.fromValue = CGPoint(x: targetView.layer.position.x, y: targetView.layer.position.y)
        /// 移动到的位置
        animation.toValue = CGPoint(x: x, y: targetView.layer.position.y)
        
        /// 动画持续时间
        animation.duration = 0.3
        /// 动画填充模式
        animation.fillMode = .forwards
        /// 动画完成不删除
        animation.isRemovedOnCompletion = false
        
        /// 添加动画
        targetView.layer.add(animation, forKey: "animation")
        
        /// 重新设置坐标
        targetView.center = CGPoint(x: x, y: targetView.layer.position.y)
    }
    
    /// 向右平移
    func toRightTranslation(targetView: UIView, x: CGFloat) {
        let animation = CABasicAnimation(keyPath: "position")
        /// 开始的位置
        animation.fromValue = CGPoint(x: targetView.layer.position.x, y: targetView.layer.position.y)
        /// 移动到的位置
        animation.toValue = CGPoint(x: x, y: targetView.layer.position.y)
        
        /// 动画持续时间
        animation.duration = 0.3
        /// 动画填充模式
        animation.fillMode = .forwards
        /// 动画完成不删除
        animation.isRemovedOnCompletion = false
        
        /// 添加动画
        targetView.layer.add(animation, forKey: "animation")
        
        /// 重新设置坐标
        targetView.center = CGPoint(x: x, y: targetView.layer.position.y)
    }
    
    //MARK: - 重写方法
    override func locationSuccess() {
        if let lon = currentLongitude, let lat = currentLatitude {
            lonInfoLabel.text = "当前用户经度：\(lon)"
            latInfoLabel.text = "当前用户纬度：\(lat)"
        }
        
        if let locationName = locationName {
            self.updateCurrentLocation(currentLocationText: locationName)
        }
        
        isShowNavigationButton()
    }
    
    override func regionDidChange(latitude: Double, longitude: Double) {
        lonInfoLabel.text = "当前屏幕中心经度：\(longitude)"
        latInfoLabel.text = "当前屏幕中心纬度: \(latitude)"
    }
    
    override func getReverseGeoResultSuccess() {
        if let locationNameValue = self.locationName {
            self.updateCurrentLocation(currentLocationText: locationNameValue)
            self.naviEndTextField.text = locationNameValue
            isShowNavigationButton()
        }
    }

    //MARK: - Action
    @objc
    private func clickLocationButton() {
        moveToUserLocation()
        reShowCenterAnnotationView()
        mapView.zoomLevel = 17
        
        self.toDownTranslation(targetView: searchTopBgView, y: (Common.safeAreaTop + 48.fit())/2.0)
        self.toUpTranslation(targetView: naviTopBgView, y: -(Common.safeAreaTop + 120.fit())/2.0)
        self.toUpTranslation(targetView: naviTimeBgView, y: -(Common.safeAreaTop + 48.fit())/2.0)
        
        self.navigationButton.removeTarget(self, action: #selector(checkRouteBtn), for: .touchUpInside)
        self.navigationButton.addTarget(self, action: #selector(clickNavigationBtn), for: .touchUpInside)
        
        navigationButton.setTitle("去导航", for: .normal)
    }
    
    @objc
    private func clickNavigationBtn() {
        print("========去导航")
        
        self.toUpTranslation(targetView: searchTopBgView, y: -(Common.safeAreaTop + 48.fit())/2.0)
        self.toDownTranslation(targetView: naviTopBgView, y: (Common.safeAreaTop + 120.fit())/2.0)
        
        self.navigationButton.removeTarget(self, action: #selector(clickNavigationBtn), for: .touchUpInside)
        self.navigationButton.addTarget(self, action: #selector(checkRouteBtn), for: .touchUpInside)
        navigationButton.setTitle("查看路线", for: .normal)
    }
    
    @objc
    private func checkRouteBtn() {
        print("========查看路线")
        
        searchDrivingRoute(startLocationName: naviStartTextField.text, endLocationName: naviEndTextField.text)
        
        searchPathAction = { distance, time in
            self.naviTimeDescriptionLabel.text = "距离共\(Double(distance/1000))km，驾车预计\(time)分钟后到达"
        }
        
        self.toUpTranslation(targetView: naviTopBgView, y: -(Common.safeAreaTop + 120.fit())/2.0)
        self.toDownTranslation(targetView: naviTimeBgView, y: (Common.safeAreaTop + 48.fit())/2.0)
        
        self.navigationButton.removeTarget(self, action: #selector(checkRouteBtn), for: .touchUpInside)
        self.navigationButton.addTarget(self, action: #selector(startNavigation), for: .touchUpInside)
        navigationButton.setTitle("开始导航", for: .normal)
    }
    
    @objc
    private func startNavigation() {
        print("========开始导航")
        
        if let locationLng = currentEndLongitude, let locationLat = currentEndLatitude, let locationAddress = currentEndLocationName {
            /// 百度使用的是bd09Coord坐标系，导航时需装换为gcj02Coord
            let bd09Coord = CLLocationCoordinate2DMake(locationLat, locationLng)
            let gcj02Coord = BMKCoordTrans(bd09Coord, BMK_COORD_TYPE.COORDTYPE_BD09LL, BMK_COORD_TYPE.COORDTYPE_COMMON)
            
            let alertView = GuideAlertView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: 202.fit()+Common.safeAreaBottom), latitude: gcj02Coord.latitude, longitude: gcj02Coord.longitude, address: locationAddress)
            let alert = ZUAlert(contentView: alertView, preferredContentSize: CGSize(width: Common.screenWidth, height: 202.fit()+Common.safeAreaBottom), actions: [])

            let alertController = ZUAlertController.actionSheetViewController(alert: alert)
            alertController.view.backgroundColor = .clear

            alertView.gaodeMapButtonAciton = {
                alertController.dismiss(animated: true)
            }
            
            alertView.baiduMapButtonAciton = {
                alertController.dismiss(animated: true)
            }
            
            alertView.cancelButtonAciton = {
                alertController.dismiss(animated: true)
            }
            
            self.present(alertController, animated: true)
        }
    }
    
    @objc
    private func clickTopBgView() {
        let vc = AddressSearchViewController()
        vc.transferSelectionLocation = { [self] locationModel in
            if let name = locationModel.name, let l = locationModel.location {
                moveToCustomLocation(latitude: l.latitude, longitude: l.longitude)
                updateCurrentLocation(currentLocationText: name)
                isShowNavigationButton()
            }
        }
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击交换导航初始末尾地址
    @objc
    private func clickExchangeBtn() {
        print("=====交换导航始末位置")
        
        let startLocation = naviStartTextField.text
        naviStartTextField.text = naviEndTextField.text
        naviEndTextField.text = startLocation
    }
}

extension RootViewController: UITextFieldDelegate {
    
}
