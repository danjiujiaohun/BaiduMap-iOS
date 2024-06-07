//
//  HUD.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/6/7.
//

import Foundation
import SVProgressHUD

class HUD {
    
    func showSuccess(status: String) {
        SVProgressHUD.showSuccess(withStatus: status)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            SVProgressHUD.dismiss()
        })
    }
    
    func showErrorStr(errorStr: String) {
        SVProgressHUD.showError(withStatus: errorStr)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            SVProgressHUD.dismiss()
        })
    }
    
    func showError(_ error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            SVProgressHUD.dismiss()
        })
    }
    
    func dismess() {
        SVProgressHUD.dismiss()
    }
}
