//
//  UIFont+Extension.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

extension UIFont {
    enum NMFontType {
        case regular
        case medium
        case light
        case semiBlod
    }
    
    convenience init(type: NMFontType, size: CGFloat) {
        let fontString: String
        switch type {
        case .regular:
            fontString = "PingFangSC-Regular"
        case .medium:
            fontString = "PingFangSC-Medium"
        case .light:
            fontString = "PingFangSC-Light"
        case .semiBlod:
            fontString = "PingFangSC-Semibold"
        }
        self.init(name: fontString, size: size)!
    }
}
