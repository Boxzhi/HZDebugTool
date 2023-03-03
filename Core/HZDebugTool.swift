//
//  HZDebugTool.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/2/20.
//

public enum HZDebugTableViewCellType {
    case requestEnvironment // 请求地址环境
    case accountLogin // 账号登录
    case testItem // 测试项目
    case customItem // 自定义
    case manualInput // 手动输入
    case accountList // 账号
    case deviceAppInfo // 设备App信息
}

public protocol HZDebugToolDelegate: AnyObject {
    
    /// 当前请求环境
    func debugToolOfCurrentEnvironment() -> String
    
    /// 可用请求环境数组
    func debugToolOfRequestEnvironments() -> [String]
    
    /// 选择的请求环境
    func debugToolSelectEnvironment(_ row: Int) -> Void
    
    /// 当前已登录账号
    func debugToolOfCurrentLoginAccount() -> String?
    
    /// 可用登录账号数组
    func debugToolOfLoginAccounts() -> [String: [String: String]]
    
    /// 选择的登录账号
    func debugToolSelectAccount(_ accountType: String, account: String, password: String, loginSuccessHandler: @escaping () -> Void) -> Void
    
    /// 删除账号
    func debugToolDeleteAccount(_ accountType: String, account: String, password: String, deleteSuccessHandler: @escaping () -> Void) -> Void
    
    /// token登录
    func debugToolInputToken(_ token: String) -> Void
    
    /// 自定义itemcell
    func debugToolOfCustomItem() -> [String: [(String, String)]]
    
    /// 自定义itemcell点击
    func debugToolDidCustomItem(_ headerTitle: String, cellData: Any, row: Int, didSuccessHandler: @escaping () -> Void) -> Void
    
    // debug工具被关闭
    func debugToolClose() -> Void
    
}

public struct HZDebugTool {

    public static weak var delegate: HZDebugToolDelegate?
    
    public var themeColor: UIColor = UIColor(red: 73.0/255.0, green: 79.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
    public static var `default`: HZDebugTool { return HZDebugTool() }
    
    public static func openDebugTool(_ delegate: HZDebugToolDelegate) {
        #if DEBUG
        self.delegate = delegate
        UIApplication.shared.keyWindow?.rootViewController?.present(HZNavigationController(rootViewController: HZHomeViewController()), animated: true)
        #endif
    }
    
}
