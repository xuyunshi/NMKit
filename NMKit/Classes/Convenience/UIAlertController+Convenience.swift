//
//  UIAlertController+Extension.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

extension UIAlertController {
    static func normalCheckAlertWithTitle(_ title: String, completion: @escaping (()->Void)) -> UIAlertController {
        let a = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let a0 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let a1 = UIAlertAction(title: "确定", style: .default) { (action) in
            completion()
        }
        a.addAction(a0)
        a.addAction(a1)
        return a
    }
}
