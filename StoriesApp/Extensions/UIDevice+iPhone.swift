//
//  UIDevice+iPhone.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

extension UIDevice {
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var isSmallScreen: Bool {
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE
            || UIDevice.current.screenType == .iPhone4_4S {
            return true
        } else {
            return false
        }
    }
    
    var isXScreen: Bool {
        if UIDevice.current.screenType == .iPhoneXR
            || UIDevice.current.screenType == .iPhoneXSMax
            || UIDevice.current.screenType == .iPhoneX_iPhoneXS  {
            return true
        } else {
            return false
        }
    }
    
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneXR = "iPhone XR"
        case iPhoneX_iPhoneXS = "iPhone X,iPhoneXS"
        case iPhoneXSMax = "iPhoneXS Max"
        case unknown
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhoneXR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX_iPhoneXS
        case 2688:
            return .iPhoneXSMax
        default:
            return .unknown
        }
    }
}
