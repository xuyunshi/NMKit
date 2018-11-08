//
//  String+Extension.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

public extension NMKit where Base: StringProtocol {
    
    func height(with width: CGFloat, font: UIFont, maxHeight: CGFloat, attributes: [NSAttributedStringKey:Any] = [:]) ->CGFloat {
        var attributes = attributes
        if attributes[NSAttributedStringKey.font] == nil {
            attributes[NSAttributedStringKey.font] = font
        }
        let rect = NSString(string: String(self.base)).boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.height
    }
    
    /// 判断是否为空或者全部为空空格
    func isEmptyOrAllSpacing() ->Bool {
        if self.base.isEmpty {
            return true
        } else {
            for i in self.base {
                if i != " " {
                    return false
                }
            }
            return true
        }
    }
    
    /// 保留小数点位数
    func stringWithKeepDecimalsWithCount(_ c: Int) -> String {
        var o = String(self.base)
        let pointindex = o.index(of: ".")
        guard let pIndex = pointindex else { return o }
        guard pIndex.encodedOffset < o.count else {
            return o
        }
        let countOffset = o.count - pIndex.encodedOffset - 1
        if countOffset < c {
            for _ in 0..<c - countOffset {
                o.append("0")
            }
            return o
        } else {
            return String(o[o.startIndex...o.index(pIndex, offsetBy: c)])
        }
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

extension String: NMKitCompatible {} 
