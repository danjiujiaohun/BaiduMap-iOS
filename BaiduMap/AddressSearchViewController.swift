//
//  AddressSearchViewController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/5/16.
//

import UIKit
import BaiduMapAPI_Map
import BaiduMapAPI_Search
import BaiduMapAPI_Utils
import BMKLocationKit

class AddressSearchViewController: BaseViewController,
                                   BMKGeoCodeSearchDelegate,
                                   CLLocationManagerDelegate,
                                   BMKSuggestionSearchDelegate {
    private var backButton: UIButton!
    private var searchBgView: UIView!
    private var cityLabel: UILabel!
    private var lineView: UIView!
    private var addressTextField: UITextField!
    private var myTableView: UITableView!

    private var city = "杭州市"
    private var address = ""
    
    private var suggestionAddressesList = [ZULocationModel]()
    
    private var locationManager: CLLocationManager!
    
    /// 传递至外部 传递选择的地址信息model
    var transferSelectionLocation: ((ZULocationModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        initView()
        setupLayout()
    }
    
    private func setupNav() {
        isNavBarisTranslucent = true
        isNavBarisHidden = true
        
        backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.image(.back_icon), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 44.fit(), height: 44.fit())
        backButton.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(Common.statusBarHeight)
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 44.fit(), height: 44.fit()))
        }
    }
    
    private func initView() {
        self.view.backgroundColor = UIColor.color(.color_FFFFFF)
        
        searchBgView = UIView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth - 60.fit(), height: Common.navigationBarHeight))
        searchBgView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        searchBgView.layer.cornerRadius = 8.fit()
        searchBgView.layer.masksToBounds = true
        searchBgView.isUserInteractionEnabled = true
        
        cityLabel = UILabel.label(city, textColor: UIColor.color(.color_24292B), font: UIFont.font(of: 14.fit(), weight: .regular))
        
        lineView = UIView(frame: CGRect(x: 0, y: 0, width: 1.fit(), height: 16.fit()))
        lineView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        
        addressTextField = UITextField()
        addressTextField.placeholder = "输入想要去的地址"
        addressTextField.font = UIFont.font(of: 14.fit(), weight: .regular)
        addressTextField.textColor = UIColor.color(.color_24292B)
        addressTextField.textAlignment = .left
        addressTextField.returnKeyType = .done
        addressTextField.delegate = self
        
        myTableView = UITableView(frame: .zero, style: .plain)
        myTableView.backgroundColor = UIColor.color(.color_FFFFFF)
        myTableView.showsVerticalScrollIndicator = false
        myTableView.separatorStyle = .none
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.register(suggestionLocationCell.self, forCellReuseIdentifier: NSStringFromClass(suggestionLocationCell.self))
        
        view.addSubview(searchBgView)
        searchBgView.addSubview(cityLabel)
        searchBgView.addSubview(lineView)
        searchBgView.addSubview(addressTextField)
        view.addSubview(myTableView)
    }
    
    private func setupLayout() {
        searchBgView.snp.makeConstraints { make in
            make.top.equalTo(Common.statusBarHeight)
            make.right.equalTo(-16.fit())
            make.size.equalTo(CGSize(width: Common.screenWidth - 60.fit(), height: Common.navigationBarHeight))
        }
        
        cityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(8.fit())
        }
        
        lineView.snp.makeConstraints { make in
            make.left.equalTo(cityLabel.snp.right).offset(4.fit())
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 1.fit(), height: 16.fit()))
        }
        
        addressTextField.snp.makeConstraints { make in
            make.left.equalTo(lineView.snp.right).offset(4.fit())
            make.centerY.equalToSuperview()
            make.right.equalTo(-8.fit())
            make.height.equalTo(searchBgView)
        }
        
        myTableView.snp.makeConstraints { make in
            make.top.equalTo(Common.navigatorHeight + 8.fit())
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func postSuggestionSearch() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let text = self.address
        let search = BMKSuggestionSearch()
        search.delegate = self
        let option = BMKSuggestionSearchOption()
        option.cityname = self.city
        option.keyword = text
        option.cityLimit = true
        search.suggestionSearch(option)
    }
    
    //MARK: - Action
    @objc
    private func clickBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onGetSuggestionResult(_ searcher: BMKSuggestionSearch!, result: BMKSuggestionSearchResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            guard let suggestionList = result.suggestionList else {return}
            self.suggestionAddressesList.removeAll()
            for suggestion in suggestionList {
                let locationModel = ZULocationModel()
                locationModel.name = suggestion.key
                if suggestion.address.isEmpty {
                    locationModel.desc = suggestion.key
                }else {
                    locationModel.desc = suggestion.address
                }
                locationModel.location = suggestion.location
                locationModel.cityName = suggestion.city
        
                self.suggestionAddressesList.append(locationModel)
            }
            self.myTableView.reloadData()
        }
    }
    
}

extension AddressSearchViewController: UITableViewDelegate,
                                       UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestionAddressesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(suggestionLocationCell.self), for: indexPath) as! suggestionLocationCell
        let model = suggestionAddressesList[indexPath.row]
        if let addressName = model.name, let addressDesc = model.desc {
            cell.updateCellInfo(locationTitle: addressName, locationAddress: addressDesc)
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.fit()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let model = self.suggestionAddressesList[row]
        
        self.navigationController?.popViewController(animated: true)
        self.transferSelectionLocation?(model)
    }
}

extension AddressSearchViewController: UITextFieldDelegate {
    /// 判断是否为输入状态
    private func isTextFieldInputState(textField: UITextField) -> Bool {
        let lang = textField.textInputMode?.primaryLanguage
        if lang == "zh-Hans" {
            if let textRange = textField.markedTextRange {
                if let position = textField.position(from: textRange.start, offset: 0) {
                    return true
                }
            }
        }
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let inputText = textField.text ?? ""
        
        if !isTextFieldInputState(textField: textField) {
            address = inputText
            postSuggestionSearch()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        
        /// 当点击return，收起键盘
        if string == "\n" {
            textField.resignFirstResponder()
            
            return false
        }
        
        if isTextFieldInputState(textField: textField) {
            return true
        }
        
        return true
    }
}
