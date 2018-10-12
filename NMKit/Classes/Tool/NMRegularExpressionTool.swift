//
//  NMRegularExpressionTool.swift
//  NMKit
//
//  Created by xuyunshi on 2018/10/12.
//

import Foundation

public class NMRegularExpressionTool {
    
    /// 验证身份证号
    static func validateIdentityCard(_ id: String) -> Bool {
        if id.count <= 0 { return false }
        let rex2 = NSString(string: "^(\\d{14}|\\d{17})(\\d|[xX])$")
        let predicate = NSPredicate(format: "SELF MATCHES %@", rex2)
        return predicate.evaluate(with: id)
    }
    
    /// 验证邮箱
    static func validateEmail(_ mail: String) ->Bool {
        let rex2 = NSString(string: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        let predicate = NSPredicate(format: "SELF MATCHES %@", rex2)
        return predicate.evaluate(with: mail)
    }
    
    /// 手机号验证
    static func validMobliePhone(_ phone: String) ->Bool {
        let rex2 = NSString(string: "^1[3|4|5|6|7|8|9]\\d{9}$")
        let predicate = NSPredicate(format: "SELF MATCHES %@", rex2)
        return predicate.evaluate(with: phone)
    }
    
    /// 是否只包含数字
    static func validOnlyNumber(_ s: String) ->Bool {
        let rex2 = NSString(string: "^[0-9]*$")
        let predicate = NSPredicate(format: "SELF MATCHES %@", rex2)
        return predicate.evaluate(with: s)
    }
    
    /// 是否只包含字母
    static func validOnlyLetter(_ s: String) ->Bool {
        let rex2 = NSString(string: "^[a-zA-Z]*$")
        let predicate = NSPredicate(format: "SELF MATCHES %@", rex2)
        return predicate.evaluate(with: s)
    }
    
    /// 验证最多的小数点位数
    static func validNumebr(number: String, floatMax: Int) -> Bool {
        let rex2 = NSString(string: String(format: "(\\+|\\-)?(([0]|(0[.]\\d{0,%lu}))|([1-9]\\d{0,4}(([.]\\d{0,%lu})?)))?", floatMax, floatMax))
        let predicate = NSPredicate(format: "SELF MATCHES %@", rex2)
        return predicate.evaluate(with: number)
    }
    
}
