//
//  YQObject.swift
//  BiuBiu
//
//  Created by meizu on 2018/4/3.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    var yqObjc: YQValue<NSObject>{
        return YQValue(value: self)
    }
    
    var yqView: YQValue<UIView>!{
        return self is UIView ? YQValue(value: self as! UIView) : nil
    }
    
    var yqTableView: YQValue<UITableView>!{
        return self is UITableView ? YQValue(value: self as! UITableView) : nil
    }
    
    var yqImage: YQValue<UIImage>!{
        return self is UIImage ? YQValue(value: self as! UIImage) : nil
    }
    
    var yqString: YQValue<String>!{
        return self is String ? YQValue(value: self as! String) : nil
    }
}
