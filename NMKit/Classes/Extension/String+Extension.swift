//
//  String+Extension.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

extension NMKit where Base: StringProtocol {
    
    func height(with width: CGFloat, font: UIFont, maxHeight: CGFloat, attributes: [NSAttributedStringKey:Any] = [:]) ->CGFloat {
        var attributes = attributes
        if attributes[NSAttributedStringKey.font] == nil {
            attributes[NSAttributedStringKey.font] = font
        }
        let rect = NSString(string: String(self.base)).boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.height
    }
    
    /// 直接用string发送通知
    func postNotification() {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: String(self.base))))
    }
    
    /// 用string创建一个NotificationName
    func notificationName() ->Notification.Name {
        return Notification.Name(rawValue: String(self.base))
    }
}
