//
//  HZHomeViewController.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/3/2.
//

import UIKit

class HZHomeViewController: HZBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Debug工具"
        self.reloadData()
        self.setTableView()
    }
    
    fileprivate func reloadData() {
        var dataSource: [(String, [Any], HZDebugTableViewCellType)] = [("账号登录", ["选择账号", "token登录"], .accountLogin), ("测试项目", ["测试入口", "测试H5地址"], .testItem), ("设置&信息", ["设备&App信息", "应用设置"], .deviceAppInfo)]
        if let _environments = HZDebugTool.delegate?.debugToolOfRequestEnvironments() {
            dataSource = [("请求地址环境", _environments, .requestEnvironment)] + dataSource
        }
        if let _customItems = HZDebugTool.delegate?.debugToolOfCustomItem() {
            _customItems.forEach { keyValue in
                dataSource += [(keyValue.key, keyValue.value, .customItem)]
            }
        }
        self.tableViewData = dataSource
        self.tableViewPlain.reloadData()
    }

    override func cellForRowAction(tableView: UITableView, cell: HZDebugTableViewCell, indexPath: IndexPath, cellType: HZDebugTableViewCellType, cellData: Any) {
        if cellType == .requestEnvironment, let _cellData = cellData as? String {
            let attributedText = NSMutableAttributedString(string: _cellData, attributes: [.foregroundColor: UIColor(red: 10.0/255.0, green: 13.0/255.0, blue: 15.0/255.0, alpha: 1.0)])
            if let _currentEnvironment = HZDebugTool.delegate?.debugToolOfCurrentEnvironment(), _cellData.contains(_currentEnvironment) {
                attributedText.append(NSAttributedString(string: "（当前环境）", attributes: [.foregroundColor: UIColor(red: 252.0/255.0, green: 31.0/255.0, blue: 57.0/255.0, alpha: 1.0)]))
            }
            cell.titleAttributedText = attributedText
        }else if cellType == .accountLogin, indexPath.row == 0, let _loginAccount = HZDebugTool.delegate?.debugToolOfCurrentLoginAccount() {
            let attributedText = NSMutableAttributedString(string: "已登账号：\(_loginAccount)", attributes: [.foregroundColor: UIColor(red: 10.0/255.0, green: 13.0/255.0, blue: 15.0/255.0, alpha: 1.0)])
            if let _currentEnvironment = HZDebugTool.delegate?.debugToolOfCurrentEnvironment() {
                attributedText.append(NSAttributedString(string: "（\(_currentEnvironment)）", attributes: [.foregroundColor: UIColor(red: 252.0/255.0, green: 31.0/255.0, blue: 57.0/255.0, alpha: 1.0)]))
            }
            cell.titleAttributedText = attributedText
        }
    }
    
    override func didSelectRowAction(tableView: UITableView, indexPath: IndexPath, cellType: HZDebugTableViewCellType, cellData: Any) {
        if cellType == .requestEnvironment {
            HZDebugTool.delegate?.debugToolSelectEnvironment(indexPath.row)
            self.backToLastViewController()
        }else if cellType == .accountLogin {
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(HZAccountListViewController(), animated: true)
            }else {
                HZAlertController.showInputBox("输入要登录的token\n切记：先切环境后再输token", title: "token登录", placeholder: "请输入token") { token in
                    HZDebugTool.delegate?.debugToolInputToken(token)
                }
            }
        }else if cellType == .deviceAppInfo {
            if indexPath.row == 0 { // 设备&App信息
                self.navigationController?.pushViewController(HZAppInfoViewController(), animated: true)
            }else { // 应用设置
                if let setUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(setUrl) {
                    UIApplication.shared.open(setUrl, options: [:], completionHandler: nil)
                }
            }
        }else if cellType == .customItem {
            HZDebugTool.delegate?.debugToolDidCustomItem(self.tableViewData[indexPath.section].0, cellData: self.tableViewData[indexPath.section].1[indexPath.row], row: indexPath.row, didSuccessHandler: {
                self.reloadData()
            })
        }
    }
    
}
