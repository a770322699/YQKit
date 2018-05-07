//
//  YQDictionary.swift
//  BiuBiu
//
//  Created by meizu on 2018/4/19.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation

extension Dictionary {
    var yq: YQValue<Dictionary>{
        return YQValue(value: self)
    }
}

extension YQValue where Value == Dictionary<String, Any> {
    func intValue(_ key: String) -> Int{
        return intOrNilValue(key) ?? 0
    }
    func intOrNilValue(_ key: String) -> Int? {
        let v = value[key]
        if v is Int {
            return v as? Int
        }else if v is String {
            return Int(v as! String)
        }
        return nil
    }
    
    func stringOrNilValue(_ key: String) -> String? {
        return value[key] as? String
    }
}
