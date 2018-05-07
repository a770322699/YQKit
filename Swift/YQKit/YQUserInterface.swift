//
//  UserInterface.swift
//  BiuBiu
//
//  Created by meizu on 2018/3/30.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

// MARK: const value
extension YQ {
    struct Const {
        static func screenSizeForDevice(_ model: Device.Model) -> CGSize?{
            switch model {
            case .iphone4, .iphone4s:
                return CGSize.init(width: 320, height: 480)
            case .iphone5, .iphone5s, .iphone5c, .iphoneSE:
                return CGSize.init(width: 320, height: 568)
            case .iphone6, .iphone7, .iphone8, .iphone6s:
                return CGSize.init(width: 375, height: 667)
            case .iphone6p, .iphone7p, .iphone8p, .iphone6sp:
                return CGSize.init(width: 414, height: 736)
            case .iphoneX:
                return CGSize.init(width: 375, height: 812)
            default:
                break
            }
            
            return nil
        }
        
        // 因为top要考虑到状态栏和导航栏的隐藏情况， 所以， top是一个无效的值，
        // bottom 也没有考虑到 tabbar
        static var safeInset: UIEdgeInsets{
            if Device.currentModel == .iphoneX {
                let orientation = UIApplication.shared.statusBarOrientation
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    return UIEdgeInsets.init(top: 0, left: 0, bottom: 21, right: 0)
                } else {
                    return UIEdgeInsets.init(top: 0, left: 0, bottom: 34, right: 0)
                }
            }
            return UIEdgeInsets.zero
        }
    }
}

// MARK: status bar
extension YQ {
    struct StatusBar {
        static var height: CGFloat{
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

// MARK: screen
extension YQ {
    struct Screen {
        static var uiscreen: UIScreen{
            return UIScreen.main
        }
        
        static var size: CGSize{
            return uiscreen.bounds.size
        }
        
        static var height: CGFloat{
            return size.height
        }
        
        static var width: CGFloat{
            return size.width
        }
        
        static var scale: CGFloat{
            return uiscreen.scale
        }
        
        static var maxSize: CGFloat{
            return max(width, height)
        }
        
        static var minSize: CGFloat{
            return min(width, height)
        }
    }
}

// MARK: device
extension YQ{
    struct Device {
        let isIphone = UI_USER_INTERFACE_IDIOM() == .phone
        let isIpad = UI_USER_INTERFACE_IDIOM() == .pad
        var isSimulator: Bool{
            var isSim = false
            #if arch(i386) || arch(x86_64)
            isSim = true
            #endif
            return isSim
        }
    }
}

extension YQ.Device {
    enum Model {
        case other
        case iphone4
        case iphone4s
        case iphone5
        case iphone5s
        case iphone5c
        case iphone6
        case iphone6p
        case iphone6s
        case iphone6sp
        case iphoneSE
        case iphone7
        case iphone7p
        case iphone8
        case iphone8p
        case iphoneX
    }
    
    static var currentModel: Model{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return .iphone4
        case "iPhone4,1":                               return .iphone4s
        case "iPhone5,1", "iPhone5,2":                  return .iphone5
        case "iPhone5,3", "iPhone5,4":                  return .iphone5c
        case "iPhone6,1", "iPhone6,2":                  return .iphone5s
        case "iPhone7,2":                               return .iphone6
        case "iPhone7,1":                               return .iphone6p
        case "iPhone8,1":                               return .iphone6s
        case "iPhone8,2":                               return .iphone6sp
        case "iPhone8,4":                               return .iphoneSE
        case "iPhone9,1":                               return .iphone7
        case "iPhone9,2":                               return .iphone7p
        case "iPhone10,1", "iPhone10,4":                return .iphone8
        case "iPhone10,2", "iPhone10,5":                return .iphone8p
        case "iPhone10,3", "iPhone10,6":                return .iphoneX
        default:                                        return .other
        }
    }
    
}

// MARK: system
extension YQ {
    struct System {
        static var varsion: Float{
            return Float.init(UIDevice.current.systemVersion)!
        }
    }
}

// MARK: path
extension YQ{
    struct Sandbox {
        static var temp: String {
            return NSTemporaryDirectory()
        }
        static var documents: String {
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        }
        static var cache: String {
            return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        }
    }
}

// MARK: APP
extension YQ{
    struct App {
        static let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
        static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        static var bundleVersion: Int{
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
            return Int(version)!
        }
    }
}

// MARK: setting
extension YQ{
    struct SettingUrl {
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
}

// MARK: other
extension YQ{
    static func startTimer(time: TimeInterval, space: TimeInterval, handle: ((Int, TimeInterval) -> Void)? = nil, complete: (() -> Void)?) -> DispatchSourceTimer{
        var remain = time
        var number = 0
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: .seconds(Int(space)))
        timer.setEventHandler {
            if time > 0 && remain <= 0{
                timer.cancel()
                complete?()
            }else {
                handle?(number, remain)
                number = number + 1
                remain = remain - space
            }
        }
        timer.resume()
        return timer
    }
    
    static func copy(text: String){
        UIPasteboard.general.string = text
    }
    
    static func Log(_ items: Any..., separator: String = ", ", terminator: String = "\n"){
        #if DEBUG
        print(items, separator, terminator)
        #endif
    }
}
