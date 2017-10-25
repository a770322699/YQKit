//
//  NSObjectExtension.swift
//  MultifunctionCalculator
//
//  Created by maygolf on 2017/10/11.
//  Copyright © 2017年 yiquan. All rights reserved.
//

import Foundation

extension NSObject{
    
    func yq_encode(_ aCoder: NSCoder){
        
        var outCount: UInt32 = 0
        
        guard let ivars = class_copyIvarList(self.classForCoder, &outCount) else {
            return
        }
        
        for index in 0..<Int(outCount) {
            let ivar = ivars[index]
            if let cString = ivar_getName(ivar){
                let name = String.init(cString: cString)
                aCoder.encode(self.value(forKey: name), forKey: name)
            }
        }
        
        free(ivars)
    }
    
    func yq_decode(_ aDecoder: NSCoder) {
        var outCount: UInt32 = 0
        
        guard let ivars = class_copyIvarList(self.classForCoder, &outCount) else{
            return
        }
        
        for index in 0..<Int(outCount) {
            let ivar = ivars[index]
            if let cString = ivar_getName(ivar){
                let name = String.init(cString: cString)
                self.setValue(aDecoder.decodeObject(forKey: name), forKey: name)
            }
        }
        
        free(ivars)
    }
}

extension NSObject{
    class var yq_className: String{
        return NSStringFromClass(self.classForCoder())
    }
}
