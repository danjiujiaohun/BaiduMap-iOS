//
//  BundleExt.swift
//  blogProject
//
//  Created by 梁江斌 on 2023/8/12.
//

import Foundation

public extension Bundle {
    func bundle(_ name: String) -> Bundle? {
        guard let url = self.url(forResource: name, withExtension: "bundle") else { return nil }
        return Bundle(url: url)
    }
}
