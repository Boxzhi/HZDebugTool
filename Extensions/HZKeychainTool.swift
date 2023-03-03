//
//  HZKeychainTool.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/3/2.
//

public struct HZKeychainTool {
        
    /// 存入内容
    /// - Parameters:
    ///   - content: 内容
    ///   - service: 服务名
    ///   - account: 键名
    /// - Returns: 是否存储成功
    public static func saveContentFromKeyChain(content: String, service: String, account: String) -> Bool {
        return SAMKeychain.setPassword(content, forService: service, account: account)
    }
    
    /// 取出内容
    /// - Parameters:
    ///   - service: 服务名
    ///   - account: 键名
    /// - Returns: 内容
    public static func getContentFromKeyChain(service: String, account: String) -> String? {
        return SAMKeychain.password(forService: service, account: account)
    }
    
    /// 移除内容
    /// - Parameters:
    ///   - service: 服务名
    ///   - account: 键名
    /// - Returns: 是否移除成功
    public static func removeContentFromKeyChain(service: String, account: String) -> Bool {
        return SAMKeychain.deletePassword(forService: service, account: account)
    }
    
}
