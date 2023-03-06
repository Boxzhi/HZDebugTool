//
//  DictionaryExtension.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/3/6.
//

import UIKit

extension Dictionary {
    
    public func toJsonString() -> String? {
        guard let dicData = try? JSONSerialization.data(withJSONObject: self) else {
            return nil
        }
        guard let str = String(data: dicData, encoding: .utf8) else {
            return nil
        }
        return str
    }
    
}
