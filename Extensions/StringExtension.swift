//
//  StringExtension.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/3/6.
//

import UIKit

extension String {
    
    public func toDictionary() -> [String: Any] {
        var result: [String : Any] = [:]
        guard !self.isEmpty else { return result }
        guard let dataSelf = self.data(using: .utf8) else { return result }
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf, options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
    }
    
}
