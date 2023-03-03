//
//  HZAppInfoViewController.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/3/2.
//

import UIKit

class HZAppInfoViewController: HZBaseViewController {

    fileprivate lazy var dataSource: [(String, [Any], HZDebugTableViewCellType)] = {
        let equipmentInfo = [("设备名称", HZAppInfo.deviceName), ("设备型号", "\(HZAppInfo.deviceType)（\(HZAppInfo.deviceTypeNumber)）"), ("系统版本", HZAppInfo.deviceSystemVersion), ("屏幕尺寸", HZAppInfo.deviceSize), ("分辨率", HZAppInfo.deviceResolutionRatio)]
        var appInfo = [("Bundle Id", HZAppInfo.bundleIdentifier ?? ""), ("版本号", HZAppInfo.appVersion), ("build号", HZAppInfo.appBuild)]
        if let _buildTime = HZAppInfo.buildTime {
            appInfo.append(("打包时间", _buildTime))
        }
        appInfo.append(("安装时间", HZAppInfo.installUpdateTime.install))
        if let _updateTime = HZAppInfo.installUpdateTime.update {
            appInfo.append(("更新时间", _updateTime))
        }

        HZAppInfo.getPushAuthorizationStatus { [weak self] (type, status, describe) in
            if var authorityInfo_ = self?.dataSource.last, authorityInfo_.1.count > 0 {
                guard let tuplesArray = authorityInfo_.1 as? [(String, String)], !(tuplesArray.compactMap({ $0.0 }).contains(type.name)) else { return }
                authorityInfo_.1.insert((type.name, describe), at: 0)
                self?.dataSource.remove(at: 2)
                self?.dataSource.append(authorityInfo_)
                DispatchQueue.main.async {
                    guard let _dataSource = self?.dataSource else { return }
                    self?.tableViewData = _dataSource
                    self?.tableViewPlain.reloadData()
                }
            }
        }
        let cameraAuthority = HZAppInfo.getCameraAuthorizationStatus()
        let photoAuthority = HZAppInfo.getPhotoAuthorizationStatus()
        let calendarAuthority = HZAppInfo.getCalendarAuthorizationStatus()
        let audioAuthority = HZAppInfo.getAudioAuthorizationStatus()
        let locationAuthority = HZAppInfo.getLocationAuthorizationStatus()
        let authorityInfo = [(cameraAuthority.type.name, cameraAuthority.status.describe), (photoAuthority.type.name, photoAuthority.status.describe), (calendarAuthority.type.name, calendarAuthority.status.describe), (audioAuthority.type.name, audioAuthority.status.describe), (locationAuthority.type.name, locationAuthority.status.describe)]
        return [("设备信息", equipmentInfo, .deviceAppInfo), ("App信息", appInfo, .deviceAppInfo), ("权限信息", authorityInfo, .deviceAppInfo)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewData = self.dataSource
        self.title = "设备&App信息"
        setTableView()
    }

}
