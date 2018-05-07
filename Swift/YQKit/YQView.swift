//
//  YQView.swift
//  BiuBiu
//
//  Created by meizu on 2018/4/3.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

// MARK: 坐标
extension YQValue where Value == UIView {
    var origin: CGPoint {
        get {
            return value.frame.origin
        }
        set {
            value.frame.origin = newValue
        }
    }
    
    var x: CGFloat {
        get {
            return origin.x
        }
        set {
            origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return origin.y
        }
        set {
            origin.y = newValue
        }
    }
    
    var maxY: CGFloat{
        get {
            return value.frame.maxY
        }
        
        set {
            y = newValue - height
        }
    }
    
    var maxX: CGFloat {
        get {
            return value.frame.maxX
        }
        
        set {
            x = newValue - width
        }
    }
    
    var size: CGSize {
        set {
            value.frame.size = newValue
        }
        get {
            return value.frame.size
        }
    }
    
    var height: CGFloat {
        get {
            return size.height
        }
        set {
            size.height = newValue
        }
    }
    
    var width: CGFloat{
        get {
            return size.width
        }
        set {
            size.width = newValue
        }
    }
    
    var center: CGPoint{
        get {
            return CGPoint.init(x: width / 2, y: height / 2)
        }
        set {
            origin = CGPoint.init(x: newValue.x - width / 2, y: newValue.y - height / 2)
        }
    }

}


extension YQValue where Value == UIView {
    func boarderRadiusMask(radius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor? = nil, mask: Bool = false) {
        value.layer.cornerRadius = radius
        value.layer.masksToBounds = mask
        value.layer.borderWidth = borderWidth
        value.layer.borderColor = borderColor?.cgColor
    }
}
