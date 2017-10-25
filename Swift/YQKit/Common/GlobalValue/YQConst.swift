//
//  YQConst.swift
//  Demo
//
//  Created by maygolf on 2017/9/25.
//  Copyright © 2017年 yiquan. All rights reserved.
//

import Foundation
import UIKit

// 系统信息
struct YQSystemInfo {
    // 版本号
    static let version = Float(UIDevice.current.systemVersion)!
}

// UI相关
struct YQUserInterface {
    
    // 屏幕尺寸
    enum ScreenInch: CGFloat {
        case iphone4    = 3.5
        case iphone5    = 4.0
        case iphone6    = 4.7
        case iphone6p   = 5.5
        case iphoneX    = 5.8
    }
    
    // 大小
    struct Size {
        static let screen = UIScreen.main.bounds.size
        
        static func screenForInch(inch: ScreenInch) -> CGSize{
            switch inch {
                
            case .iphone4:
                return CGSize(width: 320.0, height: 480.0)
                
            case .iphone5:
                return CGSize(width: 320.0, height: 568.0)
                
            case .iphone6:
                return CGSize(width: 375.0, height: 667.0)
                
            case .iphone6p:
                return CGSize(width: 414.0, height: 736.0)
                
            case .iphoneX:
                return CGSize(width: 375.0, height: 812.0)
            }
        }
    }
    
    // 宽度
    struct Width {
        static let screen = Size.screen.width
    }
    
    // 高度
    struct Height {
        static let statusBar: CGFloat = YQSystemInfo.version >= 11.0 ? 44.0 : 20.0
        static let navigationBar: CGFloat = 44.0
        static let navigationAndStatusBar = statusBar + navigationBar
        static let tabBar: CGFloat = 49.0
        static let toolBar: CGFloat = 44.0
        static let searchBar: CGFloat = 44.0
        
        static let screen = Size.screen.height
    }
    
    // 屏幕缩放比
    static let screenScale = UIScreen.main.scale
    
    // 按屏幕尺寸尽心缩放
    static func scaleSize(size: CGFloat, referSize: CGFloat = Size.screenForInch(inch: .iphone6).width,
                          baseSize: CGFloat = Width.screen) -> CGFloat{
        return size * baseSize / referSize
    }
}

struct YQPath {
    // 沙盒
    struct Sanbox {
        static let temp = NSTemporaryDirectory()
        static let Document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        static let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }
}


struct YQApplication {
    // app名称
    static let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
    // 版本号
    static let versionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
    static let version = Double(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String)
}

// 设备
struct YQDevice {
    // 是否iPhone
    let isIphone = UI_USER_INTERFACE_IDIOM() == .phone
    // 是否ipad
    let isIpad = UI_USER_INTERFACE_IDIOM() == .pad
    // 是否ipod
    let isIpod = UIDevice.current.model == "iPod touch"
    
    // 是否真机
    #if TARGET_OS_IPHONE
        let isDevice = true
    #else
        let isDevice = false
    #endif
    
    // 是否模拟器
    #if TARGET_IPHONE_SIMULATOR
        let isSimulator = true
    #else
        let isSimulator = false
    #endif
}

struct YQSettingUrl {
    
    let general                                  = "prefs:root=General"
    let abour                                    = "prefs:root=General&path=About"
    let accessibility                            = "prefs:root=General&path=ACCESSIBILITY"
    let airplanMode                              = "prefs:root=AIRPLANE_MODE"
    let autoLock                                 = "prefs:root=General&path=AUTOLOCK"
    let cellularUsage                            = "prefs:root=General&path=USAGE/CELLULAR_USAGE"
    let brightness                               = "prefs:root=Brightness"
    let bluetooth                                = "prefs:root=Bluetooth"
    let dateAndTime                              = "prefs:root=General&path=DATE_AND_TIME"
    let faceTime                                 = "prefs:root=FACETIME"
    let keyboard                                 = "prefs:root=General&path=Keyboard"
    let castle                                   = "prefs:root=CASTLE"
    let storageAndBackup                         = "prefs:root=CASTLE&path=STORAGE_AND_BACKUP"
    let international                            = "prefs:root=General&path=INTERNATIONAL"
    let locationServices                         = "prefs:root=LOCATION_SERVICES"
    let accountSettings                          = "prefs:root=ACCOUNT_SETTINGS"
    let music                                    = "prefs:root=MUSIC"
    let musicEQ                                  = "prefs:root=MUSIC&path=EQ"
    let volumeLimit                              = "prefs:root=MUSIC&path=VolumeLimit"
    let network                                  = "prefs:root=General&path=Network"
    let nikePlusIpod                             = "prefs:root=NIKE_PLUS_IPOD"
    let notes                                    = "prefs:root=NOTES"
    let notificationsId                          = "prefs:root=NOTIFICATIONS_ID"
    let iphone                                   = "prefs:root=Phone"
    let iphones                                  = "prefs:root=Photos"
    let managedConfigurationList                 = "prefs:root=General&path=ManagedConfigurationList"
    let reste                                    = "prefs:root=General&path=Reset"
    let ringtone                                 = "prefs:root=Sounds&path=Ringtone"
    let safari                                   = "prefs:root=Safari"
    let assistant                                = "prefs:root=General&path=Assistant"
    let sounds                                   = "prefs:root=Sounds"
    let softwareUpdateLink                       = "prefs:root=General&path=SOFTWARE_UPDATE_LINK"
    let store                                    = "prefs:root=STORE"
    let twitter                                  = "prefs:root=TWITTER"
    let faceBook                                 = "prefs:root=FACEBOOK"
    let video                                    = "prefs:root=VIDEO"
    let usage                                    = "prefs:root=General&path=USAGE"
    let vpn                                      = "prefs:root=General&path=Network/VPN"
    let wallpaper                                = "prefs:root=Wallpaper"
    let wifi                                     = "prefs:root=WIFI"
    let internetTethering                        = "prefs:root=INTERNET_TETHERING"
    let blocked                                  = "prefs:root=Phone&path=Blocked"
    let doNotDisturb                             = "prefs:root=DO_NOT_DISTURB"
}
