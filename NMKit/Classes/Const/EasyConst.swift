//
//  EasyConst.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

/// 屏幕宽度
public let ScreenWidth = UIScreen.main.bounds.width

/// 屏幕高度
public let ScreenHeight = UIScreen.main.bounds.height

/// 是否有刘海
public let isIPhoneX = ScreenHeight >= 812

/// 顶部状态栏高度
public let TopSafeAreaHeight: CGFloat = isIPhoneX ? 44 : 20

/// 导航栏高度
public let NaviBarHeight: CGFloat = isIPhoneX ? 88 : 64

/// 底部安全高度
public let BottomSafeAreaHeight: CGFloat = isIPhoneX ? 34 : 0
