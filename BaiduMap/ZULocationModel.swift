//
//  ZULocationModel.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/5/17.
//

import Foundation
import CoreLocation
class ZULocationModel:NSObject,NSCoding {
    var provinceCode: String?
    var cityCode:String?
    var cityName:String?
    var name:String?
    var desc:String?
    var location:CLLocationCoordinate2D?
    
    required convenience public init?(coder aDecoder: NSCoder) {
        let provinceCode = aDecoder.decodeObject(forKey: "provinceCode") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let desc = aDecoder.decodeObject(forKey: "desc") as! String
        let cityCode = aDecoder.decodeObject(forKey: "cityCode") as! String
        let cityName = aDecoder.decodeObject(forKey: "cityName") as! String
        let locationString = aDecoder.decodeObject(forKey: "location") as! String
        let array = locationString.components(separatedBy: ",")
        if let lat = Double(array[0]),let lng = Double(array[1]) {
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            self.init(provinceCode: provinceCode, name: name, desc: desc, location: location,cityCode:cityCode,cityName:cityName)
        }else {
            let location = CLLocationCoordinate2D(latitude: 30.2089, longitude: 120.2187)
            self.init(provinceCode: provinceCode, name: name, desc: desc, location: location,cityCode:cityCode,cityName:cityName)
        }
    }
    func save() {
        guard let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        let locationPath = directory + "/location.data"
        guard var array = NSKeyedUnarchiver.unarchiveObject(withFile: locationPath) as? [ZULocationModel] else {
            var models = [ZULocationModel]()
            models.append(self)
            NSKeyedArchiver.archiveRootObject(models, toFile: locationPath)
            return }
        for location in array {
            if location.name == self.name {
                return
            }
        }
        array.append(self)
        NSKeyedArchiver.archiveRootObject(array, toFile: locationPath)
    }
    static func getLocationArray() -> [ZULocationModel]? {
        guard let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil}
        let locationPath = directory + "/location.data"
        guard var array = NSKeyedUnarchiver.unarchiveObject(withFile: locationPath) as? [ZULocationModel] else {return nil}
        return array
    }
    public func encode(with coder: NSCoder) {
        coder.encode(self.provinceCode, forKey: "provinceCode")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.desc, forKey: "desc")
        coder.encode(self.cityCode, forKey: "cityCode")
        coder.encode(self.cityName, forKey: "cityName")
        if let location = self.location {
            let locationString = "\(location.latitude),\(location.longitude)"
            coder.encode(locationString, forKey: "location")
        }
    }
    convenience init(provinceCode: String, name: String, desc: String,location:CLLocationCoordinate2D,cityCode:String,cityName:String) {
        self.init()
        self.provinceCode = provinceCode
        self.name = name
        self.desc = desc
        self.location = location
        self.cityCode = cityCode
        self.cityName = cityName
    }
}
