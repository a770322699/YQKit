//
//  UIColorExtension.swift
//  MultifunctionCalculator
//
//  Created by maygolf on 2017/10/21.
//  Copyright © 2017年 yiquan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    class func yq_hexColor(hexValue: Int) -> UIColor{
        
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0x0000FF) / 255.0
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
