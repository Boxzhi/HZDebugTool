//
//  HZAppInfo.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/3/2.
//

import UIKit
import Photos
import EventKit

public enum HZAuthorizationType {
    
    case push
    case camera
    case photo
    case calendar
    case audio
    case location
    
    var name: String {
        switch self {
        case .push:
            return "通知权限"
        case .camera:
            return "相机权限"
        case .photo:
            return "相册权限"
        case .calendar:
            return "日历权限"
        case .audio:
            return "麦克风权限"
        case .location:
            return "定位权限"
        }
    }
    
}

public enum HZAuthorizationStatus: Int {
    
    case unknown = -1
    case notDetermined = 0
    case restricted = 1
    case denied = 2
    case authorized = 3
    
    var describe: String {
        switch self {
        case .unknown:
            return "未知"
        case .notDetermined:
            return "尚未选择"
        case .restricted:
            return "家长控制"
        case .denied:
            return "未授权"
        case .authorized:
            return "已授权"
        }
    }
    
}

public struct HZAppInfo {

    /// App名称
    public static var appName: String {
        var appName: String = ""
        if let infoDictionary = Bundle.main.infoDictionary {
            if let bundleDisplayName = infoDictionary["CFBundleDisplayName"] as? String {
                appName = bundleDisplayName
            }else if let bundleName = infoDictionary["CFBundleName"] as? String {
                appName = bundleName
            }
        }
        return appName
    }
    
    /// App Bundle Identifier
    public static var bundleIdentifier: String? {
        return Bundle.main.bundleIdentifier
    }
    
    /// App版本号
    public static var appVersion: String {
        var appVersion: String = ""
        if let infoDictionary = Bundle.main.infoDictionary, let _appVersion = infoDictionary["CFBundleShortVersionString"] as? String {
            appVersion = _appVersion
        }
        return appVersion
    }
    
    /// App Build号
    public static var appBuild: String {
        var appBuild: String = ""
        if let infoDictionary = Bundle.main.infoDictionary, let _appBuild = infoDictionary["CFBundleVersion"] as? String {
            appBuild = _appBuild
        }
        return appBuild
    }
    
    /// 设备名称
    public static var deviceName: String {
        return UIDevice.current.name
    }
    
    /// 设备型号
    public static var deviceType: String {
        return UIDevice.current.modelName
    }
    
    /// 设备内部型号
    public static var deviceTypeNumber: String {
        return UIDevice.current.modelNumber
    }
    
