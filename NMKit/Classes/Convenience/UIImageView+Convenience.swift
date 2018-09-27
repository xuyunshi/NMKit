//
//  UIImageView+Convenience.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

extension UIImageView {
    convenience init(imageName: String) {
        self.init(image: UIImage(named: imageName))
    }
}
