//
//  NMDeviceTool.swift
//  NMKit
//
//  Created by xuyunshi on 2018/10/11.
//

import Foundation

public class NMDeviceTool {
    static func applicationVersion() -> String? {
        guard
            let dic = Bundle.main.infoDictionary,
            let res = dic["CFBundleShortVersionString"] as? String
            else { return nil }
        return res
    }
}
