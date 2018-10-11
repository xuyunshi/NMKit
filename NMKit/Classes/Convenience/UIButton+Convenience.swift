//
//  UIButton+Convenience.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

public extension UIButton {
    convenience init(title: String, textColor: UIColor, size: CGFloat, fontType: UIFont.NMFontType) {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont(type: fontType, size: size)
    }
}
