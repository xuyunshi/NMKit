//
//  EasyConst.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

/// 屏幕宽度
let ScreenWidth = UIScreen.main.bounds.width

/// 屏幕高度
let ScreenHeight = UIScreen.main.bounds.height

/// 是否有刘海
let isIPhoneX = ScreenHeight >= 812

/// 顶部状态栏高度
let TopSafeAreaHeight: CGFloat = isIPhoneX ? 44 : 20

/// 导航栏高度
let NaviBarHeight: CGFloat = isIPhoneX ? 88 : 64

/// 底部安全高度
let BottomSafeAreaHeight: CGFloat = isIPhoneX ? 34 : 0
