//
//  MapCenterAnnotationView.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/5/7.
//

import UIKit
import BaiduMapAPI_Map

class MapCenterAnnotation: BMKPointAnnotation {
    override init() {
        super.init()
    }
}

class MapCenterAnnotationView: BMKAnnotationView {
    
    override init!(annotation: BMKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 24.fit(), height: 34.fit())
        image = UIImage.image(.map_center_paopao)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