    /// 设备系统版本
    public static var deviceSystemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// 设备屏幕尺寸
    public static var deviceSize: String {
        return String(format: "%.1f x %.1f", UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    }
    
    /// 设备分辨率
    public static var deviceResolutionRatio: String {
        return String(format: "%.1f x %.1f", UIScreen.main.bounds.size.width * UIScreen.main.scale, UIScreen.main.bounds.size.height * UIScreen.main.scale)
    }
    
    /// 设备UUID
    public static var deviceUuidString: String? {
        var _deviceUuidString = HZKeychainTool.getContentFromKeyChain(service: "com.yantu.YTVIPHD", account: "deviceUuidString")
        if _deviceUuidString == nil {
            _deviceUuidString = UIDevice.current.identifierForVendor?.uuidString
            if let deviceUuidString_ = _deviceUuidString {
                let _ = HZKeychainTool.saveContentFromKeyChain(content: deviceUuidString_, service: "com.yantu.YTVIPHD", account: "deviceUuidString")
            }
        }
        return _deviceUuidString
    }
    
    /// 打包时间
    public static var buildTime: String? {
        if let filePath = Bundle.main.path(forResource: "BuildInfo", ofType: "plist"),
            let dic = NSDictionary(contentsOfFile: filePath),
            let buildTime = dic["BuildTime"] as? String {
            return buildTime.replacingOccurrences(of: ",", with: " ")
        }
        return nil
    }

    /// 安装更新时间
    public static var installUpdateTime: (install: String, update: String?) {
        var time: (install: String, update: String?) = ("", nil)
        if let urlToDocumentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last, let fileAttribute = try? FileManager.default.attributesOfItem(atPath: urlToDocumentsFolder.path), let installDate = fileAttribute[.creationDate] as? Date {
            let installString = installDate.dateFormatString()
//            labelString.append("\n安装于：\(installString)")
//            var contrastData = installData
            time.install = installString
            if let bundlePath = Bundle.main.path(forResource: "Info", ofType: "plist"), let fileAttributes = try? FileManager.default.attributesOfItem(atPath: bundlePath), let updateDate = fileAttributes[.modificationDate] as? Date, updateDate > installDate {
                let updateString = updateDate.dateFormatString()
//                labelString.append("\n更新于：\(updateString)")
//                contrastData = updateData
                time.update = updateString
            }
//            if let fileAttributes = try? FileManager.default.attributesOfItem(atPath: Bundle.main.bundlePath + "/Frameworks"), let coverUpdateData = fileAttributes[.modificationDate] as? Date {
//                if coverUpdateData > contrastData, coverUpdateData.timeIntervalSince1970 - contrastData.timeIntervalSince1970 > 60.0 {
//                    let coverUpdateString = coverUpdateData.toString(format: "yyyy-MM-dd HH:mm:ss")
//                    labelString.append("\n覆盖于：\(coverUpdateString)")
//                }
//            }
        }
        return time
    }
    
    /// 通知权限
    /// - Returns: 返回权限类型及权限状态
    public static func getPushAuthorizationStatus(completionHandler: (((type: HZAuthorizationType, status: UNAuthorizationStatus, describe: String)) -> Void)? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { notificationSettings in
            var describe = ""
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                describe = "尚未选择"
            case .denied:
                describe = "未授权"
            case .authorized, .provisional:
                describe = "已授权"
            case .ephemeral:
                describe = "临时授权"
            default:
                break
            }
            completionHandler?((.push, notificationSettings.authorizationStatus, describe))
        }
    }
    
    /// 相机权限
    /// - Returns: 返回权限类型及权限状态
    public static func getCameraAuthorizationStatus() -> (type: HZAuthorizationType, status: HZAuthorizationStatus) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        return (.camera, HZAuthorizationStatus(rawValue: authStatus.rawValue) ?? .unknown)
    }
    
    /// 相册权限
    /// - Returns: 返回权限类型及权限状态
    public static func  getPhotoAuthorizationStatus() -> (type: HZAuthorizationType, status: HZAuthorizationStatus) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        return (.photo, HZAuthorizationStatus(rawValue: authStatus.rawValue) ?? .unknown)
    }
    
    /// 日历权限
    /// - Returns: 返回权限类型及权限状态
    public static func getCalendarAuthorizationStatus() -> (type: HZAuthorizationType, status: HZAuthorizationStatus) {
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        return (.calendar, HZAuthorizationStatus(rawValue: authStatus.rawValue) ?? .unknown)
    }
    
    /// 麦克风权限
    /// - Returns: 返回权限类型及权限状态
    public static func getAudioAuthorizationStatus() -> (type: HZAuthorizationType, status: HZAuthorizationStatus) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        return (.audio, HZAuthorizationStatus(rawValue: authStatus.rawValue) ?? .unknown)
    }
    
    /// 定位权限
    /// - Returns: 返回权限类型及权限状态
    public static func getLocationAuthorizationStatus() -> (type: HZAuthorizationType, status: HZAuthorizationStatus) {
        if #available(iOS 14.0, *) {
            let authStatus = CLLocationManager().authorizationStatus
            return (.location, HZAuthorizationStatus(rawValue: Int(authStatus.rawValue == 4 ? 3 : authStatus.rawValue)) ?? .unknown)
        } else {
            let authStatus = CLLocationManager.authorizationStatus()
            return (.location, HZAuthorizationStatus(rawValue: Int(authStatus.rawValue == 4 ? 3 : authStatus.rawValue)) ?? .unknown)
        }
    }
    
}

